<?php
declare(strict_types=1);

namespace SchoolMonitoring\Domain;

use PDO;

final class Schema
{
    public static function install(PDO $pdo): void
    {
        $driver = $pdo->getAttribute(PDO::ATTR_DRIVER_NAME);
        $id = $driver === 'sqlite'
            ? 'INTEGER PRIMARY KEY AUTOINCREMENT'
            : 'INT NOT NULL AUTO_INCREMENT PRIMARY KEY';
        $text = $driver === 'sqlite' ? 'TEXT' : 'VARCHAR(250)';
        $dt = $driver === 'sqlite' ? 'TEXT' : 'DATETIME';
        $dec = $driver === 'sqlite' ? 'REAL' : 'DECIMAL(10,7)';
        $decDist = $driver === 'sqlite' ? 'REAL' : 'DECIMAL(8,2)';

        $pdo->exec("CREATE TABLE IF NOT EXISTS sm_textbook_loans (
            id $id,
            institution_textbook_id INT NOT NULL,
            academic_period_id INT NOT NULL,
            security_user_id INT NOT NULL,
            issued_at $dt NOT NULL,
            issued_by INT NOT NULL,
            due_date $dt DEFAULT NULL,
            returned_at $dt DEFAULT NULL,
            received_by INT DEFAULT NULL,
            return_outcome $text DEFAULT NULL,
            return_condition_id INT DEFAULT NULL,
            notes $text DEFAULT NULL
        )");
        self::index($pdo, 'CREATE INDEX sm_loans_copy ON sm_textbook_loans (institution_textbook_id, academic_period_id, returned_at)');
        self::index($pdo, 'CREATE INDEX sm_loans_person ON sm_textbook_loans (security_user_id, academic_period_id, returned_at)');

        $pdo->exec("CREATE TABLE IF NOT EXISTS sm_supply_categories (
            id $id,
            name $text NOT NULL
        )");
        $pdo->exec("CREATE TABLE IF NOT EXISTS sm_supply_items (
            id $id,
            code $text NOT NULL,
            name $text NOT NULL,
            category_id INT DEFAULT NULL,
            unit $text DEFAULT 'piece',
            is_returnable INT NOT NULL DEFAULT 1,
            education_grade_id INT DEFAULT NULL,
            education_subject_id INT DEFAULT NULL
        )");
        $pdo->exec("CREATE TABLE IF NOT EXISTS sm_supply_stock (
            id $id,
            institution_id INT NOT NULL,
            item_id INT NOT NULL,
            quantity INT NOT NULL DEFAULT 0
        )");
        $pdo->exec("CREATE TABLE IF NOT EXISTS sm_supply_issues (
            id $id,
            institution_id INT NOT NULL,
            academic_period_id INT NOT NULL,
            item_id INT NOT NULL,
            security_user_id INT NOT NULL,
            quantity_issued INT NOT NULL,
            quantity_returned INT NOT NULL DEFAULT 0,
            issued_at $dt NOT NULL,
            issued_by INT NOT NULL,
            returned_at $dt DEFAULT NULL,
            return_outcome $text DEFAULT NULL,
            notes $text DEFAULT NULL
        )");
        $pdo->exec("CREATE TABLE IF NOT EXISTS sm_clearances (
            id $id,
            institution_id INT NOT NULL,
            academic_period_id INT NOT NULL,
            security_user_id INT NOT NULL,
            cleared_at $dt DEFAULT NULL,
            cleared_by INT DEFAULT NULL,
            notes $text DEFAULT NULL
        )");

        $pdo->exec("CREATE TABLE IF NOT EXISTS sm_biometric_devices (
            id $id,
            institution_id INT NOT NULL,
            serial_number $text NOT NULL,
            vendor $text DEFAULT NULL,
            model $text DEFAULT NULL,
            api_key_hash $text NOT NULL,
            timezone $text DEFAULT 'UTC',
            last_seen_at $dt DEFAULT NULL,
            active INT NOT NULL DEFAULT 1
        )");
        $pdo->exec("CREATE TABLE IF NOT EXISTS sm_biometric_staff_ids (
            id $id,
            institution_id INT NOT NULL,
            device_user_id $text NOT NULL,
            staff_id INT NOT NULL
        )");
        $pdo->exec("CREATE TABLE IF NOT EXISTS sm_biometric_punches (
            id $id,
            device_id INT NOT NULL,
            device_user_id $text NOT NULL,
            staff_id INT DEFAULT NULL,
            punched_at $dt NOT NULL,
            received_at $dt NOT NULL,
            raw_payload $text DEFAULT NULL,
            processed_at $dt DEFAULT NULL,
            result $text DEFAULT NULL
        )");
        $pdo->exec("CREATE TABLE IF NOT EXISTS sm_staff_attendance_sources (
            id $id,
            staff_id INT NOT NULL,
            institution_id INT NOT NULL,
            attendance_date $text NOT NULL,
            source $text NOT NULL
        )");

        $pdo->exec("CREATE TABLE IF NOT EXISTS sm_lesson_verifications (
            id $id,
            institution_id INT NOT NULL,
            academic_period_id INT NOT NULL,
            institution_schedule_lesson_detail_id INT NOT NULL,
            lesson_date $text NOT NULL,
            staff_id INT NOT NULL,
            institution_schedule_timetable_id INT DEFAULT NULL,
            institution_class_id INT DEFAULT NULL,
            institution_subject_id INT DEFAULT NULL,
            institution_schedule_timeslot_id INT DEFAULT NULL,
            day_of_week INT DEFAULT NULL,
            scheduled_start_at $dt DEFAULT NULL,
            scheduled_end_at $dt DEFAULT NULL,
            status $text NOT NULL DEFAULT 'pending_review',
            assignee_id INT DEFAULT NULL,
            created $dt DEFAULT NULL,
            created_user_id INT DEFAULT NULL,
            modified $dt DEFAULT NULL,
            modified_user_id INT DEFAULT NULL
        )");
        $pdo->exec("CREATE TABLE IF NOT EXISTS sm_lesson_verification_photos (
            id $id,
            lesson_verification_id INT NOT NULL,
            phase INT NOT NULL,
            file_path $text NOT NULL,
            file_sha256 $text NOT NULL,
            perceptual_hash $text DEFAULT NULL,
            mime_type $text NOT NULL,
            width INT DEFAULT NULL,
            height INT DEFAULT NULL,
            size_bytes INT DEFAULT NULL,
            server_received_at $dt NOT NULL,
            client_reported_at $dt DEFAULT NULL,
            latitude $dec DEFAULT NULL,
            longitude $dec DEFAULT NULL,
            accuracy $decDist DEFAULT NULL,
            distance_meters $decDist DEFAULT NULL,
            geofence_result $text DEFAULT NULL,
            time_window_result $text DEFAULT NULL,
            capture_nonce $text DEFAULT NULL,
            ip $text DEFAULT NULL,
            user_agent $text DEFAULT NULL
        )");

        self::index($pdo, 'CREATE UNIQUE INDEX sm_supply_stock_item ON sm_supply_stock (institution_id, item_id)');
        self::index($pdo, 'CREATE UNIQUE INDEX sm_device_serial ON sm_biometric_devices (serial_number)');
        self::index($pdo, 'CREATE UNIQUE INDEX sm_staff_map ON sm_biometric_staff_ids (institution_id, device_user_id)');
        self::index($pdo, 'CREATE UNIQUE INDEX sm_punches_unique ON sm_biometric_punches (device_id, device_user_id, punched_at)');
        self::index($pdo, 'CREATE UNIQUE INDEX sm_attendance_source ON sm_staff_attendance_sources (staff_id, institution_id, attendance_date)');
        self::index($pdo, 'CREATE UNIQUE INDEX sm_lesson_day ON sm_lesson_verifications (institution_schedule_lesson_detail_id, lesson_date, staff_id)');
        self::index($pdo, 'CREATE UNIQUE INDEX sm_photo_sha ON sm_lesson_verification_photos (file_sha256)');
        self::index($pdo, 'CREATE UNIQUE INDEX sm_photo_phase ON sm_lesson_verification_photos (lesson_verification_id, phase)');
    }

    private static function index(PDO $pdo, string $sql): void
    {
        $driver = $pdo->getAttribute(PDO::ATTR_DRIVER_NAME);
        if ($driver === 'sqlite') {
            $sql = preg_replace('/^CREATE (UNIQUE )?INDEX /', 'CREATE $1INDEX IF NOT EXISTS ', $sql, 1) ?? $sql;
        }
        try {
            $pdo->exec($sql);
        } catch (\PDOException $e) {
            // Index already exists on a second install.
        }
    }
}
