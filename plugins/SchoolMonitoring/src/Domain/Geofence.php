<?php
declare(strict_types=1);

namespace SchoolMonitoring\Domain;

final class Geofence
{
    public function __construct(
        private float $radiusMeters = 150.0,
        private float $maxAccuracyMeters = 100.0
    ) {
    }

    /**
     * @return array{ok: bool, reason: string, distance: ?float}
     */
    public function check(?string $schoolLat, ?string $schoolLon, ?float $lat, ?float $lon, ?float $accuracy): array
    {
        $school = $this->parseCoordinatePair($schoolLat, $schoolLon);
        if ($school === null) {
            return ['ok' => false, 'reason' => 'school_coordinates_missing', 'distance' => null];
        }
        if ($lat === null || $lon === null || !$this->inRange($lat, $lon)) {
            return ['ok' => false, 'reason' => 'device_coordinates_invalid', 'distance' => null];
        }
        if ($accuracy !== null && $accuracy > $this->maxAccuracyMeters) {
            return ['ok' => false, 'reason' => 'accuracy_too_low', 'distance' => null];
        }
        $distance = Haversine::meters($school[0], $school[1], $lat, $lon);
        if ($distance > $this->radiusMeters) {
            return ['ok' => false, 'reason' => 'outside_geofence', 'distance' => $distance];
        }

        return ['ok' => true, 'reason' => 'inside', 'distance' => $distance];
    }

    /** @return array{0: float, 1: float}|null */
    public function parseCoordinatePair(?string $lat, ?string $lon): ?array
    {
        if ($lat === null || $lon === null || $lat === '' || $lon === '') {
            return null;
        }
        if (!is_numeric($lat) || !is_numeric($lon)) {
            return null;
        }
        $latF = (float)$lat;
        $lonF = (float)$lon;
        if (!$this->inRange($latF, $lonF)) {
            return null;
        }

        return [$latF, $lonF];
    }

    private function inRange(float $lat, float $lon): bool
    {
        return $lat >= -90 && $lat <= 90 && $lon >= -180 && $lon <= 180;
    }
}
