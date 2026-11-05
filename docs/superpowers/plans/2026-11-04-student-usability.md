# Student registration usability

> Implement inline in this session. The user explicitly delegated design details and execution after choosing improvements to the existing flow. Track progress in claude-mem list `usability-improvements`.

**Goal:** A first-time Arabic-speaking user understands how to add a student, what each step needs, and what remains after saving.

**Architecture:** Keep the existing CakePHP/AngularJS wizard, permissions, validation and APIs. Add contextual guidance and reuse one PHP actions element above and below the form. Replace timer/localStorage polling with the validation request's actual promise.

**Tech stack:** Existing PHP views, AngularJS, Node's built-in test runner; no new dependencies or database changes.

**Spec:** User request and clarification: requirements and the next action are the main obstacle. Improve the existing flow and take responsibility for implementation details.

## Scope and constraints

- Preserve existing uncommitted work, including guardian-contact enforcement and admission fixes.
- Student list: explain where adding begins and how pending admission differs from enrollment.
- Wizard: explain search versus new student, the current step, required fields, save status, and the next action. Put actions at both ends of long forms.
- Guardian screen: explain relationship and primary phone requirements, and how to return to pending admissions after saving.
- Confirmation and transfer: wait for actual validation, prevent duplicate submissions, show failures and permit retry; never save on an unknown validation result.
- No changes to permissions, school policies, database records, or unrelated screens.

## Implementation and validation

1. Add controller regression tests for unresolved, allowed, rejected, malformed and failed validation; double-clicks; missing grade; transfer; and the saved pending status. Observe failures before implementation.
2. Implement promise-based validation shared by confirmation and transfer. Remove localStorage handoff from the two validation service functions after checking all callers.
3. Add student guidance and shared actions. Add narrowly scoped student-list guidance to the existing Panel layout and guardian instructions to its existing view.
4. Run all `tests/SchoolMonitoring/*.test.cjs`, syntax checks on modified PHP/JS, and review the diff against the initial snapshots. Render and inspect the guidance and actions in a browser if possible.

## Review focus

- Slow validation must never silently stop after a fixed delay.
- Duplicate clicks must not create multiple validation or save requests.
- A missing grade, unknown response, or validation failure must not save.
- Pending admission and pending enrollment must follow the server outcome, not imply completed enrollment.
- Existing-student, external-search and transfer branches keep their existing checks and actions.

## Known pre-existing limitation

The new-student education-grade repeater endpoint currently returns `"no"` before its legacy checks. This change preserves that server behavior; it does not claim to repair the underlying repeater policy. The transfer endpoint retains its existing checks.

## Verification record

- Confirmation regression tests failed against the original timer-based implementation, then passed with promise-based validation.
- All 28 SchoolMonitoring Node tests and PHP/JS syntax checks pass. Directory controller lint reports its pre-existing optional-parameter deprecation.
- Full PHPUnit cannot start: PHP 8.4 hits an existing Chronos signature incompatibility; the bundled PHP 8.3 gets further but stops on the existing `AppTestCase::setUp()` signature incompatibility.
- Actual PHP view fragments render into `tmp/student-usability-preview.html` with synthetic data and no database access. Browser inspection was interrupted by workspace credit exhaustion; a resumed attempt hit the automatic approval deadline. Live visual inspection is not claimed complete.
- Independent review completed after resuming and found missing institution context in the guardian handoff. Fixed both guardian navigation URLs and the Directory action's view variables. Both route-context regression tests were observed RED then GREEN; full suite 28/28. No other actionable regression found by the reviewer.
- Self-review corrected pending-enrollment success copy so it no longer reports a pending admission, and explained missing add permission on the student list.
- Existing checkout reused to preserve the user's overlapping uncommitted changes. No commit, push, migration, or database write performed.
