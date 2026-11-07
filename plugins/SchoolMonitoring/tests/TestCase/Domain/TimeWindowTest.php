<?php
declare(strict_types=1);

namespace SchoolMonitoring\Test\TestCase\Domain;

use DateTimeImmutable;
use PHPUnit\Framework\TestCase;
use SchoolMonitoring\Domain\TimeWindow;

final class TimeWindowTest extends TestCase
{
    public function testAllowsInsideDefaultWindow(): void
    {
        $scheduled = new DateTimeImmutable('2026-11-07 08:00:00');
        $window = new TimeWindow();
        $this->assertTrue($window->allows($scheduled, $scheduled->modify('-10 minutes')));
        $this->assertTrue($window->allows($scheduled, $scheduled->modify('+15 minutes')));
        $this->assertTrue($window->allows($scheduled, $scheduled));
    }

    public function testRejectsOutsideDefaultWindow(): void
    {
        $scheduled = new DateTimeImmutable('2026-11-07 08:00:00');
        $window = new TimeWindow();
        $this->assertFalse($window->allows($scheduled, $scheduled->modify('-11 minutes')));
        $this->assertFalse($window->allows($scheduled, $scheduled->modify('+16 minutes')));
    }
}
