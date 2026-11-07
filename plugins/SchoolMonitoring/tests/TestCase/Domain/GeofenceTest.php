<?php
declare(strict_types=1);

namespace SchoolMonitoring\Test\TestCase\Domain;

use PHPUnit\Framework\TestCase;
use SchoolMonitoring\Domain\Geofence;

final class GeofenceTest extends TestCase
{
    public function testInsideDefaultRadius(): void
    {
        $geo = new Geofence();
        $result = $geo->check('0', '0', 0.001, 0.0, 20.0);
        $this->assertTrue($result['ok']);
        $this->assertSame('inside', $result['reason']);
        $this->assertNotNull($result['distance']);
        $this->assertLessThan(150, $result['distance']);
    }

    public function testOutsideDefaultRadius(): void
    {
        $geo = new Geofence();
        $result = $geo->check('0', '0', 0.01, 0.0, 20.0);
        $this->assertFalse($result['ok']);
        $this->assertSame('outside_geofence', $result['reason']);
        $this->assertGreaterThan(150, $result['distance']);
    }

    public function testMissingSchoolCoordinates(): void
    {
        $result = (new Geofence())->check('', '', 0.0, 0.0, 10.0);
        $this->assertFalse($result['ok']);
        $this->assertSame('school_coordinates_missing', $result['reason']);
    }

    public function testAccuracyTooLow(): void
    {
        $result = (new Geofence())->check('0', '0', 0.0, 0.0, 250.0);
        $this->assertFalse($result['ok']);
        $this->assertSame('accuracy_too_low', $result['reason']);
    }

    public function testInvalidDeviceCoordinates(): void
    {
        $result = (new Geofence())->check('0', '0', 95.0, 0.0, 10.0);
        $this->assertFalse($result['ok']);
        $this->assertSame('device_coordinates_invalid', $result['reason']);
    }
}
