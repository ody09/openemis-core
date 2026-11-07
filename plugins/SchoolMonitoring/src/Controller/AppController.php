<?php
declare(strict_types=1);

namespace SchoolMonitoring\Controller;

use App\Controller\AppController as BaseController;
use Cake\Event\EventInterface;

class AppController extends BaseController
{
    public function beforeFilter(EventInterface $event)
    {
        parent::beforeFilter($event);
        $this->viewBuilder()->setLayout('default');
    }

    public function beforeRender(EventInterface $event)
    {
        parent::beforeRender($event);
        $this->set('backUrl', $this->monitoringBackUrl());
    }

    private function monitoringBackUrl(): string
    {
        $institutionId = $this->request->getSession()->read('Institution.Institutions.id');
        if ($institutionId) {
            return '/Institution/Institutions/dashboard/' . $this->paramsEncode([
                'id' => (int)$institutionId,
                'institution_id' => (int)$institutionId,
            ]);
        }
        $referer = (string)$this->referer('/Institutions/Institutions/index', true);
        foreach (['/LessonPhotos', '/TextbookLoans', '/Clearance', '/Error', '/school-monitoring'] as $skip) {
            if (str_contains($referer, $skip)) {
                return '/Institutions/Institutions/index';
            }
        }

        return $referer !== '' ? $referer : '/Institutions/Institutions/index';
    }
}
