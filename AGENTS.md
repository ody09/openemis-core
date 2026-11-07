# Project instructions

## Agent skills

### Issue tracker

Track issues and specs in GitHub Issues at `ody09/openemis-core`. See `docs/agents/issue-tracker.md`.

### Triage labels

Use the five default triage state labels. See `docs/agents/triage-labels.md`.

### Domain docs

Use a single-context layout: root `GLOSSARY.md` and `docs/adr/`. See `docs/agents/domain.md`.

## Local status for the next agent

Read `docs/school-monitoring-pilot.md` section «حالة 7 نوفمبر 2026» before changing school monitoring, lesson photos, biometric attendance, competencies, Yemen areas, or the local demo data. `docs/lesson-photo-demo.md` is the old browser-only mock, not the running feature.

Do not commit unless Mohamed asks. Keep the lesson geofence at 150m, photo accuracy at 100m, and the time window at −10/+15 minutes. `start-emis.cmd` starts PHP only; MySQL is separate. Invoke PHP with `-d extension_dir` pointing at `.local\php-8.3\ext`. Admin login is in `.local\login.txt`; do not copy that password into docs or chat.
