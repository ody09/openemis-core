<?php
// Serve the bundled API and CakePHP application from the same local origin.
$root = dirname(__DIR__) . '/openemis-core';
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
if (preg_match('#^/api(?:/|$)#', $path)) {
    $_SERVER['SCRIPT_NAME'] = '/api/index.php';
    $_SERVER['PHP_SELF'] = '/api/index.php';
    $_SERVER['SCRIPT_FILENAME'] = $root . '/api/public/index.php';
    require $root . '/api/public/index.php';
    return;
}
return require $root . '/webroot/index.php';
