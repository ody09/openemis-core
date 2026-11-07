<?php
declare(strict_types=1);

namespace SchoolMonitoring\Command;

use Cake\Command\Command;
use Cake\Console\Arguments;
use Cake\Console\ConsoleIo;
use SchoolMonitoring\Domain\Schema;

class InstallSchemaCommand extends Command
{
    public static function defaultName(): string
    {
        return 'school_monitoring.install_schema';
    }

    public function execute(Arguments $args, ConsoleIo $io)
    {
        $pdo = $this->getTableLocator()->get('Institution.Institutions')->getConnection()->getDriver()->getConnection();
        Schema::install($pdo);
        $io->success('SchoolMonitoring tables are ready.');

        return static::CODE_SUCCESS;
    }
}
