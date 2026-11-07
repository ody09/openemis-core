<?php
declare(strict_types=1);

namespace SchoolMonitoring\Controller;

use Cake\Core\Configure;
use Cake\Event\EventInterface;
use Cake\Http\Exception\ForbiddenException;
use Cake\Http\Exception\NotFoundException;
use SchoolMonitoring\Domain\LessonVerificationService;
use SchoolMonitoring\Domain\Schema;

class LessonPhotosController extends AppController
{
    public function initialize(): void
    {
        parent::initialize();
        $this->autoRender = false;
    }

    public function beforeFilter(EventInterface $event)
    {
        parent::beforeFilter($event);
    }

    public function index()
    {
        $this->autoRender = true;
        $this->viewBuilder()->setLayout('capture');
        $this->set('csrfToken', $this->request->getAttribute('csrfToken') ?? '');
    }

    public function review()
    {
        $user = $this->Auth->user();
        if (!$user) {
            throw new ForbiddenException();
        }
        $pdo = $this->pdo();
        Schema::install($pdo);
        $zone = new \DateTimeZone('Asia/Aden');
        $dateText = (string)$this->request->getQuery('date');
        if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $dateText)) {
            $dateText = (new \DateTimeImmutable('now', $zone))->format('Y-m-d');
        }
        $institutionId = $this->currentInstitutionId();
        $lessons = $institutionId > 0
            ? (new \SchoolMonitoring\Domain\LessonDiary($pdo))->forInstitutionOnDate(
                $institutionId,
                new \DateTimeImmutable($dateText, new \DateTimeZone('UTC'))
            )
            : [];
        $this->autoRender = true;
        $this->viewBuilder()->setLayout('capture');
        $this->set('date', $dateText);
        $this->set('institutionId', $institutionId);
        $this->set('lessons', $lessons);
    }

    public function token()
    {
        $user = $this->Auth->user();
        if (!$user) {
            throw new ForbiddenException();
        }
        $service = $this->service();
        $token = $service->token()->issue(
            (int)$user['id'],
            (string)$this->request->getData('lesson_key'),
            (int)$this->request->getData('phase')
        );
        $this->response = $this->response->withType('application/json')
            ->withStringBody(json_encode(['token' => $token], JSON_THROW_ON_ERROR));
        return $this->response;
    }

    public function upload()
    {
        $user = $this->Auth->user();
        if (!$user) {
            throw new ForbiddenException();
        }
        $file = $this->request->getData('photo');
        $jpeg = is_object($file) && method_exists($file, 'getStream')
            ? (string)$file->getStream()
            : (string)$this->request->getData('photo_base64');
        if (str_starts_with($jpeg, 'data:image')) {
            $jpeg = (string)base64_decode(substr($jpeg, (int)strpos($jpeg, ',') + 1), true);
        }
        $pdo = $this->pdo();
        Schema::install($pdo);
        $service = $this->service();
        try {
            $result = $service->storePhoto([
                'user_id' => (int)$user['id'],
                'token' => (string)$this->request->getData('token'),
                'lesson_key' => (string)$this->request->getData('lesson_key'),
                'phase' => (int)$this->request->getData('phase'),
                'scheduled_at' => (string)$this->request->getData('scheduled_at'),
                'school_latitude' => $this->request->getData('school_latitude'),
                'school_longitude' => $this->request->getData('school_longitude'),
                'latitude' => $this->request->getData('latitude'),
                'longitude' => $this->request->getData('longitude'),
                'accuracy' => $this->request->getData('accuracy'),
                'jpeg' => $jpeg,
                'institution_id' => (int)$this->request->getData('institution_id'),
                'academic_period_id' => (int)$this->request->getData('academic_period_id'),
                'lesson_detail_id' => (int)$this->request->getData('lesson_detail_id'),
                'lesson_date' => (string)$this->request->getData('lesson_date'),
                'timetable_id' => $this->request->getData('timetable_id'),
                'class_id' => $this->request->getData('class_id'),
                'subject_id' => $this->request->getData('subject_id'),
                'timeslot_id' => $this->request->getData('timeslot_id'),
                'day_of_week' => $this->request->getData('day_of_week'),
                'scheduled_start_at' => $this->request->getData('scheduled_start_at'),
                'scheduled_end_at' => $this->request->getData('scheduled_end_at'),
                'client_reported_at' => $this->request->getData('client_reported_at'),
                'ip' => $this->request->clientIp(),
                'user_agent' => (string)$this->request->getHeaderLine('User-Agent'),
            ]);
        } catch (\Throwable $e) {
            $this->response = $this->response->withStatus(422)->withType('application/json')
                ->withStringBody(json_encode(['error' => $e->getMessage()], JSON_THROW_ON_ERROR));
            return $this->response;
        }
        $this->response = $this->response->withType('application/json')
            ->withStringBody(json_encode($result, JSON_THROW_ON_ERROR));
        return $this->response;
    }

    public function image()
    {
        $user = $this->Auth->user();
        if (!$user) {
            throw new ForbiddenException();
        }
        $path = (string)$this->request->getQuery('path');
        if ($path === '' || str_contains($path, '..')) {
            throw new NotFoundException();
        }
        $absolute = ROOT . DS . 'storage' . DS . 'school-monitoring' . DS . str_replace('/', DS, $path);
        if (!is_file($absolute)) {
            throw new NotFoundException();
        }
        return $this->response->withFile($absolute, ['download' => false]);
    }

    public function today()
    {
        $user = $this->Auth->user();
        if (!$user) {
            throw new ForbiddenException();
        }
        $lessons = (new \SchoolMonitoring\Domain\LessonFinder($this->pdo()))
            ->forStaffOnDate((int)$user['id'], new \DateTimeImmutable('now', new \DateTimeZone('UTC')));
        $this->response = $this->response->withType('application/json')
            ->withStringBody(json_encode(['lessons' => $lessons], JSON_THROW_ON_ERROR));
        return $this->response;
    }

    private function service(): LessonVerificationService
    {
        return new LessonVerificationService(
            $this->pdo(),
            ROOT . DS . 'storage' . DS . 'school-monitoring',
            (string)Configure::read('Security.salt')
        );
    }

    private function currentInstitutionId(): int
    {
        $queryId = (int)$this->request->getQuery('institution_id');
        if ($queryId > 0) {
            $this->request->getSession()->write('Institution.Institutions.id', $queryId);
            return $queryId;
        }
        $sessionId = (int)$this->request->getSession()->read('Institution.Institutions.id');
        if ($sessionId > 0) {
            return $sessionId;
        }
        $refererId = $this->institutionIdFromText((string)$this->referer());
        if ($refererId > 0) {
            $this->request->getSession()->write('Institution.Institutions.id', $refererId);
            return $refererId;
        }
        $ids = $this->pdo()->query('SELECT id FROM institutions')->fetchAll(\PDO::FETCH_COLUMN) ?: [];
        if (count($ids) === 1) {
            $only = (int)$ids[0];
            $this->request->getSession()->write('Institution.Institutions.id', $only);
            return $only;
        }

        return 0;
    }

    private function institutionIdFromText(string $text): int
    {
        if (!preg_match_all('/[A-Za-z0-9+\/=_-]{16,}/', $text, $matches)) {
            return 0;
        }
        foreach ($matches[0] as $token) {
            $decoded = base64_decode(strtr($token, '-_', '+/'), true);
            if ($decoded === false) {
                continue;
            }
            $data = json_decode($decoded, true);
            if (is_array($data) && !empty($data['institution_id'])) {
                return (int)$data['institution_id'];
            }
            if (is_array($data) && !empty($data['id']) && count($data) === 1) {
                return (int)$data['id'];
            }
        }

        return 0;
    }

    private function pdo(): \PDO
    {
        return $this->getTableLocator()->get('Institution.Institutions')->getConnection()->getDriver()->getConnection();
    }
}
