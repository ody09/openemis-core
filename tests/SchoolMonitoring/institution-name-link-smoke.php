<?php
declare(strict_types=1);

require dirname(__DIR__, 2) . '/vendor/autoload.php';

// Run the real index configuration without database access or an authenticated session.
class SchoolIndexLinkProbe extends \Institution\Model\Table\InstitutionsTable
{
    public $Session;
    public $controller;
    public array $capturedFields = [];
    public function __construct() {}
    public function field($name, $attr = []) { $this->capturedFields[$name] = $attr; }
    public function setFieldOrder($fields, $order = 0) {}
    public function setFieldVisible($actions, $fields) {}
}

\Cake\Core\Configure::write('App.fullBaseUrl', 'http://127.0.0.1:8001');
$table = new SchoolIndexLinkProbe();
$table->setAlias('Institutions');
$table->Session = new class { public function delete($key) {} };
$table->controller = new class {
    public function getPlugin() { return 'Institution'; }
    public function getName() { return 'Institutions'; }
    public function set($key, $value) {}
};
$table->indexBeforeAction(new \Cake\Event\Event('index', $table), new ArrayObject());
$html = new \Cake\View\Helper\HtmlHelper(new \Cake\View\View());
$nameCell = ['<a href="/Institution/Institutions/dashboard/school-context">Demo school</a>', [
    'class' => $table->capturedFields['name']['tableColumnClass'] ?? '',
]];
$row = $html->tableCells([[
    '<a href="/Institutions/Institutions/download/logo">Logo</a>', $nameCell,
]]);
if (!str_contains($row, '<td class="rowlink-skip"><a href="/Institution/Institutions/dashboard/')) {
    fwrite(STDERR, "FAIL: clicking the school name can be intercepted by the row's earlier logo download link.\n");
    exit(1);
}
echo "PASS: school-name cell preserves its own navigation instead of the row's first link.\n";
