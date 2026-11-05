<?php
declare(strict_types=1);

use App\Model\Behavior\RequireGuardianContactBehavior;
use Cake\Database\Connection;
use Cake\Database\Driver\Sqlite;
use Cake\ORM\Entity;
use Cake\ORM\Table;
use PHPUnit\Framework\TestCase;

final class EnrollmentGuardianTest extends TestCase
{
    private Connection $connection;
    private Table $students;

    protected function setUp(): void
    {
        $this->assertTrue(class_exists(RequireGuardianContactBehavior::class), 'Enrollment save guard is missing.');
        $this->connection = new Connection(['driver' => Sqlite::class, 'database' => ':memory:']);
        foreach ([
            'CREATE TABLE institution_students (id INTEGER PRIMARY KEY, student_id INTEGER, notes TEXT)',
            'CREATE TABLE student_guardians (student_id INTEGER, guardian_id INTEGER)',
            'CREATE TABLE contact_options (id INTEGER PRIMARY KEY, code TEXT)',
            'CREATE TABLE contact_types (id INTEGER PRIMARY KEY, contact_option_id INTEGER)',
            'CREATE TABLE user_contacts (id INTEGER PRIMARY KEY, security_user_id INTEGER, contact_type_id INTEGER, value TEXT, preferred INTEGER)',
            "INSERT INTO contact_options VALUES (1,'MOB')",
            'INSERT INTO contact_types VALUES (1,1)',
            'INSERT INTO student_guardians VALUES (10,20)',
            "INSERT INTO user_contacts VALUES (1,20,1,'123456',1)",
            "INSERT INTO institution_students VALUES (1,99,'legacy')",
        ] as $sql) {
            $this->connection->execute($sql);
        }
        $this->students = new Table(['alias' => 'Students', 'table' => 'institution_students', 'connection' => $this->connection]);
        $this->students->addBehavior('RequireGuardianContact', ['className' => RequireGuardianContactBehavior::class]);
    }

    public function testSaveCannotBypassRequirementBySkippingValidationAndRules(): void
    {
        $student = new Entity(['student_id' => 99]);
        $this->assertFalse($this->students->save($student, ['checkRules' => false]));
        $this->assertNotEmpty($student->getError('student_id'));
        $this->assertSame(1, $this->students->find()->count());
    }

    public function testStudentWithPrimaryGuardianPhoneCanEnroll(): void
    {
        $student = new Entity(['student_id' => 10]);
        $this->assertNotFalse($this->students->save($student));
        $this->assertSame(2, $this->students->find()->count());
    }

    public function testLegacyEnrollmentCanBeEditedWithoutGuardian(): void
    {
        $student = $this->students->get(1);
        $student->notes = 'updated';
        $this->assertNotFalse($this->students->save($student));
        $this->assertSame('updated', $this->students->get(1)->notes);
    }

    public function testRepointingEnrollmentToAnotherStudentRequiresGuardian(): void
    {
        $student = $this->students->get(1);
        $student->student_id = 88;
        $this->assertFalse($this->students->save($student));
        $this->assertSame(99, $this->students->get(1)->student_id);
    }

    public function testApplicationRegistrationAlsoProtectsGenericOrmAliases(): void
    {
        $registration = dirname(__DIR__, 2) . '/config/school_monitoring.php';
        $this->assertFileExists($registration);
        $this->students->removeBehavior('RequireGuardianContact');
        require $registration;
        try {
            $generic = new Table(['table' => 'institution_students', 'connection' => $this->connection]);
            $student = new Entity(['student_id' => 99]);
            $this->assertFalse($generic->save($student));
            $this->assertNotEmpty($student->getError('student_id'));
        } finally {
            \Cake\Event\EventManager::instance()->off('Model.beforeSave', [RequireGuardianContactBehavior::class, 'enforceEnrollment']);
        }
    }
}
