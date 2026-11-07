<?php
declare(strict_types=1);

namespace SchoolMonitoring;

use Cake\Console\CommandCollection;
use Cake\Core\BasePlugin;
use Cake\Core\PluginApplicationInterface;
use Cake\Routing\RouteBuilder;
use SchoolMonitoring\Command\BiometricSyncCommand;
use SchoolMonitoring\Command\InstallSchemaCommand;
use SchoolMonitoring\Command\PhotoCleanupCommand;
use SchoolMonitoring\Command\TextbookRolloverCommand;

class Plugin extends BasePlugin
{
    protected $routesEnabled = true;
    protected $consoleEnabled = true;

    public function bootstrap(PluginApplicationInterface $app): void
    {
    }

    public function routes(RouteBuilder $routes): void
    {
        $pluginRoutes = dirname(__DIR__) . DIRECTORY_SEPARATOR . 'config' . DIRECTORY_SEPARATOR . 'routes.php';
        if (is_file($pluginRoutes)) {
            (require $pluginRoutes)($routes);
        }
    }

    public function console(CommandCollection $commands): CommandCollection
    {
        $commands->add('school_monitoring.install_schema', InstallSchemaCommand::class);
        $commands->add('school_monitoring.biometric_sync', BiometricSyncCommand::class);
        $commands->add('school_monitoring.photo_cleanup', PhotoCleanupCommand::class);
        $commands->add('school_monitoring.textbook_rollover', TextbookRolloverCommand::class);

        return $commands;
    }
}
