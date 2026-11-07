<?php
declare(strict_types=1);

namespace SchoolMonitoring\Test\TestCase\Domain;

use PHPUnit\Framework\TestCase;
use SchoolMonitoring\Domain\BiometricSync;

final class BiometricSyncTest extends TestCase
{
    public function testCollapseKeepsLastPunchWhenGapMet(): void
    {
        $sync = new BiometricSync(SqliteFactory::pdo());
        $result = $sync->collapseDay([
            ['staff_id' => 1, 'punched_at' => '2026-11-07 07:00:00'],
            ['staff_id' => 1, 'punched_at' => '2026-11-07 14:05:00'],
        ]);
        $this->assertSame('2026-11-07 07:00:00', $result['time_in']);
        $this->assertSame('2026-11-07 14:05:00', $result['time_out']);
    }

    public function testCollapseIgnoresBouncePunches(): void
    {
        $sync = new BiometricSync(SqliteFactory::pdo());
        $result = $sync->collapseDay([
            ['staff_id' => 1, 'punched_at' => '2026-11-07 07:00:00'],
            ['staff_id' => 1, 'punched_at' => '2026-11-07 07:02:00'],
        ]);
        $this->assertNull($result['time_out']);
    }

    public function testSignatureWindow(): void
    {
        $sync = new BiometricSync(SqliteFactory::pdo());
        $body = '{"punches":[]}';
        $ts = (string)time();
        $sig = hash_hmac('sha256', $ts . '.' . $body, 'device-secret');
        $this->assertTrue($sync->verifyDeviceSignature('device-secret', $body, $ts, $sig));
        $this->assertFalse($sync->verifyDeviceSignature('device-secret', $body, (string)(time() - 400), $sig));
    }

    public function testManualSourceIsNotOverwritten(): void
    {
        $pdo = SqliteFactory::pdo();
        $pdo->exec("CREATE TABLE institution_staff_attendances (
            id TEXT PRIMARY KEY,
            staff_id INT, institution_id INT, academic_period_id INT, date TEXT,
            time_in TEXT, time_out TEXT, created_user_id INT, created TEXT, modified TEXT
        )");
        $pdo->exec("INSERT INTO sm_biometric_devices (institution_id, serial_number, api_key_hash, active)
                    VALUES (4, 'DEV1', 'hash', 1)");
        $deviceId = (int)$pdo->lastInsertId();
        $pdo->exec("INSERT INTO sm_biometric_punches (device_id, device_user_id, staff_id, punched_at, received_at, result)
                    VALUES ($deviceId, 'u1', 9, '2026-11-07 07:00:00', '2026-11-07 07:00:05', 'queued')");
        $sync = new BiometricSync($pdo);
        $sync->markSource(9, 4, '2026-11-07', 'manual');
        $applied = $sync->applyQueued(1);
        $this->assertSame(0, $applied);
        $count = (int)$pdo->query('SELECT COUNT(*) FROM institution_staff_attendances')->fetchColumn();
        $this->assertSame(0, $count);
    }

    public function testApplyQueuedWritesAttendance(): void
    {
        $pdo = SqliteFactory::pdo();
        $pdo->exec("CREATE TABLE institution_staff_attendances (
            id TEXT PRIMARY KEY,
            staff_id INT, institution_id INT, academic_period_id INT, date TEXT,
            time_in TEXT, time_out TEXT, created_user_id INT, created TEXT, modified TEXT
        )");
        $pdo->exec("INSERT INTO sm_biometric_devices (institution_id, serial_number, api_key_hash, active)
                    VALUES (4, 'DEV1', 'hash', 1)");
        $deviceId = (int)$pdo->lastInsertId();
        $pdo->exec("INSERT INTO sm_biometric_punches (device_id, device_user_id, staff_id, punched_at, received_at, result)
                    VALUES ($deviceId, 'u1', 9, '2026-11-07 07:00:00', '2026-11-07 07:00:05', 'queued'),
                           ($deviceId, 'u1', 9, '2026-11-07 14:00:00', '2026-11-07 14:00:05', 'queued')");
        $applied = (new BiometricSync($pdo))->applyQueued(1);
        $this->assertSame(1, $applied);
        $row = $pdo->query('SELECT * FROM institution_staff_attendances')->fetch(\PDO::FETCH_ASSOC);
        $this->assertSame('07:00:00', $row['time_in']);
        $this->assertSame('14:00:00', $row['time_out']);
    }
}
