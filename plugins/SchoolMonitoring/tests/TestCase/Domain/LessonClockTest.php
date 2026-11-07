<?php
declare(strict_types=1);

namespace SchoolMonitoring\Test\TestCase\Domain;

use DateTimeImmutable;
use PHPUnit\Framework\TestCase;
use SchoolMonitoring\Domain\LessonClock;

final class LessonClockTest extends TestCase
{
    public function testSlotTimesAccumulateIntervals(): void
    {
        $start = new DateTimeImmutable('2026-11-07 07:00:00');
        $span = LessonClock::slotTimes($start, [40, 10, 40], 3);
        $this->assertSame('07:50:00', $span['start']->format('H:i:s'));
        $this->assertSame('08:30:00', $span['end']->format('H:i:s'));
    }

    public function testUnknownOrderThrows(): void
    {
        $this->expectException(\InvalidArgumentException::class);
        LessonClock::slotTimes(new DateTimeImmutable('2026-11-07 07:00:00'), [40], 2);
    }

    public function testMondayFirstFiveDayWeek(): void
    {
        $monday = new DateTimeImmutable('2026-11-09'); // Monday
        $this->assertSame(1, LessonClock::dayOfWeekIndex($monday, 1, 5));
        $friday = new DateTimeImmutable('2026-11-13');
        $this->assertSame(5, LessonClock::dayOfWeekIndex($friday, 1, 5));
        $saturday = new DateTimeImmutable('2026-11-14');
        $this->assertNull(LessonClock::dayOfWeekIndex($saturday, 1, 5));
    }
}
