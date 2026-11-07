<?php
declare(strict_types=1);

namespace SchoolMonitoring\Listener;

use Cake\Event\EventInterface;
use Cake\ORM\Entity;
use SchoolMonitoring\Domain\Schema;
use SchoolMonitoring\Domain\TextbookLoanService;

final class TextbookLoanListener
{
    public static function afterSave(EventInterface $event, Entity $entity): void
    {
        $subject = $event->getSubject();
        if (!is_object($subject) || !method_exists($subject, 'getTable')) {
            return;
        }
        if ($subject->getTable() !== 'institution_textbooks') {
            return;
        }
        if (!$entity->isDirty('security_user_id')) {
            return;
        }
        try {
            $pdo = $subject->getConnection()->getDriver()->getConnection();
            Schema::install($pdo);
            $service = new TextbookLoanService($pdo);
            $copyId = (int)$entity->id;
            $periodId = (int)$entity->academic_period_id;
            $actor = (int)($entity->modified_user_id ?: $entity->created_user_id ?: 1);
            $newHolder = $entity->security_user_id;
            $oldHolder = $entity->getOriginal('security_user_id');
            if ($oldHolder && !$newHolder) {
                try {
                    $service->closeLoan($copyId, $periodId, $actor, TextbookLoanService::RETURNED);
                } catch (\RuntimeException $e) {
                    // No open loan to close.
                }
                return;
            }
            if ($newHolder) {
                if ($oldHolder) {
                    try {
                        $service->closeLoan($copyId, $periodId, $actor, TextbookLoanService::RETURNED);
                    } catch (\RuntimeException $e) {
                    }
                }
                $service->openLoan($copyId, $periodId, (int)$newHolder, $actor);
            }
        } catch (\Throwable $e) {
            // Schema may not exist yet on a vanilla database; enrollment must still save.
        }
    }
}
