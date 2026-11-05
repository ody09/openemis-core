<?php
declare(strict_types=1);

// Read-only check: each first request must search, rather than return a placeholder.
chdir(dirname(__DIR__, 2));
require 'vendor/autoload.php';
require 'config/bootstrap.php';
try {
    foreach (['en', 'ar'] as $locale) {
        \Cake\I18n\I18n::setLocale($locale);
        $controller = (new ReflectionClass(\Directory\Controller\DirectoriesController::class))->newInstanceWithoutConstructor();
        $controller->setRequest(new \Cake\Http\ServerRequest(['input' => json_encode(['params' => [
            'first_name' => '__SCHOOL_MONITORING_NO_MATCH__', 'last_name' => '__SMOKE__',
            'date_of_birth' => $locale === 'ar' ? 'أبريل 06, 2012' : '2012-04-06',
            'institution_id' => 1, 'user_type_id' => 1, 'limit' => 10, 'page' => 1,
        ]], JSON_UNESCAPED_UNICODE)]));
        $controller->setResponse(new \Cake\Http\Response());
        $response = $controller->directoryInternalSearch();
        $data = json_decode((string)$response->getBody(), true);
        if ($response->getStatusCode() !== 200 || !isset($data['data'], $data['total']) || $data['data'] !== [] || $data['total'] !== 0) {
            throw new RuntimeException($locale . ' first search returned ' . (string)$response->getBody());
        }
        echo $locale . " first search PASS\n";
    }
    $controller->setRequest(new \Cake\Http\ServerRequest(['input' => json_encode(['params' => [
        'first_name' => '__SCHOOL_MONITORING_NO_MATCH__', 'date_of_birth' => 'not a date',
    ]])]));
    $response = $controller->directoryInternalSearch();
    if ($response->getStatusCode() !== 400 || !str_contains((string)$response->getBody(), 'message')) {
        throw new RuntimeException('Invalid birth date did not return a validation response.');
    }
    echo "invalid date response PASS\n";
} catch (Throwable $error) {
    fwrite(STDERR, $error->getMessage() . "\n");
    exit(1);
}
