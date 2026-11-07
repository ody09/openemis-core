<?php
declare(strict_types=1);

namespace SchoolMonitoring\Domain;

use DateTimeImmutable;

final class TimeWindow
{
    public function __construct(
        private int $beforeMinutes = 10,
        private int $afterMinutes = 15
    ) {
    }

    public function allows(DateTimeImmutable $scheduled, DateTimeImmutable $received): bool
    {
        $open = $scheduled->modify('-' . $this->beforeMinutes . ' minutes');
        $close = $scheduled->modify('+' . $this->afterMinutes . ' minutes');

        return $received >= $open && $received <= $close;
    }
}
