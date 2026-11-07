<?php
declare(strict_types=1);

namespace SchoolMonitoring\Domain;

use DateTimeImmutable;

final class LessonClock
{
    /**
     * @param list<int> $intervalsMinutes slots ordered by `order` ascending
     * @return array{start: DateTimeImmutable, end: DateTimeImmutable}
     */
    public static function slotTimes(DateTimeImmutable $shiftStart, array $intervalsMinutes, int $order): array
    {
        $elapsed = 0;
        foreach ($intervalsMinutes as $index => $minutes) {
            $slotOrder = $index + 1;
            if ($slotOrder < $order) {
                $elapsed += $minutes;
                continue;
            }
            if ($slotOrder === $order) {
                $start = $shiftStart->modify('+' . $elapsed . ' minutes');
                $end = $start->modify('+' . $minutes . ' minutes');

                return ['start' => $start, 'end' => $end];
            }
        }

        throw new \InvalidArgumentException('Timeslot order is not in the interval list.');
    }

    /**
     * 1-based timetable weekday index, or null when the date is not a working day.
     */
    public static function dayOfWeekIndex(DateTimeImmutable $date, int $firstDayOfWeek, int $daysPerWeek): ?int
    {
        $weekdays = range(0, 6);
        $working = [];
        for ($i = 0; $i < $daysPerWeek; $i++) {
            $working[] = ($firstDayOfWeek + $i) % 7;
        }
        $iso = (int)$date->format('w');
        $position = array_search($iso, $working, true);

        return $position === false ? null : $position + 1;
    }
}
