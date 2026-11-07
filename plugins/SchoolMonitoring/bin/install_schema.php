<?php
declare(strict_types=1);

$root = dirname(__DIR__, 3);
$config = require $root . '/config/app_local.php';
$db = $config['Datasources']['default'];
require dirname(__DIR__) . '/src/Domain/Schema.php';

$dsn = sprintf(
    'mysql:host=%s;port=%s;dbname=%s;charset=utf8mb4',
    $db['host'],
    $db['port'] ?? 3306,
    $db['database']
);
$pdo = new PDO($dsn, $db['username'], $db['password'], [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
SchoolMonitoring\Domain\Schema::install($pdo);
$tables = $pdo->query("SHOW TABLES LIKE 'sm_%'")->fetchAll(PDO::FETCH_COLUMN);
echo 'sm_tables=' . count($tables) . PHP_EOL;
echo implode(',', $tables) . PHP_EOL;
