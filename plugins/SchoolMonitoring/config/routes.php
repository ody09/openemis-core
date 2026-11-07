<?php
declare(strict_types=1);

use Cake\Routing\RouteBuilder;

return function (RouteBuilder $routes): void {
    $routes->scope('/SchoolMonitoring', ['plugin' => 'SchoolMonitoring'], function (RouteBuilder $routes) {
        $routes->connect('/LessonPhotos', ['controller' => 'LessonPhotos', 'action' => 'index']);
        $routes->connect('/LessonPhotos/:action/*', ['controller' => 'LessonPhotos']);
        $routes->connect('/TextbookLoans', ['controller' => 'TextbookLoans', 'action' => 'index']);
        $routes->connect('/TextbookLoans/:action/*', ['controller' => 'TextbookLoans']);
        $routes->connect('/Clearance', ['controller' => 'Clearance', 'action' => 'index']);
        $routes->connect('/Clearance/:action/*', ['controller' => 'Clearance']);
        $routes->connect('/Supplies/:action/*', ['controller' => 'Supplies']);
        $routes->connect('/Biometric/:action/*', ['controller' => 'Biometric']);
    });
    $routes->scope('/school-monitoring', ['plugin' => 'SchoolMonitoring'], function (RouteBuilder $routes) {
        $routes->connect('/lesson-photos/token', ['controller' => 'LessonPhotos', 'action' => 'token']);
        $routes->connect('/lesson-photos/upload', ['controller' => 'LessonPhotos', 'action' => 'upload']);
        $routes->connect('/lesson-photos/today', ['controller' => 'LessonPhotos', 'action' => 'today']);
        $routes->connect('/lesson-photos/image', ['controller' => 'LessonPhotos', 'action' => 'image']);
        $routes->connect('/lesson-photos', ['controller' => 'LessonPhotos', 'action' => 'index']);
        $routes->connect('/biometric/punches', ['controller' => 'Biometric', 'action' => 'punches']);
        $routes->connect('/textbooks/loans', ['controller' => 'TextbookLoans', 'action' => 'index']);
        $routes->connect('/textbooks/return', ['controller' => 'TextbookLoans', 'action' => 'returnCopy']);
        $routes->connect('/supplies/issue', ['controller' => 'Supplies', 'action' => 'issue']);
        $routes->connect('/supplies/return', ['controller' => 'Supplies', 'action' => 'returnItem']);
        $routes->connect('/clearance', ['controller' => 'Clearance', 'action' => 'index']);
        $routes->connect('/:controller/:action/*', ['plugin' => 'SchoolMonitoring']);
    });
};
