---
name: spec-creator
description: Create structured project specs in .specs/ for new features, implementation plans, roadmap slices, or course-driven work. Use this whenever the user asks to create a spec, plan a feature into spec files, define requirements, validate an implementation approach, or prepare work before coding. This skill should create files directly when asked, not just describe the spec.
---

# Spec Creator

Create implementation-ready specs that follow the RunlyAI project constitution.

Each spec lives in a date-stamped folder under `.specs/` and contains exactly three files:

```txt
.specs/yyyy-month-day-spec-name/
  plan.md
  requirements.md
  validation.md
```

Use lowercase kebab-case for the spec name. Use the current local date automatically unless the user explicitly asks for another date.

## Required Context

Before creating a spec, read the project constitution:

- `.specs/mission.md`
- `.specs/tech-stack.md`
- `.specs/roadmap.md`

Use these files to keep the spec aligned with the product mission, approved stack, roadmap phase, implementation gates, and validation expectations.

If one of these files is missing, continue with available context but note the gap in the generated spec.

## Creation Workflow

1. Infer the feature name from the user's request.
2. Normalize the folder suffix to lowercase kebab-case.
3. Use the current local date in `yyyy-month-day` format, for example `2026-may-19`.
4. Create the folder under `.specs/`.
5. If the folder already exists, do not overwrite it.
   - Prefer creating the next available suffix, for example `2026-may-19-login-flow-2`.
   - If the user clearly asked to update the existing spec, edit the existing files instead.
6. Create `plan.md`, `requirements.md`, and `validation.md` directly.
7. Keep assumptions explicit.
8. Include an implementation gate that prevents coding until all three spec files are complete enough to guide implementation.

## File Responsibilities

### `plan.md`

Describe what needs to be done and how to implement it.

Include:

- feature goal
- roadmap alignment
- implementation gate
- task list
- implementation approach
- affected files or modules
- sequencing
- risks and decisions
- out-of-scope work

Use `references/plan-template.md` as the structure.

### `requirements.md`

Describe what the implementation needs.

Include:

- functional requirements
- non-functional requirements
- tools and libraries
- data/config requirements
- security and privacy constraints
- agent/course guardrails
- assumptions and open questions

Use `references/requirements-template.md` as the structure.

### `validation.md`

Describe how the implementation will be proven correct.

Choose validation based on the feature:

- CLI flows: command-level checks, mocked API checks, config-file checks
- API/backend behavior: unit tests, integration tests, contract checks, curl checks
- agent workflow: rubric tests, fixture specs, implementation gate checks
- user-facing flows: scenario checks and regression tests

Prefer tests when practical. Recommend TDD when the behavior can be specified before implementation. Use curl only when there is an HTTP surface to verify.

Use `references/validation-template.md` as the structure.

## Question Policy

Draft from available context. Ask only when a missing detail would materially change the spec.

If asking is necessary, ask one focused question and include a recommended answer.

Do not ask questions that can be answered by reading the constitution, README, package files, or nearby source.

## Quality Bar

A generated spec is ready when:

- it has a clear feature goal
- it is aligned to the roadmap
- it names the relevant stack and constraints
- it includes concrete implementation tasks
- it identifies files/modules likely to change
- it defines how implementation will be validated
- it blocks coding until plan, requirements, and validation are complete
- it avoids uploading source, secrets, or `.env` files unless a future explicit consent flow exists

## Output Summary

After creating a spec, summarize:

- created folder path
- three files created or updated
- key assumptions
- validation method chosen

Keep the summary short.
