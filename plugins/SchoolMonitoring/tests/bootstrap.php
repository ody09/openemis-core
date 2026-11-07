<?php
declare(strict_types=1);

$root = dirname(__DIR__, 3);
require $root . '/vendor/autoload.php';

spl_autoload_register(static function (string $class): void {
    $map = [
        'SchoolMonitoring\\Test\\' => __DIR__ . DIRECTORY_SEPARATOR,
        'SchoolMonitoring\\' => dirname(__DIR__) . DIRECTORY_SEPARATOR . 'src' . DIRECTORY_SEPARATOR,
    ];
    foreach ($map as $prefix => $base) {
        if (strncmp($class, $prefix, strlen($prefix)) !== 0) {
            continue;
        }
        $file = $base . str_replace('\\', DIRECTORY_SEPARATOR, substr($class, strlen($prefix))) . '.php';
        if (is_file($file)) {
            require $file;
        }
    }
});
