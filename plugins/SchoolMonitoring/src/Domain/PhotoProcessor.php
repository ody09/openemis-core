<?php
declare(strict_types=1);

namespace SchoolMonitoring\Domain;

final class PhotoProcessor
{
    /**
     * @return array{binary: string, width: int, height: int, sha256: string, perceptual_hash: string}
     */
    public function processJpeg(string $bytes, string $watermark): array
    {
        if (!function_exists('imagecreatefromstring')) {
            throw new \RuntimeException('gd_missing');
        }
        $image = @imagecreatefromstring($bytes);
        if ($image === false) {
            throw new \RuntimeException('invalid_image');
        }
        $width = imagesx($image);
        $height = imagesy($image);
        $max = 1280;
        if ($width > $max || $height > $max) {
            $scale = min($max / $width, $max / $height);
            $nw = max(1, (int)round($width * $scale));
            $nh = max(1, (int)round($height * $scale));
            $resized = imagecreatetruecolor($nw, $nh);
            imagecopyresampled($resized, $image, 0, 0, 0, 0, $nw, $nh, $width, $height);
            imagedestroy($image);
            $image = $resized;
            $width = $nw;
            $height = $nh;
        }
        $barHeight = 24;
        $bar = imagecolorallocatealpha($image, 0, 0, 0, 40);
        imagefilledrectangle($image, 0, $height - $barHeight, $width, $height, $bar);
        $white = imagecolorallocate($image, 255, 255, 255);
        imagestring($image, 3, 6, $height - 18, substr($watermark, 0, 80), $white);

        ob_start();
        imagejpeg($image, null, 75);
        $binary = (string)ob_get_clean();
        $hash = $this->perceptualHash($image);
        imagedestroy($image);

        return [
            'binary' => $binary,
            'width' => $width,
            'height' => $height,
            'sha256' => hash('sha256', $binary),
            'perceptual_hash' => $hash,
        ];
    }

    private function perceptualHash(\GdImage $image): string
    {
        $small = imagecreatetruecolor(8, 8);
        imagecopyresampled($small, $image, 0, 0, 0, 0, 8, 8, imagesx($image), imagesy($image));
        $sum = 0;
        $pixels = [];
        for ($y = 0; $y < 8; $y++) {
            for ($x = 0; $x < 8; $x++) {
                $rgb = imagecolorat($small, $x, $y);
                $gray = (($rgb >> 16) & 255) * 0.299 + (($rgb >> 8) & 255) * 0.587 + ($rgb & 255) * 0.114;
                $pixels[] = $gray;
                $sum += $gray;
            }
        }
        imagedestroy($small);
        $avg = $sum / 64;
        $bits = '';
        foreach ($pixels as $gray) {
            $bits .= $gray >= $avg ? '1' : '0';
        }

        return $bits;
    }
}
