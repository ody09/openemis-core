<?php
declare(strict_types=1);

namespace SchoolMonitoring\Test\TestCase\Domain;

use PHPUnit\Framework\TestCase;
use SchoolMonitoring\Domain\Haversine;

final class HaversineTest extends TestCase
{
    public function testSamePointIsZero(): void
    {
        $this->assertSame(0.0, Haversine::meters(24.7136, 46.6753, 24.7136, 46.6753));
    }

    public function testOneDegreeLatitudeIsAbout111km(): void
    {
        $meters = Haversine::meters(0.0, 0.0, 1.0, 0.0);
        $this->assertEqualsWithDelta(111195, $meters, 50);
    }

    public function testShortDisplacement(): void
    {
        $meters = Haversine::meters(0.0, 0.0, 0.001, 0.0);
        $this->assertEqualsWithDelta(111.2, $meters, 1.0);
    }
}
