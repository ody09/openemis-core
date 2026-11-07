<?php
declare(strict_types=1);

namespace SchoolMonitoring\Test\TestCase\Domain;

use DateTimeImmutable;
use DateTimeZone;
use PHPUnit\Framework\TestCase;
use SchoolMonitoring\Domain\LessonVerificationService;

final class LessonVerificationServiceTest extends TestCase
{
    public function testStoresStartPhotoInsideFenceAndWindow(): void
    {
        if (!function_exists('imagecreatetruecolor')) {
            $this->markTestSkipped('GD required');
        }
        $pdo = SqliteFactory::pdo();
        $dir = sys_get_temp_dir() . DIRECTORY_SEPARATOR . 'sm-photos-' . bin2hex(random_bytes(4));
        mkdir($dir);
        $service = new LessonVerificationService($pdo, $dir, 'secret');
        $now = new DateTimeImmutable('now', new DateTimeZone('UTC'));
        $token = $service->token()->issue(5, 'lesson:1:' . $now->format('Y-m-d'), 1);
        $result = $service->storePhoto($this->payload($token, $now, 1, $this->jpeg(80, 80, 255, 0, 0)));
        $this->assertArrayHasKey('verification_id', $result);
        $this->assertFileExists($dir . DIRECTORY_SEPARATOR . str_replace('/', DIRECTORY_SEPARATOR, $result['path']));
    }

    public function testEndRequiresStart(): void
    {
        if (!function_exists('imagecreatetruecolor')) {
            $this->markTestSkipped('GD required');
        }
        $pdo = SqliteFactory::pdo();
        $dir = sys_get_temp_dir() . DIRECTORY_SEPARATOR . 'sm-photos-' . bin2hex(random_bytes(4));
        mkdir($dir);
        $service = new LessonVerificationService($pdo, $dir, 'secret');
        $now = new DateTimeImmutable('now', new DateTimeZone('UTC'));
        $token = $service->token()->issue(5, 'lesson:1:' . $now->format('Y-m-d'), 2);
        $this->expectException(\RuntimeException::class);
        $this->expectExceptionMessage('start_photo_required');
        $service->storePhoto($this->payload($token, $now, 2, $this->jpeg(64, 64, 0, 255, 0)));
    }

    public function testOutsideGeofenceRejected(): void
    {
        if (!function_exists('imagecreatetruecolor')) {
            $this->markTestSkipped('GD required');
        }
        $pdo = SqliteFactory::pdo();
        $dir = sys_get_temp_dir() . DIRECTORY_SEPARATOR . 'sm-photos-' . bin2hex(random_bytes(4));
        mkdir($dir);
        $service = new LessonVerificationService($pdo, $dir, 'secret');
        $now = new DateTimeImmutable('now', new DateTimeZone('UTC'));
        $token = $service->token()->issue(5, 'lesson:1:' . $now->format('Y-m-d'), 1);
        $payload = $this->payload($token, $now, 1, $this->jpeg(64, 64, 0, 0, 255));
        $payload['latitude'] = 0.05;
        $this->expectException(\RuntimeException::class);
        $this->expectExceptionMessage('outside_geofence');
        $service->storePhoto($payload);
    }

    /** @return array<string, mixed> */
    private function payload(string $token, DateTimeImmutable $now, int $phase, string $jpeg): array
    {
        return [
            'user_id' => 5,
            'token' => $token,
            'lesson_key' => 'lesson:1:' . $now->format('Y-m-d'),
            'phase' => $phase,
            'scheduled_at' => $now->format('Y-m-d H:i:s'),
            'school_latitude' => '0',
            'school_longitude' => '0',
            'latitude' => 0.0005,
            'longitude' => 0.0,
            'accuracy' => 15.0,
            'jpeg' => $jpeg,
            'institution_id' => 1,
            'academic_period_id' => 1,
            'lesson_detail_id' => 1,
            'lesson_date' => $now->format('Y-m-d'),
            'scheduled_start_at' => $now->format('Y-m-d H:i:s'),
            'scheduled_end_at' => $now->modify('+40 minutes')->format('Y-m-d H:i:s'),
        ];
    }

    private function jpeg(int $w, int $h, int $r, int $g, int $b): string
    {
        $im = imagecreatetruecolor($w, $h);
        imagefilledrectangle($im, 0, 0, $w, $h, imagecolorallocate($im, $r, $g, $b));
        ob_start();
        imagejpeg($im, null, 80);
        imagedestroy($im);

        return (string)ob_get_clean();
    }
}
