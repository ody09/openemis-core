<?php
declare(strict_types=1);

namespace SchoolMonitoring\Controller;

use Cake\Event\EventInterface;
use Cake\Http\Exception\ForbiddenException;
use SchoolMonitoring\Domain\BiometricSync;
use SchoolMonitoring\Domain\Schema;

class BiometricController extends AppController
{
    public function initialize(): void
    {
        parent::initialize();
        $this->autoRender = false;
    }

    public function beforeFilter(EventInterface $event)
    {
        $this->Auth->allow(['punches']);
        if ($this->request->getParam('action') === 'punches') {
            return;
        }
        parent::beforeFilter($event);
    }

    public function punches()
    {
        if (!$this->request->is('post')) {
            $this->response = $this->response->withStatus(405);
            return $this->response;
        }
        $pdo = $this->getTableLocator()->get('Institution.Institutions')->getConnection()->getDriver()->getConnection();
        Schema::install($pdo);
        $serial = (string)$this->request->getHeaderLine('X-Device-Serial');
        $timestamp = (string)$this->request->getHeaderLine('X-Timestamp');
        $signature = (string)$this->request->getHeaderLine('X-Signature');
        $body = (string)$this->request->getBody();
        $stmt = $pdo->prepare('SELECT * FROM sm_biometric_devices WHERE serial_number = ? AND active = 1');
        $stmt->execute([$serial]);
        $device = $stmt->fetch(\PDO::FETCH_ASSOC);
        if (!$device) {
            throw new ForbiddenException('unknown_device');
        }
        $sync = new BiometricSync($pdo);
        if (!$sync->verifyDeviceSignature((string)$device['api_key_hash'], $body, $timestamp, $signature)) {
            throw new ForbiddenException('bad_signature');
        }
        $payload = json_decode($body, true) ?: $this->request->getData();
        $punches = $payload['punches'] ?? [];
        $stored = 0;
        foreach ($punches as $punch) {
            $deviceUser = (string)($punch['device_user_id'] ?? '');
            $map = $pdo->prepare('SELECT staff_id FROM sm_biometric_staff_ids WHERE institution_id = ? AND device_user_id = ?');
            $map->execute([(int)$device['institution_id'], $deviceUser]);
            $staffId = $map->fetchColumn() ?: null;
            try {
                $pdo->prepare(
                    'INSERT INTO sm_biometric_punches (device_id, device_user_id, staff_id, punched_at, received_at, raw_payload, result)
                     VALUES (?, ?, ?, ?, ?, ?, ?)'
                )->execute([
                    $device['id'],
                    $deviceUser,
                    $staffId,
                    (string)($punch['punched_at'] ?? ''),
                    gmdate('Y-m-d H:i:s'),
                    json_encode($punch),
                    $staffId ? 'queued' : 'unmapped',
                ]);
                $stored++;
            } catch (\Throwable $e) {
                // Duplicate punch.
            }
        }
        $pdo->prepare('UPDATE sm_biometric_devices SET last_seen_at = ? WHERE id = ?')->execute([gmdate('Y-m-d H:i:s'), $device['id']]);
        $this->response = $this->response->withType('application/json')
            ->withStringBody(json_encode(['stored' => $stored], JSON_THROW_ON_ERROR));
        return $this->response;
    }
}
