<?php
declare(strict_types=1);

use App\Model\Behavior\RequireGuardianContactBehavior;
use Cake\Event\EventManager;
use SchoolMonitoring\Listener\TextbookLoanListener;

spl_autoload_register(static function (string $class): void {
    $prefix = 'SchoolMonitoring\\';
    if (strncmp($class, $prefix, strlen($prefix)) !== 0) {
        return;
    }
    $relative = str_replace('\\', DIRECTORY_SEPARATOR, substr($class, strlen($prefix)));
    $file = dirname(__DIR__) . DIRECTORY_SEPARATOR . 'plugins' . DIRECTORY_SEPARATOR
        . 'SchoolMonitoring' . DIRECTORY_SEPARATOR . 'src' . DIRECTORY_SEPARATOR . $relative . '.php';
    if (is_file($file)) {
        require $file;
    }
});

EventManager::instance()->on('Model.beforeSave', ['priority' => 1], [RequireGuardianContactBehavior::class, 'enforceEnrollment']);
EventManager::instance()->on('Model.afterSave', ['priority' => 20], [TextbookLoanListener::class, 'afterSave']);
