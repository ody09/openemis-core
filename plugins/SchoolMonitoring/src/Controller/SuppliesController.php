<?php
declare(strict_types=1);

namespace SchoolMonitoring\Controller;

use Cake\Http\Exception\ForbiddenException;
use SchoolMonitoring\Domain\Schema;
use SchoolMonitoring\Domain\SupplyService;

class SuppliesController extends AppController
{
    public function initialize(): void
    {
        parent::initialize();
        $this->autoRender = false;
    }

    public function issue()
    {
        $this->request->allowMethod(['post']);
        $user = $this->requireUser();
        $pdo = $this->pdo();
        Schema::install($pdo);
        $id = (new SupplyService($pdo))->issue(
            (int)$this->request->getData('institution_id'),
            (int)$this->request->getData('academic_period_id'),
            (int)$this->request->getData('item_id'),
            (int)$this->request->getData('security_user_id'),
            (int)$this->request->getData('quantity'),
            (int)$user['id']
        );
        return $this->json(['id' => $id]);
    }

    public function returnItem()
    {
        $this->request->allowMethod(['post']);
        $this->requireUser();
        $pdo = $this->pdo();
        Schema::install($pdo);
        (new SupplyService($pdo))->returnItem(
            (int)$this->request->getData('issue_id'),
            (int)$this->request->getData('quantity'),
            (string)$this->request->getData('outcome') ?: 'RETURNED'
        );
        return $this->json(['ok' => true]);
    }

    /** @return array<string, mixed> */
    private function requireUser(): array
    {
        $user = $this->Auth->user();
        if (!$user) {
            throw new ForbiddenException();
        }
        return $user;
    }

    private function pdo(): \PDO
    {
        return $this->getTableLocator()->get('Institution.Institutions')->getConnection()->getDriver()->getConnection();
    }

    private function json(array $payload)
    {
        $this->response = $this->response->withType('application/json')
            ->withStringBody(json_encode($payload, JSON_THROW_ON_ERROR));
        return $this->response;
    }
}
