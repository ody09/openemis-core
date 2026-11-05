<?php
declare(strict_types=1);

// Local reference-data setup: governorates only, as requested by the project owner.
// Arabic names: https://www.humanitarianatlas.org/yemen/ar/ (OCHA Yemen).
chdir(dirname(__DIR__));
require 'vendor/autoload.php';
require 'config/bootstrap.php';

use Cake\Datasource\ConnectionManager;
use Cake\ORM\Table;

$governorates = [
    'ABYAN' => 'أبين', 'CAPITAL' => 'أمانة العاصمة', 'IBB' => 'إب',
    'BAYDA' => 'البيضاء', 'JAWF' => 'الجوف', 'HUDAYDAH' => 'الحديدة',
    'DHALE' => 'الضالع', 'MAHWIT' => 'المحويت', 'MAHRAH' => 'المهرة',
    'TAIZZ' => 'تعز', 'HAJJAH' => 'حجة', 'HADRAMAWT' => 'حضرموت',
    'DHAMAR' => 'ذمار', 'RAYMAH' => 'ريمة', 'SOCOTRA' => 'سقطرى',
    'SHABWAH' => 'شبوة', 'SAADAH' => 'صعدة', 'SANAA' => 'صنعاء',
    'ADEN' => 'عدن', 'AMRAN' => 'عمران', 'LAHJ' => 'لحج', 'MARIB' => 'مأرب',
];
$connection = ConnectionManager::get('default');
$audit = ['created_user_id' => 1, 'created' => date('Y-m-d H:i:s')];
$tables = [];
foreach (['nationalities', 'areas', 'area_levels', 'area_administratives', 'area_administrative_levels'] as $name) {
    // Plain ORM tables keep the built-in Tree behavior without UI/webhook side effects.
    $tables[$name] = new Table(['table' => $name, 'alias' => 'YemenSetup' . $name, 'connection' => $connection]);
}
$tables['areas']->addBehavior('Tree');
$tables['area_administratives']->addBehavior('Tree');
$upsert = function (string $table, array $key, array $values) use ($tables, $audit): int {
    $model = $tables[$table];
    $entity = $model->find()->where($key)->first();
    if (!$entity) {
        $entity = $model->newEntity($key + $values + $audit);
    } else {
        $entity->set($values);
        if (!$entity->isDirty()) {
            return (int)$entity->id;
        }
        $entity->set(['modified_user_id' => 1, 'modified' => $audit['created']]);
    }
    return (int)$model->saveOrFail($entity)->id;
};

try {
    $admin = $connection->execute('SELECT super_admin FROM security_users WHERE id=1')->fetch('assoc');
    if ((int)($admin['super_admin'] ?? 0) !== 1 || count($governorates) !== 22) {
        throw new RuntimeException('Reference setup precondition failed.');
    }
    $backup = [];
    foreach (array_keys($tables) as $name) {
        $backup[$name] = $connection->execute('SELECT * FROM ' . $name)->fetchAll('assoc');
    }
    $backup['config_items'] = $connection->execute("SELECT * FROM config_items WHERE code IN ('institution_area_level_id','institution_validate_area_level_id','institution_validate_area_administrative_level_id')")->fetchAll('assoc');
    $backupPath = 'tmp/yemen-reference-before-20261101.json';
    if (!file_exists($backupPath)) {
        if (file_put_contents($backupPath, json_encode($backup, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT)) === false) {
            throw new RuntimeException('Could not save the reference-data backup.');
        }
    }
    $connection->begin();
    $nationality = $upsert('nationalities', ['international_code' => 'YEM'], [
        'name' => 'يمني', 'order' => 0, 'visible' => 1, 'editable' => 1,
        'identity_type_id' => null, 'default' => 0, 'national_code' => 'YE',
        'external_validation' => 0, 'is_refugee' => 0,
    ]);
    $countryLevel = $tables['area_levels']->find()->where(['level' => 1])->firstOrFail();
    $governorateLevel = $tables['area_levels']->find()->where(['level' => 2])->firstOrFail();
    $upsert('area_levels', ['id' => $governorateLevel->id], ['name' => 'محافظة']);
    $educationCountry = $upsert('areas', ['code' => 'YEM'], [
        'name' => 'اليمن', 'parent_id' => null, 'area_level_id' => $countryLevel->id,
        'visible' => 1, 'order' => 0,
    ]);
    $world = $tables['area_administratives']->find()->where(['parent_id IS' => null])->firstOrFail();
    $adminCountryLevel = $tables['area_administrative_levels']->find()->where(['level' => 0])->firstOrFail();
    $connection->execute('UPDATE area_administratives SET is_main_country=0 WHERE is_main_country=1');
    $administrativeCountry = $upsert('area_administratives', ['code' => 'YEM'], [
        'name' => 'اليمن', 'parent_id' => $world->id, 'area_administrative_level_id' => $adminCountryLevel->id,
        'is_main_country' => 1, 'visible' => 1, 'order' => 0,
    ]);
    $adminGovernorateLevel = $upsert('area_administrative_levels', [
        'area_administrative_id' => $administrativeCountry, 'level' => 1,
    ], ['name' => 'محافظة']);
    foreach ($governorates as $code => $name) {
        $common = ['name' => $name, 'visible' => 1, 'order' => array_search($code, array_keys($governorates), true) + 1];
        $upsert('areas', ['code' => 'YEM-' . $code], $common + [
            'parent_id' => $educationCountry, 'area_level_id' => $governorateLevel->id,
        ]);
        $upsert('area_administratives', ['code' => 'YEM-' . $code], $common + [
            'parent_id' => $administrativeCountry, 'area_administrative_level_id' => $adminGovernorateLevel,
            'is_main_country' => 0,
        ]);
    }
    foreach (['institution_area_level_id' => 2, 'institution_validate_area_level_id' => 2,
        'institution_validate_area_administrative_level_id' => $adminGovernorateLevel] as $code => $value) {
        $connection->execute('UPDATE config_items SET value=:value WHERE code=:code', ['value' => (string)$value, 'code' => $code]);
    }
    foreach (['areas' => $educationCountry, 'area_administratives' => $administrativeCountry] as $name => $parent) {
        $country = $tables[$name]->get($parent);
        $children = $tables[$name]->find()->where(['parent_id' => $parent])->all();
        if (count($children) !== 22) {
            throw new RuntimeException('Expected exactly 22 governorates in ' . $name);
        }
        foreach ($children as $child) {
            if (!($country->lft < $child->lft && $child->lft < $child->rght && $child->rght < $country->rght)) {
                throw new RuntimeException('Invalid nested-tree bounds in ' . $name);
            }
        }
    }
    if (in_array('--dry-run', $argv, true)) {
        $connection->rollback();
        echo "Dry run PASS: Yemeni nationality and 22 governorates in both area trees.\n";
    } else {
        $connection->commit();
        echo json_encode(['nationality_id' => $nationality, 'education_yemen_id' => $educationCountry,
            'administrative_yemen_id' => $administrativeCountry, 'governorates_per_tree' => 22], JSON_UNESCAPED_UNICODE), "\n";
    }
} catch (Throwable $error) {
    if ($connection->inTransaction()) {
        $connection->rollback();
    }
    fwrite(STDERR, $error->getMessage() . "\n");
    exit(1);
}
