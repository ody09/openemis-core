<?php
declare(strict_types=1);

namespace SchoolMonitoring\Domain;

use DateTimeImmutable;
use DateTimeZone;
use PDO;

final class LessonFinder
{
    public function __construct(private PDO $pdo)
    {
    }

    /**
     * @return list<array<string, mixed>>
     */
    public function forStaffOnDate(int $staffId, DateTimeImmutable $date): array
    {
        $firstDay = $this->configInt('first_day_of_week', 1);
        $daysPerWeek = $this->configInt('days_per_week', 5);
        $dayIndex = LessonClock::dayOfWeekIndex($date, $firstDay, $daysPerWeek);
        if ($dayIndex === null) {
            return [];
        }
        $sql = 'SELECT
                    d.id AS lesson_detail_id,
                    t.id AS timetable_id,
                    t.institution_id,
                    t.academic_period_id,
                    t.institution_class_id AS class_id,
                    c.institution_subject_id AS subject_id,
                    l.institution_schedule_timeslot_id AS timeslot_id,
                    l.day_of_week,
                    ts.`order` AS slot_order,
                    ts.interval AS slot_minutes,
                    i.institution_shift_id,
                    sh.start_time AS shift_start,
                    inst.latitude AS school_latitude,
                    inst.longitude AS school_longitude
                FROM institution_schedule_lesson_details d
                INNER JOIN institution_schedule_lessons l
                    ON l.day_of_week = d.day_of_week
                    AND l.institution_schedule_timeslot_id = d.institution_schedule_timeslot_id
                    AND l.institution_schedule_timetable_id = d.institution_schedule_timetable_id
                INNER JOIN institution_schedule_timetables t ON t.id = l.institution_schedule_timetable_id
                INNER JOIN institution_schedule_timeslots ts ON ts.id = l.institution_schedule_timeslot_id
                INNER JOIN institution_schedule_intervals i ON i.id = ts.institution_schedule_interval_id
                LEFT JOIN institution_shifts sh ON sh.id = i.institution_shift_id
                LEFT JOIN institution_schedule_curriculum_lessons c
                    ON c.institution_schedule_lesson_detail_id = d.id
                LEFT JOIN institution_subject_staff ss
                    ON ss.institution_subject_id = c.institution_subject_id AND ss.staff_id = ?
                INNER JOIN institutions inst ON inst.id = t.institution_id
                WHERE t.status = 2 AND l.day_of_week = ? AND ss.staff_id = ?';
        try {
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute([$staffId, $dayIndex, $staffId]);
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC) ?: [];
        } catch (\Throwable $e) {
            return [];
        }

        $out = [];
        foreach ($rows as $row) {
            $shiftStart = $this->shiftStart($date, $row['shift_start'] ?? '07:00:00');
            $intervals = $this->intervalsForShift((int)$row['institution_shift_id']);
            $order = (int)($row['slot_order'] ?? 1);
            try {
                $span = LessonClock::slotTimes($shiftStart, $intervals !== [] ? $intervals : [(int)($row['slot_minutes'] ?: 40)], $order);
            } catch (\Throwable $e) {
                $span = ['start' => $shiftStart, 'end' => $shiftStart->modify('+40 minutes')];
            }
            $out[] = [
                'lesson_detail_id' => (int)$row['lesson_detail_id'],
                'lesson_key' => 'lesson:' . $row['lesson_detail_id'] . ':' . $date->format('Y-m-d'),
                'lesson_date' => $date->format('Y-m-d'),
                'institution_id' => (int)$row['institution_id'],
                'academic_period_id' => (int)$row['academic_period_id'],
                'timetable_id' => (int)$row['timetable_id'],
                'class_id' => $row['class_id'] ? (int)$row['class_id'] : null,
                'subject_id' => $row['subject_id'] ? (int)$row['subject_id'] : null,
                'timeslot_id' => $row['timeslot_id'] ? (int)$row['timeslot_id'] : null,
                'day_of_week' => (int)$row['day_of_week'],
                'scheduled_start_at' => $span['start']->format('Y-m-d H:i:s'),
                'scheduled_end_at' => $span['end']->format('Y-m-d H:i:s'),
                'scheduled_at' => $span['start']->format('Y-m-d H:i:s'),
                'school_latitude' => $row['school_latitude'],
                'school_longitude' => $row['school_longitude'],
            ];
        }

        return $out;
    }

    private function configInt(string $code, int $default): int
    {
        try {
            $stmt = $this->pdo->prepare('SELECT value FROM config_items WHERE code = ?');
            $stmt->execute([$code]);
            $value = $stmt->fetchColumn();
            return $value === false || $value === null || $value === '' ? $default : (int)$value;
        } catch (\Throwable $e) {
            return $default;
        }
    }

    private function shiftStart(DateTimeImmutable $date, string $startTime): DateTimeImmutable
    {
        $time = preg_match('/^\d{2}:\d{2}/', $startTime) ? substr($startTime, 0, 8) : '07:00:00';
        if (strlen($time) === 5) {
            $time .= ':00';
        }

        return new DateTimeImmutable($date->format('Y-m-d') . ' ' . $time, new DateTimeZone('UTC'));
    }

    /** @return list<int> */
    private function intervalsForShift(int $shiftId): array
    {
        if ($shiftId < 1) {
            return [];
        }
        try {
            $stmt = $this->pdo->prepare(
                'SELECT ts.interval FROM institution_schedule_timeslots ts
                 INNER JOIN institution_schedule_intervals i ON i.id = ts.institution_schedule_interval_id
                 WHERE i.institution_shift_id = ? ORDER BY ts.`order` ASC'
            );
            $stmt->execute([$shiftId]);
            return array_map('intval', $stmt->fetchAll(PDO::FETCH_COLUMN) ?: []);
        } catch (\Throwable $e) {
            return [];
        }
    }
}
