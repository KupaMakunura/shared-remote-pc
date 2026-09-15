---
name: clean-code
description: Write and refactor code in a straight-forward, step-by-step style with explicit flow, clear naming, and predictable file/function/variable ordering. Proactively use this whenever the user asks to simplify code, clean up code, make code easier to follow, reduce complexity, improve readability, speed up shipping safely, or says things like "keep it simple", "this is confusing", "make it clean", "straight-forward only", "easier to trace", or "human readable". Also use it when refactoring backend workers, jobs, handlers, services, or utility-heavy modules that have become hard to reason about, even if the user does not explicitly mention "clean code".
user-invokable: true
args:
  - name: target
    description: File, module, or feature to clean up (optional)
    required: false
---

Write code that is easy to scan, easy to reason about, and easy to modify.

## Core Principle

Prefer explicit, traceable steps over clever abstractions.

If two options work, choose the one that makes execution order obvious from top to bottom.

## Required Workflow

When implementing or refactoring, follow this exact sequence:

1. **Clarify intent**
   - State what the code does in one short sentence.
   - Identify inputs, outputs, and side effects.

2. **Shape the flow first**
   - Build a clear top-level orchestration function.
   - Keep control flow linear and readable.
   - Prefer small helper functions with single purpose.

3. **Name things for humans first**
   - Use names that explain role, not implementation detail.
   - Avoid abbreviations unless they are domain-standard.
   - Use consistent terms across files and layers.

4. **Order code predictably**
   - Imports
   - Constants/types
   - Small pure helpers
   - Main operation helpers
   - Public/exported orchestration function(s)

5. **Make data shape explicit**
   - Define types/interfaces for important payloads.
   - Normalize data once, then pass normalized data forward.
   - Avoid hidden shape changes across steps.

6. **Finish with readability checks**
   - Remove unnecessary indirection.
   - Inline overly abstract helpers when they reduce clarity.
   - Keep comments only where intent is non-obvious.

## Naming Rules

Use these naming patterns consistently.

### Files
- Use file names that describe the job directly.
- Prefer `check-<domain>.ts` for scheduled/event job entrypoints.
- Prefer `<domain>-service.ts` or `<domain>-planner.ts` for domain logic modules.
- Avoid vague names like `utils.ts`, `helpers2.ts`, `misc.ts`.

### Functions
- Use **verb + object** names.
- Good: `loadSingleTerminalTarget`, `recordDownloadOutcome`, `resolveEventDescriptor`
- Bad: `doStuff`, `processData`, `handleThing`

- Use clear prefixes by role:
  - `load*` for reads/fetches
  - `build*` for deterministic construction
  - `parse*` for format conversion
  - `record*` or `persist*` for writes
  - `start*` for lifecycle/bootstrap
  - `check*` for job entrypoints

### Variables
- Name for meaning, not type.
- Good: `heartbeatResponse`, `downloadRequestId`, `normalizedPayload`
- Bad: `data`, `obj`, `tmp`, `x`

- Allowed short names only for common loop indexes (`i`, `idx`) or obvious locals in very short scopes.

## Structure Rules

- Keep each function focused on one responsibility.
- Keep nesting shallow (prefer guard clauses and early returns).
- Keep orchestration functions readable as "step lists".
- Prefer explicit topic strings at usage sites when domain traceability matters.
- Avoid "magic behavior" hidden behind generic helper layers.

## Comment Rules

- Add comments only for intent, constraints, or non-obvious domain decisions.
- Do not comment obvious operations.
- Prefer short comments above a block, not noisy inline comments everywhere.

## Human + LLM Readability Standards

Code should be understandable by:
- a new teammate opening the file for the first time,
- and an agent/LLM reading only this file without broad project context.

To satisfy this:
- keep naming consistent with domain vocabulary,
- avoid ambiguous aliases,
- keep data transformations explicit and local,
- and preserve top-to-bottom causal flow.

## Refactor Heuristics

When cleaning existing code:
- Split large functions into steps only when each step has a clear name.
- Merge tiny pass-through helpers that add no clarity.
- Replace generic wrappers with direct code if direct code is easier to trace.
- Prefer one obvious path through the logic.

## Done Criteria

The code is "clean-code complete" when:
- A reader can explain the execution flow after one pass.
- Function/file names predict behavior accurately.
- No helper exists without clear readability value.
- Main path is explicit and ordered.
- Inputs and outputs are clear at each step.
