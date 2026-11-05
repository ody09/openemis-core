<?php
declare(strict_types=1);

use Directory\Model\Table\DirectoriesTable;
use PHPUnit\Framework\TestCase;

final class DirectorySearchDateTest extends TestCase
{
    /** @dataProvider dates */
    public function testSearchAcceptsLocalizedBirthDates(string $input): void
    {
        $table = new class {
            public function aliasField($field) { return 'Users.' . $field; }
        };
        $method = new ReflectionMethod(DirectoriesTable::class, 'buildUserSearchConditions');
        $conditions = $method->invoke(null, $table, null, null, 'طالب', 'اختبار', $input);
        $this->assertSame('2012-04-06', $conditions['Users.date_of_birth']);
    }

    public static function dates(): array
    {
        return [['أبريل 06, 2012'], ['April 06, 2012'], ['2012-04-06'], ['06-04-2012']];
    }

    public function testInvalidDateReportsAValidationProblem(): void
    {
        $table = new class { public function aliasField($field) { return 'Users.' . $field; } };
        $this->expectException(InvalidArgumentException::class);
        (new ReflectionMethod(DirectoriesTable::class, 'buildUserSearchConditions'))
            ->invoke(null, $table, null, null, 'طالب', 'اختبار', 'not a date');
    }
}
