<?php
declare(strict_types=1);

use App\SchoolMonitoring\GuardianContactPolicy;
use PHPUnit\Framework\TestCase;

final class GuardianContactPolicyTest extends TestCase
{
    private PDO $pdo;

    protected function setUp(): void
    {
        $this->assertTrue(class_exists(GuardianContactPolicy::class), 'Guardian enrollment policy is missing.');
        $this->pdo = new PDO('sqlite::memory:');
        $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $this->pdo->exec('CREATE TABLE student_guardians (student_id INTEGER, guardian_id INTEGER)');
        $this->pdo->exec('CREATE TABLE contact_options (id INTEGER PRIMARY KEY, code TEXT)');
        $this->pdo->exec('CREATE TABLE contact_types (id INTEGER PRIMARY KEY, contact_option_id INTEGER)');
        $this->pdo->exec('CREATE TABLE user_contacts (id INTEGER PRIMARY KEY, security_user_id INTEGER, contact_type_id INTEGER, value TEXT, preferred INTEGER)');
        $this->pdo->exec("INSERT INTO contact_options VALUES (1,'MOB'),(2,'PHO'),(3,'EMA'),(4,'FAX')");
        $this->pdo->exec('INSERT INTO contact_types VALUES (1,1),(2,2),(3,3),(4,4)');
        $this->pdo->exec('INSERT INTO student_guardians VALUES (10,20),(11,20),(12,21)');
    }

    /** @dataProvider invalidContacts */
    public function testInvalidOrNonPrimaryContactsCannotCompleteEnrollment(int $type, ?string $value, int $preferred): void
    {
        $this->contact(20, $type, $value, $preferred);
        $policy = new GuardianContactPolicy($this->pdo);
        $this->assertFalse($policy->hasPrimaryPhone(10));
    }

    public static function invalidContacts(): array
    {
        return [
            'email' => [3, 'parent@example.test', 1],
            'fax' => [4, '123456', 1],
            'blank' => [1, '   ', 1],
            'null' => [1, null, 1],
            'secondary only' => [1, '123456', 0],
            'text' => [1, 'ask the parent', 1],
            'punctuation' => [1, '+ -- ()', 1],
        ];
    }

    public function testOneGuardianCanSatisfyTwoSiblingsButNotAnotherStudent(): void
    {
        $this->contact(20, 1, '+967 777-123-456', 1);
        $policy = new GuardianContactPolicy($this->pdo);
        $this->assertTrue($policy->hasPrimaryPhone(10));
        $this->assertTrue($policy->hasPrimaryPhone(11));
        $this->assertFalse($policy->hasPrimaryPhone(12));
        $this->assertFalse($policy->hasPrimaryPhone(999));
    }

    public function testArabicDigitsAreAcceptedWithoutAssumingCountryLength(): void
    {
        $this->contact(20, 2, '٠١٢٣٤٥٦٧٨٩', 1);
        $this->assertTrue((new GuardianContactPolicy($this->pdo))->hasPrimaryPhone(10));
    }

    public function testOverviewSelectsPrimaryAndOptionalSecondaryFromPhoneContacts(): void
    {
        $this->contact(20, 3, 'parent@example.test', 1);
        $this->contact(20, 1, '123456', 0);
        $this->contact(20, 1, '987654', 1);
        $this->assertSame(['primary' => '987654', 'secondary' => '123456'], (new GuardianContactPolicy($this->pdo))->phones(20));
        $this->assertSame(['primary' => '', 'secondary' => ''], (new GuardianContactPolicy($this->pdo))->phones(21));
    }

    private function contact(int $guardian, int $type, ?string $value, int $preferred): void
    {
        $this->pdo->prepare('INSERT INTO user_contacts (security_user_id, contact_type_id, value, preferred) VALUES (?,?,?,?)')
            ->execute([$guardian, $type, $value, $preferred]);
    }
}
