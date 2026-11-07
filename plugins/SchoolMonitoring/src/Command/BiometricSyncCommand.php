<?php
declare(strict_types=1);

namespace SchoolMonitoring\Command;

use Cake\Command\Command;
use Cake\Console\Arguments;
use Cake\Console\ConsoleIo;
use SchoolMonitoring\Domain\BiometricSync;
use SchoolMonitoring\Domain\Schema;

class BiometricSyncCommand extends Command
{
    public static function defaultName(): string
    {
        return 'school_monitoring.biometric_sync';
    }

    public function execute(Arguments $args, ConsoleIo $io)
    {
        $pdo = $this->getTableLocator()->get('Institution.Institutions')->getConnection()->getDriver()->getConnection();
        Schema::install($pdo);
        $applied = (new BiometricSync($pdo))->applyQueued();
        $io->success(sprintf('Applied %d staff-day attendance row(s) from biometric punches.', $applied));

        return static::CODE_SUCCESS;
    }
}
