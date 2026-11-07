<?php
declare(strict_types=1);

namespace SchoolMonitoring\Test\TestCase\Domain;

use PHPUnit\Framework\TestCase;
use SchoolMonitoring\Domain\PhotoProcessor;

final class PhotoProcessorTest extends TestCase
{
    public function testResizesAndHashes(): void
    {
        if (!function_exists('imagecreatetruecolor')) {
            $this->markTestSkipped('GD required');
        }
        $im = imagecreatetruecolor(2000, 1000);
        imagefilledrectangle($im, 0, 0, 2000, 1000, imagecolorallocate($im, 10, 20, 30));
        ob_start();
        imagejpeg($im, null, 90);
        imagedestroy($im);
        $bytes = (string)ob_get_clean();
        $out = (new PhotoProcessor())->processJpeg($bytes, 'test watermark');
        $this->assertLessThanOrEqual(1280, $out['width']);
        $this->assertSame(64, strlen($out['perceptual_hash']));
        $this->assertSame(64, strlen($out['sha256']));
        $this->assertNotSame('', $out['binary']);
    }
}
