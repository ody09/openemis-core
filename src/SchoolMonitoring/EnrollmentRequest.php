<?php
declare(strict_types=1);

namespace App\SchoolMonitoring;

use InvalidArgumentException;
use PDO;

final class EnrollmentRequest
{
    public static function isImmediate(array $data): bool
    {
        $status = $data['student_admission_status_value'] ?? null;
        if ((!is_int($status) && !is_string($status)) || preg_match('/^(0|[1-9][0-9]*)$/D', (string)$status) !== 1) {
            throw new InvalidArgumentException('اختر حالة قبول صحيحة قبل حفظ الطالب.');
        }
        return (string)$status === '0';
    }

    public static function validate(array $data, PDO $pdo): bool
    {
        if (self::isImmediate($data)) {
            return true;
        }
        $query = $pdo->prepare(
            "SELECT s.id FROM workflow_steps s INNER JOIN workflows w ON w.id = s.workflow_id
             WHERE s.id = ? AND w.name IN ('Student Admission', 'Student Enrolment')"
        );
        $query->execute([$data['student_admission_status_value']]);
        if (!$query->fetchColumn()) {
            throw new InvalidArgumentException('اختر حالة قبول أو تسجيل قيد الانتظار من الخيارات المتاحة.');
        }
        return false;
    }
}
