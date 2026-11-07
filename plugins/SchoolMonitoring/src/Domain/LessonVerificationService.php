<?php
declare(strict_types=1);

namespace SchoolMonitoring\Domain;

use DateTimeImmutable;
use DateTimeZone;
use PDO;

final class LessonVerificationService
{
    public const PHASE_START = 1;
    public const PHASE_END = 2;

    public function __construct(
        private PDO $pdo,
        private string $storageRoot,
        private string $tokenSecret,
        private Geofence $geofence = new Geofence(),
        private TimeWindow $window = new TimeWindow(),
        private PhotoProcessor $photos = new PhotoProcessor()
    ) {
    }

    public function token(): CaptureToken
    {
        return new CaptureToken($this->tokenSecret);
    }

    /**
     * @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function storePhoto(array $input): array
    {
        $userId = (int)$input['user_id'];
        $lessonKey = (string)$input['lesson_key'];
        $phase = (int)$input['phase'];
        $this->token()->verify((string)$input['token'], $userId, $lessonKey, $phase);

        $scheduled = new DateTimeImmutable((string)$input['scheduled_at'], new DateTimeZone('UTC'));
        $received = new DateTimeImmutable('now', new DateTimeZone('UTC'));
        $timeOk = $this->window->allows($scheduled, $received);
        if (!$timeOk) {
            throw new \RuntimeException('outside_time_window');
        }

        $geo = $this->geofence->check(
            $input['school_latitude'] ?? null,
            $input['school_longitude'] ?? null,
            isset($input['latitude']) ? (float)$input['latitude'] : null,
            isset($input['longitude']) ? (float)$input['longitude'] : null,
            isset($input['accuracy']) ? (float)$input['accuracy'] : null
        );
        if (!$geo['ok']) {
            throw new \RuntimeException($geo['reason']);
        }

        $verificationId = $this->ensureVerification($input, $received);
        if ($phase === self::PHASE_END && !$this->hasPhase($verificationId, self::PHASE_START)) {
            throw new \RuntimeException('start_photo_required');
        }
        if ($this->hasPhase($verificationId, $phase)) {
            throw new \RuntimeException('phase_already_captured');
        }

        $watermark = sprintf(
            '%s inst:%s dist:%sm',
            $received->format('Y-m-d H:i:s'),
            (string)$input['institution_id'],
            $geo['distance'] === null ? '-' : (string)round($geo['distance'])
        );
        $processed = $this->photos->processJpeg((string)$input['jpeg'], $watermark);

        $dup = $this->pdo->prepare('SELECT id FROM sm_lesson_verification_photos WHERE file_sha256 = ?');
        $dup->execute([$processed['sha256']]);
        if ($dup->fetchColumn()) {
            throw new \RuntimeException('duplicate_image');
        }

        $relative = sprintf(
            '%d/%s/%s/%s.jpg',
            (int)$input['institution_id'],
            $received->format('Y'),
            $received->format('m'),
            bin2hex(random_bytes(8))
        );
        $absolute = rtrim($this->storageRoot, '/\\') . DIRECTORY_SEPARATOR . str_replace('/', DIRECTORY_SEPARATOR, $relative);
        $dir = dirname($absolute);
        if (!is_dir($dir) && !mkdir($dir, 0770, true) && !is_dir($dir)) {
            throw new \RuntimeException('storage_unwritable');
        }
        file_put_contents($absolute, $processed['binary']);

        $this->pdo->prepare(
            'INSERT INTO sm_lesson_verification_photos (
                lesson_verification_id, phase, file_path, file_sha256, perceptual_hash, mime_type,
                width, height, size_bytes, server_received_at, client_reported_at,
                latitude, longitude, accuracy, distance_meters, geofence_result, time_window_result, capture_nonce, ip, user_agent
            ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)'
        )->execute([
            $verificationId,
            $phase,
            $relative,
            $processed['sha256'],
            $processed['perceptual_hash'],
            'image/jpeg',
            $processed['width'],
            $processed['height'],
            strlen($processed['binary']),
            $received->format('Y-m-d H:i:s'),
            $input['client_reported_at'] ?? null,
            $input['latitude'] ?? null,
            $input['longitude'] ?? null,
            $input['accuracy'] ?? null,
            $geo['distance'],
            $geo['reason'],
            'inside',
            $input['nonce'] ?? null,
            $input['ip'] ?? null,
            $input['user_agent'] ?? null,
        ]);

        return ['verification_id' => $verificationId, 'path' => $relative, 'distance' => $geo['distance']];
    }

    /** @param array<string, mixed> $input */
    private function ensureVerification(array $input, DateTimeImmutable $received): int
    {
        $find = $this->pdo->prepare(
            'SELECT id FROM sm_lesson_verifications WHERE institution_schedule_lesson_detail_id = ? AND lesson_date = ? AND staff_id = ?'
        );
        $find->execute([(int)$input['lesson_detail_id'], (string)$input['lesson_date'], (int)$input['user_id']]);
        $id = $find->fetchColumn();
        if ($id) {
            return (int)$id;
        }
        $this->pdo->prepare(
            'INSERT INTO sm_lesson_verifications (
                institution_id, academic_period_id, institution_schedule_lesson_detail_id, lesson_date, staff_id,
                institution_schedule_timetable_id, institution_class_id, institution_subject_id,
                institution_schedule_timeslot_id, day_of_week, scheduled_start_at, scheduled_end_at, status, created, created_user_id
            ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)'
        )->execute([
            (int)$input['institution_id'],
            (int)$input['academic_period_id'],
            (int)$input['lesson_detail_id'],
            (string)$input['lesson_date'],
            (int)$input['user_id'],
            $input['timetable_id'] ?? null,
            $input['class_id'] ?? null,
            $input['subject_id'] ?? null,
            $input['timeslot_id'] ?? null,
            $input['day_of_week'] ?? null,
            $input['scheduled_start_at'] ?? null,
            $input['scheduled_end_at'] ?? null,
            'pending_review',
            $received->format('Y-m-d H:i:s'),
            (int)$input['user_id'],
        ]);

        return (int)$this->pdo->lastInsertId();
    }

    private function hasPhase(int $verificationId, int $phase): bool
    {
        $stmt = $this->pdo->prepare('SELECT id FROM sm_lesson_verification_photos WHERE lesson_verification_id = ? AND phase = ?');
        $stmt->execute([$verificationId, $phase]);

        return (bool)$stmt->fetchColumn();
    }
}
