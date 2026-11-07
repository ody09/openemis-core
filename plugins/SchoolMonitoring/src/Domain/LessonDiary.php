<?php
declare(strict_types=1);

namespace SchoolMonitoring\Domain;

use DateTimeImmutable;
use DateTimeZone;
use PDO;

final class LessonDiary
{
    private LessonFinder $finder;

    public function __construct(private PDO $pdo)
    {
        $this->finder = new LessonFinder($pdo);
    }

    /**
     * Published lessons for a school on a date, with the assigned teacher and any saved photos.
     *
     * @return list<array<string, mixed>>
     */
    public function forInstitutionOnDate(int $institutionId, DateTimeImmutable $date): array
    {
        $lessons = [];
        foreach ($this->staffIds($institutionId) as $staffId) {
            foreach ($this->finder->forStaffOnDate($staffId, $date) as $lesson) {
                if ((int)$lesson['institution_id'] !== $institutionId) {
                    continue;
                }
                $lesson['staff_id'] = $staffId;
                $lessons[$lesson['lesson_detail_id'] . ':' . $staffId] = $lesson;
            }
        }

        $rows = array_values($lessons);
        $this->attachNames($rows);
        $this->attachPhotos($rows, $institutionId, $date->format('Y-m-d'));
        usort($rows, static fn ($a, $b) => strcmp((string)$a['scheduled_start_at'], (string)$b['scheduled_start_at']));

        return $rows;
    }

    /** @return list<int> */
    private function staffIds(int $institutionId): array
    {
        $stmt = $this->pdo->prepare(
            'SELECT DISTINCT ss.staff_id
             FROM institution_subject_staff ss
             INNER JOIN institution_subjects s ON s.id = ss.institution_subject_id
             WHERE s.institution_id = ?'
        );
        $stmt->execute([$institutionId]);

        return array_map('intval', $stmt->fetchAll(PDO::FETCH_COLUMN) ?: []);
    }

    /** @param list<array<string, mixed>> $rows */
    private function attachNames(array &$rows): void
    {
        $classNames = $this->names('institution_classes', $this->ids($rows, 'class_id'));
        $subjectNames = $this->names('institution_subjects', $this->ids($rows, 'subject_id'));
        $staff = $this->staffNames($this->ids($rows, 'staff_id'));
        foreach ($rows as &$row) {
            $row['class_name'] = $classNames[(int)($row['class_id'] ?? 0)] ?? '';
            $row['subject_name'] = $subjectNames[(int)($row['subject_id'] ?? 0)] ?? '';
            $person = $staff[(int)$row['staff_id']] ?? ['name' => '', 'openemis_no' => ''];
            $row['staff_name'] = $person['name'];
            $row['staff_openemis_no'] = $person['openemis_no'];
        }
    }

    /** @param list<array<string, mixed>> $rows */
    private function attachPhotos(array &$rows, int $institutionId, string $date): void
    {
        $byKey = [];
        try {
            $stmt = $this->pdo->prepare(
                'SELECT v.institution_schedule_lesson_detail_id AS lesson_detail_id, v.staff_id,
                        p.phase, p.file_path, p.server_received_at
                 FROM sm_lesson_verifications v
                 INNER JOIN sm_lesson_verification_photos p ON p.lesson_verification_id = v.id
                 WHERE v.institution_id = ? AND v.lesson_date = ?'
            );
            $stmt->execute([$institutionId, $date]);
            foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) ?: [] as $photo) {
                $key = (int)$photo['lesson_detail_id'] . ':' . (int)$photo['staff_id'];
                $byKey[$key][(int)$photo['phase']] = $photo;
            }
        } catch (\Throwable $e) {
            $byKey = [];
        }

        foreach ($rows as &$row) {
            $key = (int)$row['lesson_detail_id'] . ':' . (int)$row['staff_id'];
            $photos = $byKey[$key] ?? [];
            $row['start_photo'] = $photos[1]['file_path'] ?? null;
            $row['end_photo'] = $photos[2]['file_path'] ?? null;
        }
    }

    /** @param list<int> $ids @return array<int, string> */
    private function names(string $table, array $ids): array
    {
        if ($ids === [] || !preg_match('/^[a-z_]+$/', $table)) {
            return [];
        }
        $placeholders = implode(',', array_fill(0, count($ids), '?'));
        $stmt = $this->pdo->prepare("SELECT id, name FROM {$table} WHERE id IN ($placeholders)");
        $stmt->execute($ids);
        $out = [];
        foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) ?: [] as $row) {
            $out[(int)$row['id']] = (string)$row['name'];
        }

        return $out;
    }

    /**
     * @param list<int> $ids
     * @return array<int, array{name: string, openemis_no: string}>
     */
    private function staffNames(array $ids): array
    {
        if ($ids === []) {
            return [];
        }
        $placeholders = implode(',', array_fill(0, count($ids), '?'));
        $stmt = $this->pdo->prepare(
            "SELECT id, first_name, last_name, openemis_no FROM security_users WHERE id IN ($placeholders)"
        );
        $stmt->execute($ids);
        $out = [];
        foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) ?: [] as $row) {
            $out[(int)$row['id']] = [
                'name' => trim((string)$row['first_name'] . ' ' . (string)$row['last_name']),
                'openemis_no' => (string)$row['openemis_no'],
            ];
        }

        return $out;
    }

    /** @param list<array<string, mixed>> $rows @return list<int> */
    private function ids(array $rows, string $key): array
    {
        $ids = [];
        foreach ($rows as $row) {
            $id = (int)($row[$key] ?? 0);
            if ($id > 0) {
                $ids[$id] = $id;
            }
        }

        return array_values($ids);
    }

    public static function localTime(string $utc, string $timezone = 'Asia/Aden'): string
    {
        $moment = new DateTimeImmutable($utc, new DateTimeZone('UTC'));

        return $moment->setTimezone(new DateTimeZone($timezone))->format('H:i');
    }
}
