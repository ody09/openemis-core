<?php
declare(strict_types=1);

chdir(dirname(__DIR__, 2));
require 'vendor/autoload.php';
require 'config/bootstrap.php';
set_error_handler(static function ($level) { return in_array($level, [E_USER_DEPRECATED, E_DEPRECATED], true); });
$routes = \Cake\Routing\Router::createRouteBuilder('/');
$loadRoutes = require 'config/routes.php';
$loadRoutes($routes);
require 'plugins/Institution/config/routes.php';
\Cake\Routing\Router::setRequest(new \Cake\Http\ServerRequest());

class StudentReturnLinkProbe
{
    public $Html;
    public $ControllerAction;
    public function __construct()
    {
        $view = new \Cake\View\View();
        $this->Html = new \Cake\View\Helper\HtmlHelper($view);
        $this->ControllerAction = new \ControllerAction\View\Helper\ControllerActionHelper($view);
    }
    public function render($file): string
    {
        $institutionId = 7;
        ob_start();
        include $file;
        return ob_get_clean();
    }
}
$probe = new StudentReturnLinkProbe();
foreach ([
    'plugins/Institution/templates/Element/student_add_actions.php',
    'plugins/Directory/templates/Element/guardian_add_actions.php',
] as $file) {
    $html = $probe->render($file);
    if (!preg_match('/<a\b[^>]*href="([^"]*)"/', $html, $matches)) throw new RuntimeException('Return link missing.');
    $url = html_entity_decode($matches[1]);
    $params = \Cake\Routing\Router::parseRequest(new \Cake\Http\ServerRequest(['url' => $url]));
    $encoded = $params['pass'][1] ?? '';
    $context = json_decode(base64_decode(strtr(explode('.', $encoded)[0], '-_', '+/')), true);
    if (($params['action'] ?? '') !== 'Students' || ($params['pass'][0] ?? '') !== 'index'
        || ($context['institution_id'] ?? null) !== 7) {
        fwrite(STDERR, "FAIL: $file return link loses the school context expected by the student list.\n");
        exit(1);
    }
    echo "PASS: $file returns to the student list with its school context.\n";
}
