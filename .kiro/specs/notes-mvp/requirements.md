# Requirements Document

## Project Description (Input)

**Who has the problem:** Three concurrent user personas — developers, students, and professionals (no designated tiebreaker persona) — who need a mobile note-taking app.

**Current situation:** Existing note-taking apps force a tradeoff users shouldn't have to make: either they're feature-bloated and slow, or they're simple but become unsearchable once content volume grows, and almost none work reliably offline while staying fast.

**What should change:** Build a mobile-first, offline-first note-taking app (Flutter) with fast local capture (≤3 taps, ≤2s cold start), folder/tag organization, and sub-100ms full-text local search across a 10,000-note corpus — on an architecture (repository pattern over local persistence, UUID note IDs) that can later absorb v1.1 Supabase sync/auth and v2.0 AI-powered semantic search/summarization without a data-layer rewrite.

**Scope for this spec (Phase 1 / MVP only, per docs/prd/phase1.md):**
- Markdown note editing with fenced-code-block syntax highlighting (Dart, JS, Python, Swift, Kotlin)
- Multi-tag support with filtered note list (≤50ms filter updates)
- Fast capture flow: home screen → empty note ready for input in ≤3 taps / ≤2s
- Full-text search (title + body) ranked by relevance, ≤100ms at 10k notes, matched-term highlighting
- 100% of core features (create, edit, delete, search, organize) functional with zero network connectivity, no network-tied loading/error states
- Local-only persistence, with the specific storage engine (Hive vs. Drift/sqflite vs. Isar) reopened as a design-phase decision (see docs/prd/phase1.md, updated 2026-07-25) because of the incremental-write autosave requirement below
- Repository pattern isolating UI/business logic from the persistence engine
- Globally-unique note IDs (UUID, not engine-native auto-increment keys), chosen now specifically to ease the v1.1 Supabase sync migration
- Zero data loss across app crash/force-quit, verified via automated crash-recovery tests

**Explicitly out of scope (Phase 1 non-goals):** collaboration/multi-user sharing, rich/WYSIWYG editing, AI chat or summarization, voice capture, OCR, image generation, cross-device sync (deferred to v1.1 via Supabase), note linking/graph (deferred, accepted tradeoff pending v2.0 AI search relevance).

**Open items flagged in the PRD, not yet decided (do not assume an answer):**
- State management approach — TBD, not yet specified by the user
- Export/backup format and encryption-at-rest — TBD, flagged for a follow-up decision before Phase 1 code-complete
- Local persistence engine (Hive vs. Drift/sqflite vs. Isar) — design-phase decision, reopened due to the autosave requirement

**Reference:** Full source PRD at `docs/prd/phase1.md`.

## Introduction

This spec covers the Phase 1 MVP of Knowledge Hub: an offline-first, mobile note-taking app serving developers, students, and professionals with no designated tiebreaker persona. It defines fast note capture, Markdown editing with code-block highlighting, autosave with save-status visibility, folder/tag organization, full-text search, and a recoverable delete/trash flow — all functioning with zero network dependency. It excludes collaboration, WYSIWYG editing, AI features, and cross-device sync, which are addressed in later phases (v1.1, v2.0).

## Boundary Context

- **In scope**: note capture and editing (title + Markdown body with code-block highlighting); autosave with save-status indication and manual save; single-level folder assignment; multi-tag assignment and AND/OR tag filtering; full-text search across title and body; soft-delete/trash/restore with timed permanent purge; full offline functionality for all of the above.
- **Out of scope**: collaboration/multi-user sharing; rich/WYSIWYG editing (Markdown source view only, no inline styling of headers/emphasis/links); AI chat, summarization, or semantic search; voice capture; OCR; image generation; cross-device sync; note linking/graph between notes; export/backup format and encryption-at-rest (explicitly deferred to a follow-up decision before Phase 1 code-complete); the underlying local persistence engine and state-management library (both design-phase decisions).
- **Adjacent expectations**: v1.1 will add Supabase-backed sync and auth on top of the data this spec creates; this spec does not implement sync but must not make data-model choices that would block it later (owned by design, not by these requirements). v2.0 AI-powered semantic search/summarization is a separate future spec and is not owned by this feature.

## Requirements

### Requirement 1: Fast Note Capture
**Objective:** As any user, I want to start a new empty note within 3 taps and 2 seconds from the app's home screen, so that I never lose context while multitasking.

#### Acceptance Criteria
1. When the user initiates note creation from the home screen, the Knowledge Hub app shall present an empty note ready for text input within 3 taps.
2. When the user initiates note creation from the home screen, the Knowledge Hub app shall present an empty note ready for text input within 2 seconds.
3. The Knowledge Hub app shall reach an interactive state within 2 seconds of a cold start on a mid-tier device class (e.g., Pixel 6a / iPhone 12).

### Requirement 2: Note Editing — Title, Body, and Markdown Source
**Objective:** As a developer, I want to write notes with a distinct title and a Markdown body with highlighted code blocks, so technical content stays organized and readable.

