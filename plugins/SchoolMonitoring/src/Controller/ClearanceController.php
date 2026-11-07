<?php
declare(strict_types=1);

namespace SchoolMonitoring\Controller;

use Cake\Http\Exception\ForbiddenException;
use SchoolMonitoring\Domain\Schema;
use SchoolMonitoring\Domain\TextbookLoanService;

class ClearanceController extends AppController
{
    public function index()
    {
        $user = $this->Auth->user();
        if (!$user) {
            throw new ForbiddenException();
        }
        $pdo = $this->pdo();
        Schema::install($pdo);
        $periodId = (int)$this->request->getQuery('academic_period_id');
        $personId = (int)$this->request->getQuery('security_user_id');
        $outstanding = $personId && $periodId
            ? (new TextbookLoanService($pdo))->outstandingForPerson($personId, $periodId)
            : [];
        $cleared = $personId && $periodId
            ? (new TextbookLoanService($pdo))->isCleared($personId, $periodId)
            : false;
        $this->viewBuilder()->setLayout('capture');
        $this->set(compact('outstanding', 'cleared', 'periodId', 'personId'));
    }

    private function pdo(): \PDO
    {
        return $this->getTableLocator()->get('Institution.Institutions')->getConnection()->getDriver()->getConnection();
    }
}
