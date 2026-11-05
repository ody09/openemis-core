# Domain docs

## Layout

This is a single-context project. Domain vocabulary belongs in root `GLOSSARY.md`; architecture decisions belong in `docs/adr/`.

## Before exploring

- Read root `GLOSSARY.md` when present.
- Read ADRs in `docs/adr/` relevant to the area being changed.
- If a root `GLOSSARY-MAP.md` is introduced later, follow it to the relevant context glossaries and decisions.
- If glossary or ADR files do not exist, proceed silently. Do not require placeholder documents or suggest creating them upfront. Domain-modeling workflows create them when terms or decisions are actually resolved.
- Existing pilot context lives in `docs/school-monitoring-pilot.md`, `docs/lesson-photo-demo.md`, and relevant documents under `docs/superpowers/`. Consult these when working on school-monitoring features; distinguish prototype limitations from implemented production behavior.

## Vocabulary

Use glossary terms consistently in issue titles, hypotheses, tests, and implementation proposals. If a term is missing, check existing project language before inventing a synonym.

## Decisions

If a proposal conflicts with an existing ADR, identify the ADR and explain the proposed change explicitly rather than overriding it silently.
