<?php
declare(strict_types=1);

use App\SchoolMonitoring\EnrollmentRequest;
use PHPUnit\Framework\TestCase;

final class EnrollmentRequestTest extends TestCase
{
    /** @dataProvider invalidStatuses */
    public function testAmbiguousStatusIsRejectedBeforeAnySave(array $data): void
    {
        $this->assertTrue(class_exists(EnrollmentRequest::class), 'Shared enrollment status validation is missing.');
        $this->expectException(InvalidArgumentException::class);
        EnrollmentRequest::isImmediate($data);
    }

    public static function invalidStatuses(): array
    {
        return [[[]], [['student_admission_status_value' => null]], [['student_admission_status_value' => '']],
            [['student_admission_status_value' => '00']], [['student_admission_status_value' => false]],
            [['student_admission_status_value' => -1]], [['student_admission_status_value' => '1.5']]];
    }

    public function testExplicitEnrollmentAndPendingShareTheSameInterpretation(): void
    {
        $this->assertTrue(class_exists(EnrollmentRequest::class));
        $this->assertTrue(EnrollmentRequest::isImmediate(['student_admission_status_value' => 0]));
        $this->assertTrue(EnrollmentRequest::isImmediate(['student_admission_status_value' => '0']));
        $this->assertFalse(EnrollmentRequest::isImmediate(['student_admission_status_value' => 12, 'student_admission_status' => 'Pending Admission']));
    }

    public function testUnknownOrUnrelatedPendingStatusIsRejectedBeforeSavingUser(): void
    {
        $this->assertTrue(method_exists(EnrollmentRequest::class, 'validate'), 'Pending workflow validation is missing.');
        $pdo = new PDO('sqlite::memory:');
        $pdo->exec('CREATE TABLE workflows (id INTEGER, name TEXT)');
        $pdo->exec('CREATE TABLE workflow_steps (id INTEGER, workflow_id INTEGER)');
        $pdo->exec("INSERT INTO workflows VALUES (1,'Student Admission'),(2,'Staff Leave')");
        $pdo->exec('INSERT INTO workflow_steps VALUES (12,1),(13,2)');
        $this->assertFalse(EnrollmentRequest::validate(['student_admission_status_value' => 12], $pdo));
        foreach ([13, 999] as $id) {
            try {
                EnrollmentRequest::validate(['student_admission_status_value' => $id], $pdo);
                $this->fail('Invalid workflow status accepted.');
            } catch (InvalidArgumentException $e) {
                $this->assertNotEmpty($e->getMessage());
            }
        }
    }
}
