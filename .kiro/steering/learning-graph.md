# Learning Graph

## Purpose

This project deliberately splits work into topics the user is learning by building themselves, and everything else that may be generated fully. This file is the authoritative split — read it before generating tasks for any spec, before implementing any task, and before reviewing any task's implementation.

## USER-IMPLEMENT (the user writes this themselves — stub + test it, don't implement it)

- **Architecture/design tradeoffs**: draft the design doc, but the user approves or disputes it — push back at least once on their reasoning before agreeing or correcting them.
- **Flutter animations**: tween-based and implicit/explicit `AnimationController` work.
- **Native integrations**: platform channels, Live Activities, home widget (static/dynamic/live-tracking).
- **On-device AI**: embeddings, RAG pipeline, local model inference, offline-first data flow.
- **MCP server implementation**.

## AI-GENERATE (may be implemented fully)

- Boilerplate/UI scaffolding.
- Auth and onboarding flow skeleton.
- Standard error-handling scaffolding.
- Anything not listed under USER-IMPLEMENT above.

## Task Generation Rule

Before finalizing any `/kiro:spec-tasks` output, cross-check every task against this file. Any task whose primary work falls under a USER-IMPLEMENT topic must be marked `[USER-IMPLEMENT]` in `tasks.md`.

For a `[USER-IMPLEMENT]` task, generate only:
- The interface/function signature
- A short design note on the approach
- A failing test

Never silently write the real implementation for a `[USER-IMPLEMENT]` task.

## Notification Rule

Whenever a task in any spec touches a USER-IMPLEMENT topic — at design time, task-generation time, or implementation time — stop and tell the user explicitly:
- What the task is
- Which USER-IMPLEMENT topic it matches and why
- What stub/design note/failing test has been prepared for them to build against

## Code Review Rule

- On any `[USER-IMPLEMENT]` task the user completes: review it, then debate the review decisions with them — push back once if they're right before confirming, correct them with reasoning if they're wrong.
- On AI-generated code: the user reviews it, and the reviewer critiques the user's review the same way — push back once before agreeing or conceding.

---
_This file governs planning and generation scope, not architecture. See `tech.md`/`structure.md` for the Flutter Clean Architecture standard and `design-system.md` for the UI design system._
