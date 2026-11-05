<?php
declare(strict_types=1);

// Read-only validation against the local demo setup; invalid dates must prevent saving.
chdir(dirname(__DIR__, 2));
require 'vendor/autoload.php';
require 'config/bootstrap.php';
set_error_handler(static function ($level) { return in_array($level, [E_USER_DEPRECATED, E_DEPRECATED], true); });
\Cake\Core\Configure::write('Error.errorLevel', E_ALL & ~E_USER_DEPRECATED & ~E_DEPRECATED);
$db = \Cake\Datasource\ConnectionManager::get('default');
$student = $db->execute('SELECT id FROM security_users WHERE is_student=1 ORDER BY id LIMIT 1')->fetch('assoc');
$step = $db->execute("SELECT s.id FROM workflow_steps s JOIN workflows w ON w.id=s.workflow_id WHERE w.name='Student Admission' AND s.name='Open' LIMIT 1")->fetch('assoc');
if (!$student || !$step) throw new RuntimeException('Local demo student and admission workflow required.');
$controller = (new ReflectionClass(\Institution\Controller\InstitutionsController::class))->newInstanceWithoutConstructor();
$controller->Auth = new class { public function user($key) { return 1; } };
$method = new ReflectionMethod($controller, 'handleStudentInstitutionData');
$result = $method->invoke($controller, [
    'institution_id' => 1, 'academic_period_id' => 34, 'education_grade_id' => 221,
    'student_admission_status_value' => (int)$step['id'],
    'start_date' => '2999-01-01', 'end_date' => '2025-12-31',
], (int)$student['id'], 1);
if (empty($result['errors']['start_date']['ruleInAcademicPeriod'])) {
    fwrite(STDERR, "FAIL: pending admission hides the invalid start-date reason.\n");
    exit(1);
}
echo "PASS: rejected pending admission returns field-level date errors.\n";
