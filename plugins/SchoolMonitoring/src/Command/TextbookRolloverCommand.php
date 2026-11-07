<?php
declare(strict_types=1);

namespace SchoolMonitoring\Command;

use Cake\Command\Command;
use Cake\Console\Arguments;
use Cake\Console\ConsoleIo;
use Cake\Console\ConsoleOptionParser;
use SchoolMonitoring\Domain\Schema;
use SchoolMonitoring\Domain\TextbookLoanService;

class TextbookRolloverCommand extends Command
{
    public static function defaultName(): string
    {
        return 'school_monitoring.textbook_rollover';
    }

    protected function buildOptionParser(ConsoleOptionParser $parser): ConsoleOptionParser
    {
        $parser->addArgument('from_period', ['help' => 'Source academic_period_id', 'required' => true]);
        $parser->addArgument('to_period', ['help' => 'Destination academic_period_id', 'required' => true]);
        $parser->addOption('copy', [
            'help' => 'Copy outstanding loans into the destination period. Default is report-only.',
            'boolean' => true,
            'default' => false,
        ]);

        return $parser;
    }

    public function execute(Arguments $args, ConsoleIo $io)
    {
        $from = (int)$args->getArgument('from_period');
        $to = (int)$args->getArgument('to_period');
        $pdo = $this->getTableLocator()->get('Institution.Institutions')->getConnection()->getDriver()->getConnection();
        Schema::install($pdo);
        $service = new TextbookLoanService($pdo);
        $outstanding = $service->outstandingForPeriod($from);
        $io->out(sprintf('%d outstanding loan(s) in period %d.', count($outstanding), $from));
        if (!$args->getOption('copy')) {
            $io->out('Pass --copy to open matching loans in the destination period. Transfers are not blocked.');

            return static::CODE_SUCCESS;
        }
        $copied = $service->rolloverOpenLoans($from, $to, 1);
        $io->success(sprintf('Opened %d loan(s) in period %d. Source loans were left open.', $copied, $to));

        return static::CODE_SUCCESS;
    }
}
