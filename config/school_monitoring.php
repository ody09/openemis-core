<?php
declare(strict_types=1);

use App\Model\Behavior\RequireGuardianContactBehavior;
use Cake\Event\EventManager;

// Include generic ORM aliases as well as the named student models, in HTTP and CLI.
EventManager::instance()->on('Model.beforeSave', ['priority' => 1], [RequireGuardianContactBehavior::class, 'enforceEnrollment']);
