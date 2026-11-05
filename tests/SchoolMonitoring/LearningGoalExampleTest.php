<?php
declare(strict_types=1);

use App\SchoolMonitoring\LearningGoalExample;
use Cake\Database\Connection;
use Cake\Database\Driver\Sqlite;
use PHPUnit\Framework\TestCase;

final class LearningGoalExampleTest extends TestCase
{
    private Connection $connection;

    protected function setUp(): void
    {
        $this->assertTrue(class_exists(LearningGoalExample::class), 'Learning-goal example setup is missing.');
        $this->connection = new Connection(['driver' => Sqlite::class, 'database' => ':memory:']);
        $tables = [
            'academic_periods' => 'id INTEGER PRIMARY KEY, start_date TEXT, end_date TEXT',
            'education_systems' => 'id INTEGER PRIMARY KEY, academic_period_id INTEGER',
            'education_levels' => 'id INTEGER PRIMARY KEY, education_system_id INTEGER',
            'education_cycles' => 'id INTEGER PRIMARY KEY, education_level_id INTEGER',
            'education_programmes' => 'id INTEGER PRIMARY KEY, education_cycle_id INTEGER',
            'education_grades' => 'id INTEGER PRIMARY KEY, education_programme_id INTEGER',
            'security_users' => 'id INTEGER PRIMARY KEY',
            'competency_templates' => 'id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT, name TEXT, description TEXT, academic_period_id INTEGER, education_grade_id INTEGER',
            'competency_items' => 'id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, academic_period_id INTEGER, competency_template_id INTEGER',
            'competency_grading_types' => 'id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT, name TEXT',
            'competency_grading_options' => 'id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT, name TEXT, description TEXT, competency_grading_type_id INTEGER',
            'competency_criterias' => 'id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT, name TEXT, academic_period_id INTEGER, competency_item_id INTEGER, competency_template_id INTEGER, competency_grading_type_id INTEGER',
            'competency_periods' => 'id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT, name TEXT, start_date TEXT, end_date TEXT, date_enabled TEXT, date_disabled TEXT, academic_period_id INTEGER, competency_template_id INTEGER',
            'competency_items_periods' => 'id TEXT PRIMARY KEY, competency_item_id INTEGER, competency_period_id INTEGER, academic_period_id INTEGER, competency_template_id INTEGER',
            'institution_competency_results' => 'id INTEGER PRIMARY KEY, student_id INTEGER, competency_grading_option_id INTEGER',
        ];
        foreach ($tables as $table => $columns) {
            $audit = str_starts_with($table, 'competency_') ? ', created_user_id INTEGER NOT NULL, created TEXT NOT NULL' : '';
            $this->connection->execute("CREATE TABLE $table ($columns$audit)");
        }
        foreach ([
            "INSERT INTO academic_periods VALUES (1,'2026-09-01','2027-06-30')",
            'INSERT INTO education_systems VALUES (1,1)',
            'INSERT INTO education_levels VALUES (1,1)',
            'INSERT INTO education_cycles VALUES (1,1)',
            'INSERT INTO education_programmes VALUES (1,1)',
            'INSERT INTO education_grades VALUES (5,1)',
            'INSERT INTO security_users VALUES (1)',
        ] as $sql) {
            $this->connection->execute($sql);
        }
    }

    public function testCreatesAnEditableGoalWithCriteriaPeriodAndThreeGrades(): void
    {
        $id = (new LearningGoalExample($this->connection))->create(1, 5, 1);
        $template = $this->connection->execute('SELECT * FROM competency_templates WHERE id=?', [$id])->fetch('assoc');
        $this->assertSame(5, (int)$template['education_grade_id']);
        $criteria = $this->connection->execute('SELECT * FROM competency_criterias')->fetchAll('assoc');
        $this->assertCount(1, $criteria);
        $this->assertSame('يكتب اسمه', $criteria[0]['name']);
        $options = $this->connection->execute('SELECT code FROM competency_grading_options ORDER BY id')->fetchAll('assoc');
        $this->assertSame(['NOT_YET', 'WITH_HELP', 'INDEPENDENT'], array_column($options, 'code'));
        $link = $this->connection->execute('SELECT * FROM competency_items_periods')->fetch('assoc');
        $this->assertSame($id, (int)$link['competency_template_id']);
        $this->assertSame((int)$criteria[0]['competency_item_id'], (int)$link['competency_item_id']);
        $period = $this->connection->execute('SELECT * FROM competency_periods')->fetch('assoc');
        $this->assertSame((int)$period['id'], (int)$link['competency_period_id']);
        $this->assertSame('2026-09-01', $period['start_date']);
        $this->assertSame(0, (int)$this->connection->execute('SELECT COUNT(*) n FROM institution_competency_results')->fetch('assoc')['n']);
    }

    public function testRepeatedSetupDoesNotDuplicateOrOverwriteEditedGoal(): void
    {
        $setup = new LearningGoalExample($this->connection);
        $first = $setup->create(1, 5, 1);
        $this->connection->execute("UPDATE competency_criterias SET name='هدف راجعته المؤسسة'");
        $this->assertSame($first, $setup->create(1, 5, 1));
        $this->assertSame(1, (int)$this->connection->execute('SELECT COUNT(*) n FROM competency_templates')->fetch('assoc')['n']);
        $this->assertSame('هدف راجعته المؤسسة', $this->connection->execute('SELECT name FROM competency_criterias')->fetch('assoc')['name']);
    }

    /** @dataProvider invalidTargets */
    public function testInvalidTargetDoesNotLeavePartialSetup(int $period, int $grade, int $user): void
    {
        try {
            (new LearningGoalExample($this->connection))->create($period, $grade, $user);
            $this->fail('Invalid target was accepted.');
        } catch (InvalidArgumentException $e) {
            $this->assertSame(0, (int)$this->connection->execute('SELECT COUNT(*) n FROM competency_templates')->fetch('assoc')['n']);
        }
    }

    public static function invalidTargets(): array
    {
        return [[99, 5, 1], [1, 99, 1], [1, 5, 99]];
    }

    public function testGradeFromDifferentAcademicPeriodIsRejected(): void
    {
        $this->connection->execute("INSERT INTO academic_periods VALUES (2,'2027-09-01','2028-06-30')");
        $this->expectException(InvalidArgumentException::class);
        (new LearningGoalExample($this->connection))->create(2, 5, 1);
    }

    public function testHistoricalTeachingPeriodStillHasAnOpenDemoEntryWindow(): void
    {
        $this->connection->execute("UPDATE academic_periods SET start_date='2020-01-01', end_date='2020-12-31'");
        (new LearningGoalExample($this->connection))->create(1, 5, 1);
        $data = $this->connection->execute('SELECT * FROM competency_periods')->fetch('assoc');
        $period = new \Competency\Model\Entity\CompetencyPeriod($data);
        $this->assertSame('2020-12-31', $period->end_date);
        $this->assertSame(1, $period->editable);
    }
}
