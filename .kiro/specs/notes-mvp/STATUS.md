# Notes MVP — Implementation Status

_Last updated: 2026-09-26, after task 7.4 (`661f960`). All tasks in `tasks.md` are marked complete, but "all tasks done" does not mean "feature complete" — see "What Still Needs To Be Implemented" and "UX Risks" below before treating this as shippable._

## 1. What Has Been Implemented

**Foundation (groups 1–3)**: domain models, SQLite (WAL + FTS5) schema, repositories, and use cases for notes/folders/tags/trash. `packages/app_lifecycle_service`, `packages/sqlite_wal_fts_toolkit`, `packages/markdown_code_block_editor` — all built and integrated. Design-system tokens (`KnowledgeHubColors`/`TextStyles`/`Spacing`/`Radii`/`Elevation`) derived from `design.md`.

**Presentation logic (group 4)**: `NoteEditorBloc` (autosave state machine — 300ms debounce, 100-char threshold, app-lifecycle-triggered save, manual save, all converging on one write path), `SearchBloc`, `NoteListCubit`, `FolderCubit`, `TagCubit`, `TrashCubit`.

**Screens (group 5)**: note editor, note list (with folder/tag filter chips + embedded search UI), folder creation dialog, tag creation dialog, trash screen (restore / permanent delete with confirmation).

**Integration (group 6)**:
- App root (`main.dart`) wires all four app-lifetime Blocs/Cubits; `NoteEditorBloc`/`TrashCubit` are page-scoped at their `Navigator.push` call sites.
- Capture FAB → new note in 1 tap. Folder/tag dialog entry points. Trash navigation entry point. Delete-to-trash action per note row.
- Trash auto-purge (30-day retention) runs once at startup, non-blocking.

**Validation (group 7)**: automated tests proving offline operation (create/edit/delete), zero data loss across all 4 autosave triggers (crash/force-quit simulation), and persona-neutral core behavior (no fork between developer/student affordances and the core save path). Tag-filter performance was measured and **failed** — see §4.

Every task above went through an implementer → independent adversarial reviewer cycle before being marked done; nothing here is self-reported.

## 2. What Still Needs To Be Implemented

These are real, confirmed gaps — not stylistic nitpicks. Each was surfaced to you during the session and deliberately deferred rather than fixed silently, because the affected files are USER-IMPLEMENT territory or because fixing them was out of the scope of the task that found them.

### 2.1 Full-text search does not work at all
`NotesLocalDataSourceImpl.watchSearchResults` (`lib/features/notes/data/datasources/notes_local_data_source_impl.dart:137`) is still:
```dart
Stream<List<NoteSearchResultModel>> watchSearchResults(String query) {
  throw UnimplementedError(...);
}
```
The real FTS5 `bm25()`/`highlight()` query was never written. **This is not a hypothetical — the search bar in the UI is live and will hit this path the moment a user types 3+ characters.** See §3.1 for the exact user-facing effect.

### 2.2 There is no way to organize notes — at all
No file, anywhere in the codebase, can assign a folder or a tag to a note after it's created:
- `NotesRepository` (the domain interface) has no `assignFolder`/`setTags`-style method.
- `NotesDataSource.setNoteTags` exists at the lowest layer but has zero callers above it in production code.
- `CreateNoteUc` always creates a note with `folderId: null` and no tags, permanently.

Folders and tags can be **created** (via their dialogs) and the note list can be **filtered** by them — but nothing can ever put a note *into* a folder or *onto* a tag. See §3.2 for the resulting UX trap.

### 2.3 A note can never be reopened for editing
`NoteEditorBloc`'s only entry event is `NoteEditorStarted`, which unconditionally calls `CreateNoteUc()` — it always creates a brand-new note. There is no event, no use case, and no UI path to load an *existing* note's content back into the editor. Once you navigate away from a note, you cannot get back into it. See §3.3.

### 2.4 Tag-filtering is ~25–30x over its performance budget at scale
`NotesRepositoryImpl.watchNotes` (`lib/features/notes/data/repositories/notes_repository_impl.dart:129`) fetches the active/folder-scoped note list, then does an **N+1 query**: one `getNoteTagIds(noteId)` SQL call per note in that list, for every emission, regardless of whether a tag filter is even active. Measured at a synthetic 10,000-note corpus: **~1.2–1.6 seconds** against a 50ms budget (Requirement 5.2). Fix direction: replace the per-note loop with one bulk query over `note_tags` for the whole result set, built into an in-memory map. See §4 for the exact failing tests.

None of these four are cosmetic. #2.1 and #2.2 mean two of the app's five core pillars (search, organize) are non-functional; #2.3 means the app is effectively "create-once, edit-once" today; #2.4 means the app will visibly stutter or freeze the UI thread on any corpus larger than a few hundred notes.

## 3. Decisions Made That Can Break User Experience — Please Review

