<?php
declare(strict_types=1);

// Load the API's actual Carbon before CakePHP's legacy Carbon compatibility aliases.
$root = dirname(__DIR__, 2);
$apiLoader = require $root . '/api/vendor/autoload.php';
class_exists(\Carbon\Carbon::class);
class_exists(\Illuminate\Container\Container::class);
require $root . '/vendor/autoload.php';
$apiLoader->unregister();
$apiLoader->register(true);
require $root . '/vendor/phpunit/phpunit/phpunit';
