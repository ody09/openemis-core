<?php
declare(strict_types=1);

namespace App\SchoolMonitoring;

use Cake\Database\Connection;
use Cake\Utility\Text;
use InvalidArgumentException;

final class LearningGoalExample
{
    public function __construct(private Connection $connection)
    {
    }

    public function create(int $periodId, int $gradeId, int $userId): int
    {
        $period = $this->connection->execute('SELECT start_date, end_date FROM academic_periods WHERE id = ?', [$periodId])->fetch('assoc');
        $grade = $this->connection->execute(
            'SELECT g.id FROM education_grades g
             JOIN education_programmes p ON p.id = g.education_programme_id
             JOIN education_cycles c ON c.id = p.education_cycle_id
             JOIN education_levels l ON l.id = c.education_level_id
             JOIN education_systems s ON s.id = l.education_system_id
             WHERE g.id = ? AND s.academic_period_id = ?', [$gradeId, $periodId]
        )->fetch('assoc');
        $user = $this->connection->execute('SELECT id FROM security_users WHERE id = ?', [$userId])->fetch('assoc');
        if (!$period || !$grade || !$user) {
            throw new InvalidArgumentException('Select an existing academic period, a grade belonging to that period, and an existing author.');
        }

        return $this->connection->transactional(function () use ($periodId, $gradeId, $userId, $period): int {
            $existing = $this->connection->execute(
                'SELECT id, education_grade_id FROM competency_templates WHERE code = ? AND academic_period_id = ?',
                ['DEMO-WRITE-NAME', $periodId]
            )->fetch('assoc');
            if ($existing) {
                if ((int)$existing['education_grade_id'] !== $gradeId) {
                    throw new InvalidArgumentException('This period already has the example in another grade. Manage additional goals through Competencies.');
                }
                return (int)$existing['id'];
            }
            $audit = ['created_user_id' => $userId, 'created' => date('Y-m-d H:i:s')];
            $grading = $this->connection->execute('SELECT id FROM competency_grading_types WHERE code = ?', ['DEMO-SKILL'])->fetch('assoc');
            if ($grading) {
                $gradingId = (int)$grading['id'];
            } else {
                $gradingId = $this->insert('competency_grading_types', ['code' => 'DEMO-SKILL', 'name' => 'تجريبي — مستوى إتقان المهارة'] + $audit);
                foreach (['NOT_YET' => 'لم يتقن', 'WITH_HELP' => 'يتقن بمساعدة', 'INDEPENDENT' => 'يتقن مستقلًا'] as $code => $name) {
                    $this->insert('competency_grading_options', [
                        'code' => $code, 'name' => $name, 'description' => $name,
                        'competency_grading_type_id' => $gradingId,
                    ] + $audit);
                }
            }
            $scope = ['academic_period_id' => $periodId];
            $templateId = $this->insert('competency_templates', [
                'code' => 'DEMO-WRITE-NAME', 'name' => 'تجريبي — أهداف التعلم للمرحلة',
                'description' => 'مثال للمناقشة مع المؤسسة، وليس منهجًا معتمدًا. عدم التقييم يبقى بلا نتيجة.',
                'education_grade_id' => $gradeId,
            ] + $scope + $audit);
            $scope['competency_template_id'] = $templateId;
            $itemId = $this->insert('competency_items', ['name' => 'مهارات الكتابة'] + $scope + $audit);
            $this->insert('competency_criterias', [
                'code' => 'WRITE-NAME', 'name' => 'يكتب اسمه', 'competency_item_id' => $itemId,
                'competency_grading_type_id' => $gradingId,
            ] + $scope + $audit);
            $periodKey = $this->insert('competency_periods', [
                'code' => 'DEMO-END', 'name' => 'تجريبي — نهاية المرحلة',
                'start_date' => $period['start_date'], 'end_date' => $period['end_date'],
                'date_enabled' => date('Y-m-d'), 'date_disabled' => date('Y-m-d', strtotime('+30 days')),
            ] + $scope + $audit);
            $this->connection->insert('competency_items_periods', [
                'id' => Text::uuid(), 'competency_item_id' => $itemId, 'competency_period_id' => $periodKey,
            ] + $scope + $audit);
            return $templateId;
        });
    }

    private function insert(string $table, array $values): int
    {
        return (int)$this->connection->insert($table, $values)->lastInsertId($table);
    }
}
