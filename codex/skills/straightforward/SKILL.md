---
name: straightforward
description: Write and refactor code in a direct, top-to-bottom style with minimal indirection. Use this whenever the user asks for simple code, straightforward code, no helpers, no wrappers, no abstractions, clear flow, or says they want code that is easy to trace line by line.
---

# Straightforward

Write code that reads from top to bottom without making the reader jump around the file.

## Goal

Prefer the most obvious implementation that works.

The reader should be able to answer these questions quickly:
- What happens first?
- What happens next?
- What is returned?
- What cleanup happens on success or timeout?

## Default approach

When implementing or refactoring:

1. Start in the procedure, handler, or component that the user cares about.
2. Keep the main flow inline when the logic is short or medium length.
3. Use direct variables for important values like topics, ids, payloads, and timeouts.
4. Keep parsing, branching, and cleanup close to where they are used.
5. Return plain objects with explicit fields.

## Avoid by default

Avoid these unless the user explicitly asks for them or the file would become unreasonably repetitive:
- generic helper wrappers
- configuration-driven flow
- factory functions
- layered abstractions
- tiny pass-through functions
- “smart” reusable utilities that hide execution order

## Preferred patterns

Use names that match the job directly:
- `requestTopic`
- `responseTopic`
- `timeout`
- `messageHandler`
- `payload`
- `raw`

Prefer code like this:
- subscribe
- publish
- wait for response
- cleanup
- return result

## When duplication is acceptable

A little duplication is acceptable when it keeps the execution path obvious.

Choose duplication over abstraction when:
- each block is short
- each block is easier to read inline
- the abstraction would force the reader to jump elsewhere

## Error handling

Handle errors near the operation that can fail.

Prefer:
- small `try/catch` blocks
- clear timeout handling
- explicit cleanup with `off`, `unsubscribe`, or equivalent
- direct user-facing error messages

## Output style

When writing code with this skill:
- keep control flow linear
- keep nesting shallow
- keep variable names plain
- keep comments rare and useful
- do not introduce abstractions unless they clearly improve readability more than inline code

## Example mindset

Bad fit:
- “Let me make a reusable action runner, a config map, and three payload helpers.”

Good fit:
- “This procedure needs two topics, one publish, one wait, one timeout, and one return value. Write exactly that.”
