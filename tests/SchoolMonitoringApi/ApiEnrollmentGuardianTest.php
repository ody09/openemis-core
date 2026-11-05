<?php
declare(strict_types=1);

use Illuminate\Container\Container;
use Illuminate\Database\Capsule\Manager;
use Illuminate\Events\Dispatcher;
use Illuminate\Support\Facades\Facade;
use Illuminate\Translation\ArrayLoader;
use Illuminate\Translation\Translator;
use Illuminate\Validation\Factory;
use Illuminate\Validation\ValidationException;
use PHPUnit\Framework\TestCase;

require_once dirname(__DIR__, 2) . '/api/vendor/autoload.php';

// Existing webhook delivery is external to the enrollment requirement under test.
final class EnrollmentApiTestModel extends \App\Models\Api5\InstitutionStudents
{
    protected $webhookEvents = [];
}

final class ApiEnrollmentGuardianTest extends TestCase
{
    private Manager $database;

    protected function setUp(): void
    {
        $container = new Container();
        Container::setInstance($container);
        $this->database = new Manager($container);
        $this->database->addConnection(['driver' => 'sqlite', 'database' => ':memory:']);
        $this->database->setEventDispatcher(new Dispatcher($container));
        $this->database->bootEloquent();
        EnrollmentApiTestModel::clearBootedModels();
        $container->instance('db', $this->database->getDatabaseManager());
        $container->instance('auth', new class { public function id() { return 1; } });
        $container->alias('auth', \Illuminate\Contracts\Auth\Factory::class);
        $container->instance(\Illuminate\Contracts\Routing\ResponseFactory::class, new class {
            public function json($data, $status = 200) { return new \Illuminate\Http\JsonResponse($data, $status); }
        });
        if (!class_exists('DB')) {
            class_alias(\Illuminate\Support\Facades\DB::class, 'DB');
        }
        $container->instance('db.schema', $this->database->getConnection()->getSchemaBuilder());
        $container->instance('validator', new Factory(new Translator(new ArrayLoader(), 'en'), $container));
        Facade::clearResolvedInstances();
        Facade::setFacadeApplication($container);
        foreach ([
            'CREATE TABLE institution_students (id TEXT PRIMARY KEY, student_id INTEGER, created_user_id INTEGER, created TEXT, modified_user_id INTEGER, modified TEXT)',
            'CREATE TABLE student_guardians (student_id INTEGER, guardian_id INTEGER)',
            'CREATE TABLE contact_options (id INTEGER PRIMARY KEY, code TEXT)',
            'CREATE TABLE contact_types (id INTEGER PRIMARY KEY, contact_option_id INTEGER)',
            'CREATE TABLE user_contacts (id INTEGER PRIMARY KEY, security_user_id INTEGER, contact_type_id INTEGER, value TEXT, preferred INTEGER)',
            "INSERT INTO contact_options VALUES (1,'MOB')",
            'INSERT INTO contact_types VALUES (1,1)',
            'INSERT INTO student_guardians VALUES (10,20)',
            "INSERT INTO user_contacts VALUES (1,20,1,'123456',1)",
            "INSERT INTO institution_students (id,student_id) VALUES ('legacy',99)",
        ] as $sql) {
            $this->database->getConnection()->statement($sql);
        }
    }

    public function testApiCreationRejectsStudentWithoutPrimaryGuardianPhone(): void
    {
        try {
            (new EnrollmentApiTestModel(['id' => 'new', 'student_id' => 88]))->save();
            $this->fail('Enrollment without guardian was accepted.');
        } catch (ValidationException $e) {
            $this->assertArrayHasKey('student_id', $e->errors());
            $this->assertSame(1, EnrollmentApiTestModel::count());
        }
    }

    public function testApiCanSaveStudentWithGuardianAndUpdateLegacyEnrollment(): void
    {
        $this->assertTrue((new EnrollmentApiTestModel(['id' => 'new', 'student_id' => 10]))->save());
        $legacy = EnrollmentApiTestModel::findOrFail('legacy');
        $this->assertTrue($legacy->save());
        $this->assertSame(2, EnrollmentApiTestModel::count());
    }

    public function testApiCannotRepointLegacyEnrollmentWithoutGuardian(): void
    {
        $legacy = EnrollmentApiTestModel::findOrFail('legacy');
        $legacy->student_id = 88;
        $this->expectException(ValidationException::class);
        $legacy->save();
    }

    /** @dataProvider crudOperations */
    public function testCrudReturnsFieldValidationInsteadOfServerError(string $operation): void
    {
        $controller = (new ReflectionClass(\App\Http\Controllers\BaseApi\CrudApiController::class))->newInstanceWithoutConstructor();
        $method = new ReflectionMethod($controller, $operation);
        if ($operation === 'handlePutRequest') {
            $arguments = [\Illuminate\Http\Request::create('/', 'PUT', ['student_id' => 88]), EnrollmentApiTestModel::class, ['id', 'legacy']];
        } elseif ($operation === 'handleBatchCreate') {
            $arguments = [EnrollmentApiTestModel::class, [['id' => 'good', 'student_id' => 10], ['id' => 'bad', 'student_id' => 88]]];
        } else {
            $arguments = [EnrollmentApiTestModel::class, ['id' => 'bad', 'student_id' => 88]];
        }
        $response = $method->invokeArgs($controller, $arguments);
        $this->assertSame(422, $response->getStatusCode());
        $this->assertArrayHasKey('student_id', $response->getData(true)['errors']);
        $this->assertSame(1, EnrollmentApiTestModel::count());
    }

    public static function crudOperations(): array
    {
        return [['handleSingleCreate'], ['handleBatchCreate'], ['handlePutRequest']];
    }
}