These are choices I made while wiring navigation (task 6.2) that are reasonable engineering defaults but have real UX consequences given §2's gaps. None of them are bugs in isolation — they become traps in combination with what's *not* implemented yet.

### 3.1 The search bar looks fully functional but silently hangs forever
`SearchBarWidget` is rendered, enabled, and always visible at the top of the note list. Typing 3+ characters triggers `SearchBloc` to call the (unimplemented) search use case. Because `watchSearchResults` throws synchronously rather than returning a stream that errors, the Bloc's event handler completes with an uncaught exception *before* any state transition happens — so the UI stays stuck in `SearchSearching` (the loading spinner) forever, with an exception logged to the console that the user never sees. **A real user will type into search, see an infinite spinner, and conclude the app is broken or frozen.** Nothing in the UI currently indicates search is unavailable. Until §2.1 is fixed, consider either disabling/hiding the search bar or wiring a visible "search coming soon" state instead of leaving it live.

### 3.2 Folder/tag creation is a dead end that looks like a bug
The folder and tag dialogs work — you can create "Work," "Personal," "CS101," etc. The filter chips for them also work. But because of §2.2, **no note will ever match a real folder or tag filter** — selecting any folder chip other than "All notes," or any tag chip, will always show the plain "No notes yet" empty state, indistinguishable from "you have no notes." A user who creates a folder, expects to file notes into it, and then taps it to check will see an empty list and reasonably conclude either the folder feature is broken or their notes were lost. This is the highest-severity trap in the current build because it *looks like data loss* even though it isn't.

### 3.3 Notes are effectively write-once from the list screen
Combining §2.3 with the current wiring: tapping a note row in `NoteListPage`/`_NoteListView` is a documented no-op (`onTap: () {}`) — there is genuinely nothing to navigate to, since the editor can't load existing content. The **only** working interactive element on a note row today is the delete (trash) icon. A user who creates a note, leaves the editor, and comes back to the list has no way to view or continue editing that note — their only remaining action on it is deleting it. Recommend treating this as a p0 before any real user touches the app; it's a bigger risk than either §3.1 or §3.2 because it affects the single core loop (capture → revisit → edit) rather than a secondary feature.

### 3.4 Delete-to-trash has no confirmation, unlike permanent delete
`TrashPage`'s "delete permanently" action is gated behind a confirmation dialog (it's irreversible). The note-list row's delete-to-trash action (added in task 6.2) is a single tap with **no confirmation** — by design, since moving to trash is reversible (30-day retention + restore). This is a deliberate, documented choice, not an oversight, but it sits directly next to the note's title in the row layout, so a mis-tap is easy. Flagging it here in case the reversibility isn't enough reassurance for your intended users — a lightweight snackbar-with-undo would be a cheap mitigation if you want one.

### 3.5 No visible indicator of what's in Trash
The Trash navigation entry point (an icon in the header row) doesn't show a count or badge. A user has no way to know whether trash is empty or full without opening it. Minor, but worth a deliberate call rather than an accidental omission.

## 4. Test Cases That Currently Fail (and why)

As of commit `661f960`, `flutter test` reports **201 passed, 1 skipped, 2 failed**. Both failures are the same known, real bug (§2.4) — they are supposed to fail until that's fixed; they are not flaky or incorrect tests.

| Test | File | Why it fails |
|---|---|---|
| `filtering by a single tag stays at or under the 50ms latency budget` | `test/features/notes/tag_filter_performance_verification_test.dart` | Measured ~1.2–1.6s vs. the 50ms budget. Root cause: `NotesRepositoryImpl.watchNotes`'s N+1 query pattern (§2.4). |
| `filtering by multiple tags in allOf mode stays at or under the 50ms latency budget` | same file | Same root cause — the N+1 pattern fires regardless of filter mode. |

The 1 skip is **pre-existing and unrelated** to this session's work:

| Test | File | Why it's skipped |
|---|---|---|
| `applies most-recently-modified-first ordering unconditionally` | `test/features/notes/data/repositories/notes_repository_impl_test.dart:96` | A placeholder left from an earlier task ("extend once watchNotes is implemented") — `watchNotes` IS implemented and does sort correctly, but this specific test body was never filled in with a real assertion. Low priority; the sort behavior it describes is otherwise covered indirectly by other passing tests. |

Everything else — 201 tests across use cases, repositories, data sources, Blocs, Cubits, and the widgets that don't require permanent `WidgetTester` coverage (per this project's confirmed testing-strategy policy) — passes.

## 5. Suggested Priority Order

If you're picking this back up, the highest-leverage fixes in order of user-facing severity:
1. **§2.3** (reopen an existing note) — without this, the app has no real core loop.
2. **§2.2** (folder/tag assignment) — without this, two of five advertised organize/tag features are decorative.
3. **§2.1** (search) — a fully decorative search bar that hangs is worse than no search bar; either fix it or hide it until fixed.
4. **§2.4** (N+1 perf) — a real, measured bug, but only bites at real-world note counts, not in early use.
