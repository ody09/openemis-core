# Guardian Contacts and Learning Goals Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Require a guardian's primary phone for new school enrollment, expose primary/secondary phones on guardian records, and prepare an editable learning-goal example in the existing competency module.

**Architecture:** A PDO-based contact policy is shared by CakePHP and the Laravel API. A globally registered Model.beforeSave listener guards CakePHP saves, including generic table aliases; an Eloquent event guards API creates and student changes. Existing contact and competency tables remain authoritative, without schema changes.

**Tech Stack:** PHP 8.3, CakePHP 5, Laravel 8, MySQL, PHPUnit 9, in-memory SQLite tests.

**Spec:** docs/superpowers/specs/2026-11-01-school-monitoring-design.md

## Global Constraints

- Use existing guardian/contact and competency records; do not create parallel student or guardian records.
- Secondary phone is optional. Do not impose a country-specific phone length or prefix.
- Existing enrollment records stay editable; new enrollments require a linked guardian with a valid preferred mobile/phone contact.
- Draft student/admission profiles remain possible so staff can add the guardian before enrolling.
- Photos and fingerprint integration remain the subsequent slice identified in the approved design.
- Reuse the authorized checkout and preserve its existing changes. Leave changes uncommitted because repository metadata is read-only in this environment.

## Review Focus

- Preferred email/fax/blank/non-phone data cannot satisfy the primary phone requirement.
- A sibling's guardian is not evidence for an unrelated student's enrollment.
- Failed immediate enrollment must return an error before saving a partial user record.
- Existing enrollment updates remain possible; repointing one to another student must recheck the requirement.
- Re-running example setup must not duplicate or overwrite a reviewed curriculum; unknown grade/period must leave no changes.

### Task 1: Guardian contacts and enrollment enforcement

**Files:**
- Create: src/SchoolMonitoring/GuardianContactPolicy.php
- Create: src/Model/Behavior/RequireGuardianContactBehavior.php
- Create: config/school_monitoring.php, src/SchoolMonitoring/EnrollmentRequest.php
- Modify: config/bootstrap.php
- Modify: plugins/Student/src/Model/Table/GuardiansTable.php
- Modify: plugins/Institution/src/Controller/InstitutionsController.php
- Modify: api/app/Models/Api5/InstitutionStudents.php, api/app/Http/Controllers/BaseApi/CrudApiController.php
- Modify: plugins/Institution/webroot/js/angular/students/institutions.students.ctrl.js, plugins/Institution/templates/Institutions/student_add.php
- Test: tests/SchoolMonitoring/*.php, tests/SchoolMonitoring/student-admission.test.cjs, tests/SchoolMonitoringApi/ApiEnrollmentGuardianTest.php

**Interfaces:** `GuardianContactPolicy(PDO $pdo)`, `hasPrimaryPhone(int $studentId): bool`, `phones(int $guardianId): array` returning `primary` and `secondary`; a shared error-message constant. Uses actual `student_guardians.student_id/guardian_id`, `user_contacts.preferred`, and contact option codes `MOB`/`PHO`.

- [x] Write and run policy tests against real SQLite rows: no guardian, email/fax only, blank/bad phone, secondary only, valid primary, sibling reuse, unrelated student, primary/secondary ordering.
- [x] Implement the policy and get tests green.
- [x] Write and run Cake save tests: missing contact rejects create even without marshalling validation, valid contact saves, legacy updates save, repointing rejects.
- [x] Register the shared behavior globally only for `institution_students`; add API event guard and preflight immediate enrollment with validated workflow status.
- [x] Display Arabic-labeled primary/secondary phones on the existing guardian overview/list. Numbers are maintained through the existing guardian Contacts tab.
- [x] Run targeted tests, PHP lint, and the existing test command; record pre-existing suite incompatibilities separately.

### Task 2: Editable learning-goal example and handoff

**Files:**
- Create: src/SchoolMonitoring/LearningGoalExample.php
- Create: src/Command/SchoolLearningGoalExampleCommand.php
- Test: tests/SchoolMonitoring/LearningGoalExampleTest.php
- Create: docs/school-monitoring-pilot.md

**Interfaces:** `LearningGoalExample(Connection $connection)::create(int $periodId, int $gradeId, int $userId): int`; command `school:learning-goal-example --period ID --grade ID --user ID` explicitly selects the target. Idempotent sample code `DEMO-WRITE-NAME` in the existing competency tables.

- [x] Write and run database tests for sample creation, repeat setup, invalid targets, linkage of criteria/period/item, and missing assessment remaining absent.
- [x] Implement transactional setup using existing tables and three grade options: not mastered, with help, independently. No result is inserted for an unassessed student.
- [x] Verify target grade belongs to selected academic period; create the example in the local configured kindergarten grade without student data. New demo entry window is 30 days, independent of historical teaching dates.
- [x] Document the UI paths for guardian contacts, pending admission, and competency entry, the demo's target period/grade, and the photo/device details still pending.
- [x] Run the full targeted suite and independent code review; fix material findings and report exact verification limits.
