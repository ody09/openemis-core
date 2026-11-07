<?php
declare(strict_types=1);

namespace SchoolMonitoring\Test\TestCase\Domain;

use PHPUnit\Framework\TestCase;
use SchoolMonitoring\Domain\CaptureToken;

final class CaptureTokenTest extends TestCase
{
    public function testRoundTrip(): void
    {
        $tokens = new CaptureToken('secret');
        $token = $tokens->issue(9, 'lesson:1:2026-11-07', 1);
        $payload = $tokens->verify($token, 9, 'lesson:1:2026-11-07', 1);
        $this->assertSame(9, $payload['user_id']);
        $this->assertSame(1, $payload['phase']);
    }

    public function testRejectsTamperedMac(): void
    {
        $tokens = new CaptureToken('secret');
        $token = $tokens->issue(9, 'lesson:1', 1);
        $this->expectException(\RuntimeException::class);
        $tokens->verify($token . 'x', 9, 'lesson:1', 1);
    }

    public function testRejectsMismatchedUser(): void
    {
        $tokens = new CaptureToken('secret');
        $token = $tokens->issue(9, 'lesson:1', 1);
        $this->expectException(\RuntimeException::class);
        $tokens->verify($token, 8, 'lesson:1', 1);
    }
}
