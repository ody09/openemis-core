<?php
declare(strict_types=1);

namespace SchoolMonitoring\Controller;

use Cake\Http\Exception\ForbiddenException;
use SchoolMonitoring\Domain\Schema;
use SchoolMonitoring\Domain\TextbookLoanService;

class TextbookLoansController extends AppController
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
        $rows = $personId && $periodId
            ? (new TextbookLoanService($pdo))->outstandingForPerson($personId, $periodId)
            : [];
        $this->viewBuilder()->setLayout('capture');
        $this->set(compact('rows', 'periodId', 'personId'));
    }

    public function returnCopy()
    {
        $this->request->allowMethod(['post']);
        $user = $this->Auth->user();
        if (!$user) {
            throw new ForbiddenException();
        }
        $pdo = $this->pdo();
        Schema::install($pdo);
        $outcome = (string)$this->request->getData('outcome') ?: TextbookLoanService::RETURNED;
        (new TextbookLoanService($pdo))->closeLoan(
            (int)$this->request->getData('institution_textbook_id'),
            (int)$this->request->getData('academic_period_id'),
            (int)$user['id'],
            $outcome,
            $this->request->getData('return_condition_id') ? (int)$this->request->getData('return_condition_id') : null,
            (string)$this->request->getData('notes')
        );
        $this->Flash->success(__('Textbook return recorded.'));
        return $this->redirect($this->referer(['action' => 'index']));
    }

    private function pdo(): \PDO
    {
        return $this->getTableLocator()->get('Institution.InstitutionTextbooks')->getConnection()->getDriver()->getConnection();
    }
}