#### Acceptance Criteria
1. The Knowledge Hub app shall provide a note with two distinct editable fields: a title and a body.
2. While the user is editing the body, the Knowledge Hub app shall treat the content as Markdown source text.
3. When the body contains a fenced code block, the Knowledge Hub app shall render that block in a monospace font with syntax highlighting for at least Dart, JavaScript, Python, Swift, and Kotlin.
4. The Knowledge Hub app shall display all Markdown body content outside fenced code blocks as plain, unstyled source text, with no inline rendering of headers, emphasis, or links.

### Requirement 3: Autosave, Save Status, and Manual Save
**Objective:** As any user, I want my note edits saved automatically and to know at a glance whether they're saved, so that a crash or interruption never costs me work.

#### Acceptance Criteria
1. While the user is typing in a note, the Knowledge Hub app shall persist the note content after 300ms of typing inactivity.
2. While the user is typing in a note, the Knowledge Hub app shall persist the note content after every 100 characters typed, if that threshold is reached before the 300ms idle threshold.
3. When the app transitions to a paused, inactive, or detached lifecycle state, the Knowledge Hub app shall immediately persist the current note content.
4. The Knowledge Hub app shall provide an explicit manual save action available at any time while editing a note.
5. While the note content differs from the last persisted version, the Knowledge Hub app shall display a "not saved" status.
6. While a save operation is in progress, the Knowledge Hub app shall display a "saving" status.
7. When a save operation completes successfully, the Knowledge Hub app shall display a "saved" status.
8. The Knowledge Hub app shall lose zero note content across an app crash or force-quit, as verified by automated crash-recovery tests against the persistence triggers in criteria 1–3.

### Requirement 4: Folder Organization
**Objective:** As any user, I want to file a note into a single folder, so that I can browse related notes without sifting through everything.

#### Acceptance Criteria
1. The Knowledge Hub app shall allow a note to be assigned to at most one folder.
2. The Knowledge Hub app shall allow a note to have no folder assignment (unfiled).
3. The Knowledge Hub app shall support only a single level of folders, with no nested sub-folders.
4. When the user selects a folder, the Knowledge Hub app shall display only notes assigned to that folder.

### Requirement 5: Tag Organization and Filtering
**Objective:** As a student, I want to tag notes by subject/course and filter by multiple tags, so I can narrow to just one class before an exam.

#### Acceptance Criteria
1. The Knowledge Hub app shall allow a note to have zero or more tags.
2. When the user selects one or more tags to filter the note list, the Knowledge Hub app shall update the displayed notes within 50ms.
3. The Knowledge Hub app shall provide a toggle between an "any selected tag" (OR) filter mode and an "all selected tags" (AND) filter mode.
4. While the OR filter mode is active, the Knowledge Hub app shall display notes containing at least one of the selected tags.
5. While the AND filter mode is active, the Knowledge Hub app shall display notes containing all of the selected tags.

### Requirement 6: Full-Text Search
**Objective:** As any user, I want to search across all my notes by title and body, so I can retrieve something without remembering which folder it's in.

#### Acceptance Criteria
1. When the user has typed at least 3 characters into the search query box and remained idle for 300ms, the Knowledge Hub app shall return matching notes ranked by relevance.
2. The Knowledge Hub app shall search across both the title and the body of every note.
3. The Knowledge Hub app shall return search results within 100ms across a corpus of 10,000 notes.
4. The Knowledge Hub app shall visually highlight matched search terms within the displayed results.
5. If a search query matches no notes, then the Knowledge Hub app shall display an explicit no-results state.

### Requirement 7: Delete, Trash, and Restore
**Objective:** As any user, I want deleted notes recoverable for a while, so an accidental delete doesn't mean permanent data loss.

#### Acceptance Criteria
1. When the user deletes a note, the Knowledge Hub app shall move that note to Trash rather than permanently deleting it immediately.
2. The Knowledge Hub app shall allow the user to restore a note from Trash back to its prior folder and tag assignments.
3. The Knowledge Hub app shall allow the user to permanently delete a note directly from Trash before its retention window expires.
4. When a note has remained in Trash for 30 days, the Knowledge Hub app shall permanently delete that note.

### Requirement 8: Offline Operation
**Objective:** As any user, I want every feature to work with no internet connection, so a bad signal never blocks my workflow.

#### Acceptance Criteria
1. While the device has zero network connectivity, the Knowledge Hub app shall support creating, editing, deleting, searching, and organizing notes with full functionality.
2. While the device has zero network connectivity, the Knowledge Hub app shall not display any network-dependent loading indicator, error state, or degraded functionality for the core features (create, edit, delete, search, organize).

### Requirement 9: Persona-Neutral Core Flows
**Objective:** As any user regardless of persona, I want the core capture/search/organize flows to behave the same for everyone, so no persona's workflow is disadvantaged by another's needs.

#### Acceptance Criteria
1. The Knowledge Hub app shall provide identical note capture, search, and organization flows regardless of user persona (developer, student, professional).
2. Where a persona-specific affordance is included (e.g., code-block syntax highlighting, course-style tags), the Knowledge Hub app shall provide it as an additive layer on top of the persona-neutral core flow, not as a fork of it.

### Requirement 10: Default Note Ordering
**Objective:** As any user, I want my notes ordered predictably by default, so I can quickly return to what I was recently working on.

#### Acceptance Criteria
1. The Knowledge Hub app shall order the default note list by last-modified timestamp, descending.
