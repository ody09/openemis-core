<?php
declare(strict_types=1);

namespace App\Command;

use App\SchoolMonitoring\LearningGoalExample;
use Cake\Command\Command;
use Cake\Console\Arguments;
use Cake\Console\ConsoleIo;
use Cake\Console\ConsoleOptionParser;
use Cake\Datasource\ConnectionManager;
use Throwable;

final class SchoolLearningGoalExampleCommand extends Command
{
    public static function defaultName(): string
    {
        return 'school:learning-goal-example';
    }

    public function buildOptionParser(ConsoleOptionParser $parser): ConsoleOptionParser
    {
        return $parser->setDescription('Add an editable DEMO learning goal to the existing Competencies module.')
            ->addOption('period', ['help' => 'Academic period ID', 'required' => true])
            ->addOption('grade', ['help' => 'Education grade ID in the selected period', 'required' => true])
            ->addOption('user', ['help' => 'Existing author user ID', 'required' => true]);
    }

    public function execute(Arguments $args, ConsoleIo $io): int
    {
        foreach (['period', 'grade', 'user'] as $option) {
            if (!ctype_digit((string)$args->getOption($option)) || (int)$args->getOption($option) < 1) {
                $io->err('Each ID must be a positive integer.');
                return static::CODE_ERROR;
            }
        }
        try {
            $setup = new LearningGoalExample(ConnectionManager::get('default'));
            $id = $setup->create((int)$args->getOption('period'), (int)$args->getOption('grade'), (int)$args->getOption('user'));
            $io->out('DEMO competency template ready: ' . $id . '. Review it under Administration > Performance > Competencies.');
            return static::CODE_SUCCESS;
        } catch (Throwable $e) {
            $io->err($e->getMessage());
            return static::CODE_ERROR;
        }
    }
}
