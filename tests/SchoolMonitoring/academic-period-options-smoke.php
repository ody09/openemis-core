<?php
declare(strict_types=1);

// Read-only integration check against the local DEMO-SCHOOL-01 setup.
// Each endpoint runs separately because the legacy dates action calls die().
if ($argc === 1) {
    foreach (['en', 'ar'] as $locale) {
        foreach (['dates', 'grades'] as $action) {
            $process = proc_open([PHP_BINARY, __FILE__, $locale, $action],
                [1 => ['pipe', 'w'], 2 => ['pipe', 'w']], $pipes);
            $output = stream_get_contents($pipes[1]);
            $error = stream_get_contents($pipes[2]);
            fclose($pipes[1]);
            fclose($pipes[2]);
            $status = proc_close($process);
            $rows = json_decode($output, true);
            $valid = $status === 0 && is_array($rows);
            if ($action === 'dates') {
                $valid = $valid && ($rows[0]['start_date'] ?? '') === '2025-01-01'
                    && ($rows[0]['end_date'] ?? '') === '2025-12-31';
            } else {
                $valid = $valid && in_array(221, array_column($rows, 'education_grade_id'), true);
            }
            if (!$valid) {
                fwrite(STDERR, "$locale/$action failed: $output $error\n");
                exit(1);
            }
            echo "$locale/$action PASS\n";
        }
    }
    exit(0);
}

chdir(dirname(__DIR__, 2));
require 'vendor/autoload.php';
require 'config/bootstrap.php';

try {
    \Cake\I18n\I18n::setLocale($argv[1]);
    $connection = \Cake\Datasource\ConnectionManager::get('default');
    $school = $connection->execute('SELECT code FROM institutions WHERE id=1')->fetch('assoc');
    if (($school['code'] ?? '') !== 'DEMO-SCHOOL-01') {
        throw new RuntimeException('This smoke check requires the local demo school.');
    }
    $params = $argv[2] === 'dates'
        ? ['academic_period_id' => 34]
        : ['academic_periods' => 34, 'institution_id' => 1];
    $controller = (new ReflectionClass(\Institution\Controller\InstitutionsController::class))
        ->newInstanceWithoutConstructor();
    $controller->setRequest(new \Cake\Http\ServerRequest(['input' => json_encode(['params' => $params])]));
    $controller->setResponse(new \Cake\Http\Response());
    if ($argv[2] === 'dates') {
        $controller->getStartDateFromAcademicPeriod();
    } else {
        $controller->getEducationGrade();
        echo (string)$controller->getResponse()->getBody();
    }
} catch (Throwable $error) {
    fwrite(STDERR, $error->getMessage() . "\n");
    exit(1);
}
