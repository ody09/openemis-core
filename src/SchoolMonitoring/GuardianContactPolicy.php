<?php
declare(strict_types=1);

namespace App\SchoolMonitoring;

use PDO;

final class GuardianContactPolicy
{
    public const MESSAGE = 'أكمل بيانات ولي الأمر ورقم هاتفه الأساسي قبل إلحاق الطالب بالمدرسة. يمكن حفظ الملف كقبول قيد الانتظار، ثم إضافة ولي الأمر ورقمه من تبويب جهات الاتصال.';

    public function __construct(private PDO $pdo)
    {
    }

    public function hasPrimaryPhone(int $studentId): bool
    {
        $query = $this->pdo->prepare(
            "SELECT c.value FROM student_guardians g
             INNER JOIN user_contacts c ON c.security_user_id = g.guardian_id
             INNER JOIN contact_types t ON t.id = c.contact_type_id
             INNER JOIN contact_options o ON o.id = t.contact_option_id
             WHERE g.student_id = ? AND c.preferred = 1 AND o.code IN ('MOB', 'PHO')"
        );
        $query->execute([$studentId]);
        foreach ($query->fetchAll(PDO::FETCH_COLUMN) as $phone) {
            if ($this->isPhone($phone)) {
                return true;
            }
        }
        return false;
    }

    public function phones(int $guardianId): array
    {
        $query = $this->pdo->prepare(
            "SELECT c.value, c.preferred FROM user_contacts c
             INNER JOIN contact_types t ON t.id = c.contact_type_id
             INNER JOIN contact_options o ON o.id = t.contact_option_id
             WHERE c.security_user_id = ? AND o.code IN ('MOB', 'PHO')
             ORDER BY c.preferred DESC, c.id ASC"
        );
        $query->execute([$guardianId]);
        $phones = ['primary' => '', 'secondary' => ''];
        foreach ($query->fetchAll(PDO::FETCH_ASSOC) as $contact) {
            if (!$this->isPhone($contact['value'])) {
                continue;
            }
            $value = trim($contact['value']);
            if ($contact['preferred'] && $phones['primary'] === '') {
                $phones['primary'] = $value;
            } elseif ($phones['secondary'] === '' && $value !== $phones['primary']) {
                $phones['secondary'] = $value;
            }
        }
        return $phones;
    }

    private function isPhone(?string $phone): bool
    {
        return preg_match('/^\+?[0-9٠-٩۰-۹][0-9٠-٩۰-۹\s().-]*$/u', trim($phone ?? '')) === 1;
    }
}
