<?php
declare(strict_types=1);

namespace SchoolMonitoring\Test\TestCase\Domain;

use PDO;
use SchoolMonitoring\Domain\Schema;

final class SqliteFactory
{
    public static function pdo(): PDO
    {
        $pdo = new PDO('sqlite::memory:');
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        Schema::install($pdo);

        return $pdo;
    }
}
