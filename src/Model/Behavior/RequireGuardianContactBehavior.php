<?php
declare(strict_types=1);

namespace App\Model\Behavior;

use App\SchoolMonitoring\GuardianContactPolicy;
use ArrayObject;
use Cake\Datasource\EntityInterface;
use Cake\Event\EventInterface;
use Cake\ORM\Behavior;

final class RequireGuardianContactBehavior extends Behavior
{
    public static function enforceEnrollment(EventInterface $event, EntityInterface $entity, ArrayObject $options): ?bool
    {
        $table = $event->getSubject();
        if (!$table instanceof \Cake\ORM\Table || $table->getTable() !== 'institution_students') {
            return null;
        }
        return (new self($table))->beforeSave($event, $entity, $options);
    }

    public function implementedEvents(): array
    {
        // Check before callbacks can create class assignments or other side effects.
        return ['Model.beforeSave' => ['callable' => 'beforeSave', 'priority' => 1]];
    }

    public function beforeSave(EventInterface $event, EntityInterface $entity, ArrayObject $options): ?bool
    {
        if (!$entity->isNew() && !$entity->isDirty('student_id')) {
            return null;
        }
        $driver = $this->_table->getConnection()->getDriver();
        $driver->connect();
        $policy = new GuardianContactPolicy($driver->getConnection());
        if (!$policy->hasPrimaryPhone((int)$entity->get('student_id'))) {
            $entity->setError('student_id', ['guardianContact' => GuardianContactPolicy::MESSAGE]);
            return false;
        }
        return null;
    }
}
