<?php
declare(strict_types=1);

namespace SchoolMonitoring\Command;

use Cake\Command\Command;
use Cake\Console\Arguments;
use Cake\Console\ConsoleIo;
use Cake\Console\ConsoleOptionParser;
use SchoolMonitoring\Domain\Schema;

class PhotoCleanupCommand extends Command
{
    public static function defaultName(): string
    {
        return 'school_monitoring.photo_cleanup';
    }

    protected function buildOptionParser(ConsoleOptionParser $parser): ConsoleOptionParser
    {
        $parser->addOption('days', [
            'help' => 'Delete photos older than this many days.',
            'default' => '365',
        ]);

        return $parser;
    }

    public function execute(Arguments $args, ConsoleIo $io)
    {
        $days = max(1, (int)$args->getOption('days'));
        $pdo = $this->getTableLocator()->get('Institution.Institutions')->getConnection()->getDriver()->getConnection();
        Schema::install($pdo);
        $cutoff = gmdate('Y-m-d H:i:s', time() - ($days * 86400));
        $stmt = $pdo->prepare('SELECT id, file_path FROM sm_lesson_verification_photos WHERE server_received_at < ?');
        $stmt->execute([$cutoff]);
        $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC) ?: [];
        $root = ROOT . DS . 'storage' . DS . 'school-monitoring';
        $deleted = 0;
        foreach ($rows as $row) {
            $absolute = $root . DS . str_replace(['/', '\\'], DS, (string)$row['file_path']);
            if (is_file($absolute)) {
                @unlink($absolute);
            }
            $pdo->prepare('DELETE FROM sm_lesson_verification_photos WHERE id = ?')->execute([$row['id']]);
            $deleted++;
        }
        $io->success(sprintf('Removed %d photo(s) older than %d day(s).', $deleted, $days));

        return static::CODE_SUCCESS;
    }
}
