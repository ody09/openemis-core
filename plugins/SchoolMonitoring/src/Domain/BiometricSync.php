<?php
declare(strict_types=1);

namespace SchoolMonitoring\Domain;

use PDO;

final class BiometricSync
{
    public function __construct(private PDO $pdo, private int $minGapMinutes = 5)
    {
    }

    /**
     * @param list<array{staff_id:int, punched_at:string}> $punches
     * @return array{time_in: string, time_out: ?string}
     */
    public function collapseDay(array $punches): array
    {
        usort($punches, static fn ($a, $b) => strcmp($a['punched_at'], $b['punched_at']));
        $first = $punches[0]['punched_at'];
        $last = $punches[array_key_last($punches)]['punched_at'];
        $gap = (strtotime($last) - strtotime($first)) / 60;
        $timeOut = $gap >= $this->minGapMinutes ? $last : null;

        return ['time_in' => $first, 'time_out' => $timeOut];
    }

    public function sourceIsManual(int $staffId, int $institutionId, string $date): bool
    {
        $stmt = $this->pdo->prepare(
            'SELECT source FROM sm_staff_attendance_sources WHERE staff_id = ? AND institution_id = ? AND attendance_date = ?'
        );
        $stmt->execute([$staffId, $institutionId, $date]);
        $source = $stmt->fetchColumn();

        return $source === 'manual';
    }

    public function markSource(int $staffId, int $institutionId, string $date, string $source): void
    {
        $find = $this->pdo->prepare(
            'SELECT id FROM sm_staff_attendance_sources WHERE staff_id = ? AND institution_id = ? AND attendance_date = ?'
        );
        $find->execute([$staffId, $institutionId, $date]);
        $id = $find->fetchColumn();
        if ($id) {
            $this->pdo->prepare('UPDATE sm_staff_attendance_sources SET source = ? WHERE id = ?')->execute([$source, $id]);
            return;
        }
        $this->pdo->prepare(
            'INSERT INTO sm_staff_attendance_sources (staff_id, institution_id, attendance_date, source) VALUES (?, ?, ?, ?)'
        )->execute([$staffId, $institutionId, $date, $source]);
    }

    public function verifyDeviceSignature(string $secret, string $body, string $timestamp, string $signature, int $skewSeconds = 300): bool
    {
        if (abs(time() - (int)$timestamp) > $skewSeconds) {
            return false;
        }
        $expected = hash_hmac('sha256', $timestamp . '.' . $body, $secret);

        return hash_equals($expected, $signature);
    }

    public function applyQueued(?int $academicPeriodId = null): int
    {
        $sql = 'SELECT p.*, d.institution_id
                FROM sm_biometric_punches p
                JOIN sm_biometric_devices d ON d.id = p.device_id
                WHERE p.processed_at IS NULL AND p.staff_id IS NOT NULL
                ORDER BY p.punched_at ASC';
        $rows = $this->pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC) ?: [];
        $groups = [];
        foreach ($rows as $row) {
            $date = substr((string)$row['punched_at'], 0, 10);
            $key = $row['staff_id'] . '|' . $row['institution_id'] . '|' . $date;
            $groups[$key][] = $row;
        }

        $applied = 0;
        $now = gmdate('Y-m-d H:i:s');
        foreach ($groups as $key => $punches) {
            [$staffId, $institutionId, $date] = explode('|', $key, 3);
            $staffId = (int)$staffId;
            $institutionId = (int)$institutionId;
            $ids = array_map(static fn ($row) => (int)$row['id'], $punches);
            if ($this->sourceIsManual($staffId, $institutionId, $date)) {
                $this->markProcessed($ids, 'skipped_manual', $now);
                continue;
            }
            $collapsed = $this->collapseDay(array_map(static fn ($row) => [
                'staff_id' => (int)$row['staff_id'],
                'punched_at' => (string)$row['punched_at'],
            ], $punches));
            $this->upsertAttendance($staffId, $institutionId, $date, $collapsed, $academicPeriodId);
            $this->markSource($staffId, $institutionId, $date, 'biometric');
            $this->markProcessed($ids, 'applied', $now);
            $applied++;
        }

        return $applied;
    }

    /** @param list<int> $ids */
    private function markProcessed(array $ids, string $result, string $now): void
    {
        if ($ids === []) {
            return;
        }
        $placeholders = implode(',', array_fill(0, count($ids), '?'));
        $params = array_merge([$result, $now], $ids);
        $this->pdo->prepare("UPDATE sm_biometric_punches SET result = ?, processed_at = ? WHERE id IN ($placeholders)")
            ->execute($params);
    }

    /** @param array{time_in: string, time_out: ?string} $times */
    private function upsertAttendance(int $staffId, int $institutionId, string $date, array $times, ?int $academicPeriodId): void
    {
        $isSqlite = $this->pdo->getAttribute(PDO::ATTR_DRIVER_NAME) === 'sqlite';
        if ($isSqlite) {
            $check = $this->pdo->query("SELECT name FROM sqlite_master WHERE type='table' AND name='institution_staff_attendances'");
            if (!$check || !$check->fetchColumn()) {
                return;
            }
        }
        $find = $this->pdo->prepare(
            'SELECT id FROM institution_staff_attendances WHERE staff_id = ? AND institution_id = ? AND date = ?'
        );
        $find->execute([$staffId, $institutionId, $date]);
        $id = $find->fetchColumn();
        $period = $academicPeriodId ?? $this->currentPeriodId();
        $timeIn = substr($times['time_in'], 11, 8) ?: $times['time_in'];
        $timeOut = $times['time_out'] ? (substr($times['time_out'], 11, 8) ?: $times['time_out']) : null;
        if ($id) {
            $this->pdo->prepare(
                'UPDATE institution_staff_attendances SET time_in = ?, time_out = ?, modified = ? WHERE id = ?'
            )->execute([$timeIn, $timeOut, gmdate('Y-m-d H:i:s'), $id]);
            return;
        }
        $newId = sprintf(
            '%08s-%04s-%04s-%04s-%12s',
            bin2hex(random_bytes(4)),
            bin2hex(random_bytes(2)),
            bin2hex(random_bytes(2)),
            bin2hex(random_bytes(2)),
            bin2hex(random_bytes(6))
        );
        $this->pdo->prepare(
            'INSERT INTO institution_staff_attendances
                (id, staff_id, institution_id, academic_period_id, date, time_in, time_out, created_user_id, created)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
        )->execute([$newId, $staffId, $institutionId, $period, $date, $timeIn, $timeOut, 1, gmdate('Y-m-d H:i:s')]);
    }

    private function currentPeriodId(): ?int
    {
        try {
            $id = $this->pdo->query('SELECT id FROM academic_periods WHERE current = 1 ORDER BY id DESC LIMIT 1');
            $value = $id ? $id->fetchColumn() : false;
            return $value ? (int)$value : null;
        } catch (\Throwable $e) {
            return null;
        }
    }
}
