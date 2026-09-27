# PRD: Knowledge Hub (Phase 1 — MVP)

## 1. Executive Summary

**Problem Statement**
Existing note-taking apps force a tradeoff users shouldn't have to make: either they're feature-bloated and slow, or they're simple but become unsearchable once content volume grows, and almost none work reliably offline while staying fast.

**Proposed Solution**
A mobile-first, offline-first note-taking app with fast local capture, folder/tag organization, and sub-100ms local search — built on an architecture that can later absorb AI-powered search and summarization without a data-layer rewrite.

**Success Criteria**
- Note creation completes in ≤3 taps from app launch.
- Cold start to interactive ≤2 seconds on a mid-tier device (e.g., Pixel 6a / iPhone 12 class).
- Full-text search returns results in ≤100ms across a 10,000-note corpus.
- 100% of core features (create, edit, delete, search, organize) function with zero network connectivity.
- Zero data loss across app crash/force-quit, verified via automated crash-recovery tests.

---

## 2. User Experience & Functionality

**User Personas**
Phase 1 targets three personas simultaneously — developers, students, and professionals — with **no designated tiebreaker persona**. This is a deliberate scope decision made against the recommendation to pick one; see [Risks](#5-risks--roadmap) for the mitigation strategy this requires.

| Persona | Primary need |
|---|---|
| Developer | Markdown + code-block rendering, keyboard-first capture |
| Student | Tag/subject-based filtering, fast capture during lectures |
| Professional | Quick meeting-note capture, chronological retrieval |

**User Stories**

- As a developer, I want to write notes in Markdown with syntax-highlighted code blocks, so technical content stays readable.
- As a student, I want to tag notes by subject/course, so I can filter to just one class before an exam.
- As a professional, I want to create a timestamped note in under 3 taps, so I don't lose meeting context while multitasking.
- As any user, I want full-text search across all my notes, so I can retrieve something without remembering which folder it's in.
- As any user, I want every feature to work with no internet connection, so a bad signal never blocks my workflow.

**Acceptance Criteria**

- *Markdown + code blocks*: Fenced code blocks (\`\`\`) render with monospace font and syntax highlighting for at least 5 common languages (Dart, JS, Python, Swift, Kotlin).
- *Tagging*: A note supports multiple tags; the note list can be filtered by one or more tags with results updating in ≤50ms.
- *Fast capture*: From home screen tap → empty note ready for text input in ≤3 taps and ≤2 seconds.
- *Search*: Query box returns matching notes (title + body) ranked by relevance, ≤100ms at 10k notes, with matched terms highlighted.
- *Offline*: Airplane mode enabled → all above criteria still pass with no error states, loading spinners tied to network, or degraded functionality.

**Non-Goals (Phase 1)**
- Collaboration or multi-user sharing
- Rich/WYSIWYG document editing (Markdown source only)
- AI chat or summarization
- Voice assistant / voice capture
- OCR
- Image generation
- Cross-device sync (single-device only — see Risks)

---

## 3. AI System Requirements

Not applicable to Phase 1 — no AI features ship in this phase by design (see Non-Goals). Reserved for Phase 2, where semantic/embedding-based search and on-device summarization are planned; those requirements will be scoped in a separate PRD once Phase 1 ships, so this phase's data model isn't designed against speculative AI requirements.

---

## 4. Technical Specifications

**Architecture Overview**
- Flutter client, fully offline in Phase 1 — no backend service.
- Local persistence: **reopened during `notes-mvp` requirements (2026-07-25)** — Hive was the prior default, but the autosave requirement (debounced/char-count-triggered incremental writes, save-status tracking) favors an engine with cheap incremental writes over Hive's box-level rewrite model. Candidates to evaluate at design time: **Drift/sqflite (WAL mode)** or **Isar**. Final choice, and whether to use an actively-maintained Hive fork (e.g., `hive_ce`) as a fallback, is a design-phase decision — not re-litigated here.
- Repository pattern between UI and the local persistence engine, so the engine can be swapped later without touching UI/business-logic layers — this is the seam that protects Phase 2 (sync, AI) from requiring a rewrite.
- State management: **TBD** — not yet specified by the user; do not assume Provider/Riverpod/Bloc until confirmed.

**Integration Points**
- None in Phase 1. No external APIs, no auth, no cloud services. All data lives in a local persistence store on-device (see Architecture Overview for the engine decision).
- **Supabase is confirmed (not TBD) as the v1.1 integration point** for sync and auth — not built in Phase 1, but the repository-pattern seam above exists specifically so this swap doesn't require a UI rewrite.

**Security & Privacy**
- All data stored locally only; no telemetry or analytics transmitted by default.
- No account/auth system in Phase 1 (nothing to authenticate against, single local store). This is temporary by design: v1.1 introduces Supabase Auth for sync, so the Phase 1 note schema should avoid decisions that would make a later migration to per-user rows painful (see Technical Risks).
- Export/backup format and encryption-at-rest are **TBD** — not specified yet; flagged for a follow-up decision before Phase 1 code-complete, since "single-device only" (a non-goal exception) makes local backup the only loss-mitigation available.

---

## 5. Risks & Roadmap

**Phased Rollout**
- **MVP (Phase 1)**: Flat notes (folders + tags, no linking/graph), full-text search, offline-first, Hive persistence.
- **v1.1**: Local backup/export; cross-device sync via **Supabase** (Postgres + Auth), replacing the Phase 1 single-device limitation.
- **v2.0**: AI layer — embedding-based semantic search, on-device summarization, chat-with-notes (per the project's original "Future" goals).

**Technical Risks**

| Risk | Detail | Mitigation |
|---|---|---|
| No persona tiebreaker | Developer/student/professional needs can conflict on UX decisions (e.g., keyboard-shortcut-first vs. tap-first flows) with no rule for resolving ties | Build core flows (capture, search, organize) persona-agnostic; treat persona-specific affordances (syntax highlighting, course tags) as additive layers, not core-flow forks |
| Full-text search on Hive | Hive is a key-value store, not built for FTS; naive scans may not hit the 100ms/10k-note target as corpus grows | Benchmark early with synthetic 10k-note dataset; if scan-based search doesn't meet target, evaluate a lightweight in-app inverted index over Hive rather than switching persistence engines |
| Local persistence engine choice | Hive's box-level rewrite model doesn't fit well with the fine-grained (debounce/char-count-triggered) autosave requirement now specified; ecosystem maintenance activity for upstream Hive has also shifted | Evaluate Drift/sqflite (WAL mode) or Isar for cheap incremental writes at design time; if Hive is still chosen, confirm an actively maintained fork (e.g., `hive_ce`) first. Document the final dependency choice in the repo |
| Single-device only, no sync | Non-goal explicitly accepted for Phase 1 | Local backup/export in v1.1 is the interim data-loss mitigation; communicate this limitation to users in-app |
| Flat data model (no linking) | Deferred in favor of AI-assisted retrieval later; if Phase 2 AI search underdelivers, users have no manual fallback for connecting notes | Accepted tradeoff — revisit if Phase 2 semantic search doesn't meet a to-be-defined relevance bar |
| Hive → Supabase migration (v1.1) | Phase 1 note IDs/schema are chosen with no sync target in mind; retrofitting per-user ownership and conflict resolution onto an existing local dataset is harder than designing for it upfront | Use globally-unique note IDs (UUID, not Hive auto-increment keys) from Phase 1 onward, even though sync doesn't exist yet — this is the one Phase 1 schema decision worth making for a v1.1 feature |