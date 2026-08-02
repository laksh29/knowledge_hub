# Research & Design Decisions — notes-mvp

## Summary
- **Feature**: `notes-mvp`
- **Discovery Scope**: New Feature (greenfield — only the default `flutter create` scaffold exists; no prior codebase patterns to extend)
- **Key Findings**:
  - Drift (on `package:sqlite3`, WAL mode) is the correct persistence choice, replacing Hive: native row-level incremental writes, built-in FTS5 (ranking + highlighting), no maintenance risk. Isar is disqualified (upstream archived Mar 2026, only a bug-fix-only community fork remains).
  - SQLite FTS5 comfortably meets the ≤100ms/10k-note search target — real-world benchmarks at ~4,380 rows show 5–20ms query latency, an order of magnitude under budget.
  - No markdown-rendering package is needed: requirements call for source-only editing (§2.4) with highlighting scoped to fenced code blocks only, which is a `TextEditingController` + `RegExp` + a code-highlighting engine (`flutter_code_editor` or `flutter_highlighting`), not a markdown renderer.
  - Per explicit user direction (2026-07-25), the SQLite WAL+FTS5 setup, the Markdown code-block editor, and the app-lifecycle service are built as three standalone `packages/*` local packages with zero dependency on `knowledge_hub` types, and `flutter-clean-architecture-guide.md` was updated directly (§3.1 reuse convention, §4.4 stream use cases, §11 resolved item) rather than deferred as a follow-up.

## Research Log

### Local persistence engine (Hive replacement)
- **Context**: PRD (updated 2026-07-25) reopened the Hive decision because Requirement 3 (autosave: 300ms idle / 100-char threshold, whichever first, plus lifecycle-triggered saves) needs cheap incremental writes, which conflicts with Hive's box-level rewrite model.
- **Sources Consulted**: pub.dev listings for `drift`, `isar`, `isar_community`, `objectbox`, `sqflite`; Drift changelog and GitHub issue simolus3/drift#3702; Drift docs (drift.simonbinder.eu/sql_api/extensions/).
- **Findings**:
  - Drift v2.34.2 — actively maintained (1.04M downloads, 160 pub points). Row-based writes fit the debounce pattern directly. FTS5 virtual tables supported natively (`sqlite_module: fts5` build option), including `bm25()`/`highlight()`/`snippet()` SQL functions for ranking and highlighting with no extra library.
  - `sqlite3_flutter_libs` is now a no-op as of v0.6.0 — current setups use `package:sqlite3` directly (via the `drift_flutter` helper), enabling WAL mode via a PRAGMA, stable on iOS and Android (WAL is engine-level, not platform-specific).
  - Isar: upstream repo archived Mar 2026; only `isar_community` (bug-fix-only fork) remains. Community consensus treats it as legacy-to-migrate-off, not a base for new apps.
  - ObjectBox: actively maintained, cheap writes, but no relevance-ranked full-text search (only vector/similarity search) — disqualifying given Requirement 6.
  - No documented conflict between `drift_dev` codegen and the existing `freezed`/`get_it`/`injectable` build_runner pipeline (multi-generator setups are standard practice).
- **Implications**: Adopt Drift + `sqlite3` (WAL mode) as this feature's persistence engine. `flutter-clean-architecture-guide.md` §11 open item #1 was updated directly to reflect this (see Design Decisions below).

### Full-text search feasibility at 10k-note scale
- **Context**: Requirement 6.3 requires ≤100ms search latency across a 10,000-note corpus.
- **Sources Consulted**: SQLite FTS5 docs (sqlite.org/fts5.html); a mobile benchmark (Galaxy Tab S 10.5 / Pixel 8 Pro, ~4,380 rows); GitHub phiresky/sql.js-httpvfs#10.
- **Findings**: Query latency measured at 5–20ms for ~4,380 rows — matching in-memory search speed, roughly 2–3x smaller than our 10k target but the same order of magnitude, well inside the 100ms budget. Cold index build for that corpus took 1.2–2s (one-time, not per-query). A severe `ORDER BY rank` slowdown was observed only in a network-backed virtual filesystem at 6M rows — not applicable to local on-device SQLite. FTS5 storage overhead varies by `detail` mode (~45% of source text at full detail, ~8% at `detail=none`).
- **Implications**: Use an external-content FTS5 table (avoids duplicating title/body storage), tune `detail` mode if memory becomes a concern, and re-benchmark if the corpus grows well past 10k notes (flagged as a Risk below).

### Markdown source editing + code-block highlighting
- **Context**: Requirement 2 needs plain-source Markdown editing (no WYSIWYG/rendering per the non-goal) with monospace + syntax-highlighted fenced code blocks for 5 languages.
- **Sources Consulted**: pub.dev listings for `flutter_markdown` (discontinued, flutter/flutter#162966), `flutter_markdown_plus`, `flutter_highlight`/`highlight`, `flutter_highlighting`, `flutter_code_editor`, `re_editor`.
- **Findings**: `flutter_markdown` is discontinued by the Flutter team — moot here since full rendering isn't needed. Fenced-code-block detection via a custom `TextEditingController` overriding `buildTextSpan` with `RegExp` is a standard, dependency-free technique for the detection layer. `flutter_code_editor` (published 10 months prior, actively maintained, built on the `highlight` engine) confirms coverage for Dart/JavaScript/Python/Swift/Kotlin and is the freshest actively-developed package in this space.
- **Implications**: No markdown-rendering dependency. Build a custom `TextEditingController` for fenced-code-block detection; delegate per-language tokenization to `flutter_code_editor`'s highlighting logic (or a thin wrapper directly around `highlight` if the full editor-widget chrome is unwanted).

## Architecture Pattern Evaluation

| Option | Description | Strengths | Risks / Limitations | Notes |
|--------|-------------|-----------|---------------------|-------|
| Drift + sqlite3 (WAL) | Relational, row-based local DB with FTS5 | Native incremental writes, built-in ranked/highlighted search, actively maintained, freezed/injectable-compatible | FTS5 schema/queries written in raw `.drift` SQL, not pure Dart | **Selected** |
| Isar / isar_community | NoSQL object store with word-index FTS | Simple object API | Upstream archived; fork is bug-fix-only | Rejected — maintenance risk mirrors the original Hive concern |
| ObjectBox | NoSQL object store, commercially backed | Fast writes, built-in sync engine | No relevance-ranked full-text search (vector search only) | Rejected — fails Requirement 6 |
| Raw `sqflite` | Direct SQLite wrapper, no ORM | Full manual control | No codegen/type-safety ergonomics Drift provides for free | Rejected — reinvents what Drift generates |

## Design Decisions

### Decision: Local persistence engine — Drift over Hive/Isar/ObjectBox/sqflite
- **Context**: Requirement 3's fine-grained autosave and Requirement 6's ranked full-text search together rule out Hive (box-rewrite model, no native FTS) and narrow the field significantly.
- **Alternatives Considered**: Isar/isar_community, ObjectBox, raw sqflite (see table above).
- **Selected Approach**: Drift on `package:sqlite3` with WAL mode enabled via the `drift_flutter` setup helper.
- **Rationale**: Only candidate satisfying cheap incremental writes, native ranked/highlighted FTS5, and no maintenance risk, while composing cleanly with the project's existing freezed/get_it/injectable codegen stack.
- **Trade-offs**: FTS5 schema and query definitions live in raw `.drift` SQL rather than pure Dart — an accepted, contained exception since it's confined to the data layer's schema file, not leaking into `domain`.
- **Follow-up**: Re-benchmark `ORDER BY rank` behavior if the note corpus grows well past 10,000 rows (see Risks).

### Decision: No markdown-rendering package — source-only editor + isolated code-block highlighting
- **Context**: Requirement 2.4 explicitly requires plain, unstyled source text outside fenced code blocks (a non-goal excludes WYSIWYG rendering).
- **Alternatives Considered**: `flutter_markdown_plus` (full rendering, rejected as unnecessary scope), hand-rolled full markdown parser (rejected as reinventing a solved problem for a narrower need).
- **Selected Approach**: Custom `TextEditingController` + `RegExp`-based fenced-code-block detection, with `flutter_code_editor` (or a thin `highlight` wrapper) supplying per-language tokenization/coloring only within detected code-block ranges.
- **Rationale**: Matches the actual requirement (plain source + code-block-only highlighting) without adopting a full rendering engine we'd have to actively suppress.
- **Trade-offs**: Slightly more custom glue code (the controller override) versus a batteries-included renderer, but avoids fighting a renderer's default behavior to keep everything else as plain text.

### Decision: Generalize note listing, tag filtering, and trash listing into one reactive use case
- **Context**: Requirement 4.4 (folder filter), 5.2/5.4/5.5 (tag AND/OR filter), 7.2/7.3 (trash listing), and 10.1 (default sort) are all variations of "watch notes matching a filter, live."
- **Selected Approach**: A single `WatchFilteredNotesUc` taking a `NoteListFilterParams` value object (`folderId`, `tagIds`, `tagFilterMode`, `lifecycleScope`), returning a `Stream<Result<Failure, List<Note>>>`. Trash is `lifecycleScope: trash`; the default note list is `lifecycleScope: active` with no folder/tag filter.
- **Rationale**: Generalization lens — these are one capability with different filter inputs, not four separate use cases. Default sort (last-modified desc) is applied unconditionally inside the repository so every caller gets it for free.
- **Trade-offs**: None significant — the params object stays a plain, explicit, typed class, not a grab-bag `Map`.

### Decision: New shared architecture primitive — `StreamUseCase<S, P>` / `StreamUseCaseNoParams<S>` in `core/usecase/`
- **Context**: `flutter-clean-architecture-guide.md` §4.4 previously defined only Future-based (sync/async × params/no-params) use case base classes. This feature's live-updating requirements (search results, filtered note list, folder/tag lists — Requirements 5.2, 6.1, and the reactive UI needed to hit the 50ms/100ms budgets) are architecturally a poor fit for one-shot `Future` calls repeatedly re-invoked on every keystroke.
- **Alternatives Considered**: Polling via repeated `Future`-based use case calls on a manual timer (rejected — reinvents what Drift's native `.watch()` reactive streams already provide, and risks missing the latency budgets under manual re-polling overhead).
- **Selected Approach**: Add `StreamUseCase<S, P>` and `StreamUseCaseNoParams<S>` alongside the four existing base classes in `core/usecase/usecase.dart`, both returning `Stream<Result<Failure, S>>`. Because this pattern depends on this app's own `Result`/`Failure` types, it stays a `core/` addition — not a candidate for the standalone-package treatment below (§3.1 of the guide draws that line: no dependency on app types is what qualifies code for `packages/`).
- **Rationale**: Consistent with the guide's own pattern of narrow base classes matching actual behavior (§4.4) — a reactive local watch is neither sync nor a one-shot async call.
- **Trade-offs**: A cross-cutting addition to shared kernel code outside `notes-mvp`'s own feature folder — flagged explicitly as a Revalidation Trigger in `design.md`'s Boundary Commitments.
- **Follow-up**: **Actioned (2026-07-25)**, per explicit user direction — `flutter-clean-architecture-guide.md` §4.4 and §11 were updated directly as part of this spec's design revision, not deferred. The guide now documents six use-case variants (was four) and marks the local-persistence open item resolved.

### Decision: `AppLifecycleService` extracted as a standalone, zero-project-context package
- **Context**: Requirement 3.3 requires persisting note content immediately on paused/inactive/detached app lifecycle transitions. Blocs must never receive `BuildContext` (project-wide rule), so a widget-level `WidgetsBindingObserver` can't hand lifecycle events directly to `NoteEditorBloc`. The user asked that this be built with no project context so it can be dropped into other Flutter projects unmodified.
- **Alternatives Considered**: Placing it in `lib/core/lifecycle/` as an app-specific service (the original design) — rejected once cross-project reuse was requested, since anything under `lib/core/` still lives inside the `knowledge_hub` package and can't be copied out without editing imports.
- **Selected Approach**: A new standalone local package, `packages/app_lifecycle_service/`, exposing `abstract class AppLifecycleService { Stream<AppLifecycleState> get lifecycleChanges; }` and a `WidgetsBindingObserver`-backed implementation. The package carries **no** `get_it`/`injectable` annotations and **no** dependency on `package:knowledge_hub/...` — only `flutter` itself. The app wires it in via a manual `getIt.registerLazySingleton<AppLifecycleService>(() => AppLifecycleServiceImpl())` binding inside `lib/core/di/injection.dart`, and `NoteEditorBloc` depends on the abstract `AppLifecycleService` via constructor injection exactly as before.
- **Rationale**: Satisfies the guide's new §3.1 reuse test ("could this be copied into an unrelated Flutter project verbatim?") — yes, since it has zero app-specific types or annotations.
- **Trade-offs**: DI wiring moves from an in-package annotation to a small manual registration line in the app — a negligible cost for full portability.

### Decision: SQLite WAL+FTS5 setup extracted as a standalone, zero-project-context package
- **Context**: The Drift-over-Hive decision (above) settled *which* engine, but the WAL-mode database opening and FTS5 virtual-table/trigger SQL generation are themselves generic mechanics that don't reference `Note`/`Folder`/`Tag` at all — only table names and column lists, supplied as parameters. The user asked that this be unified/reusable across projects too.
- **Selected Approach**: A new standalone local package, `packages/sqlite_wal_fts_toolkit/`, providing (a) a WAL-mode database opener (thin wrapper around the `drift_flutter` setup helper, parameterized only by a file name) and (b) FTS5 SQL-string builders (`buildFts5ExternalContentTableSql(...)`, `buildFts5SyncTriggerSql(...)`) parameterized by table/column names, with zero references to this app's domain types. `lib/features/notes/data/local/notes_database.dart` remains app-specific (it defines the actual `Notes`/`Folders`/`Tags`/`NoteTags` Drift tables) but is *built on top of* this package's helpers rather than hand-rolling WAL/FTS5 setup inline.
- **Rationale**: The engine choice (Drift) and the reusability of its generic setup mechanics are separate concerns — separating them means any future project can adopt just the WAL+FTS5 toolkit without adopting this app's note schema.
- **Trade-offs**: One additional package boundary to maintain versus inlining the helpers directly in `notes_database.dart` — justified by the explicit cross-project reuse requirement.

### Decision: Markdown code-block editor extracted as a standalone, zero-project-context package
- **Context**: The "no markdown-rendering package" decision (above) settled the *approach* (custom `TextEditingController` + `RegExp` + a code-highlighting engine), but as originally scoped this lived inside `lib/features/notes/presentation/widgets/`, coupled to this app's styling. The user asked for it to be reusable with no project context.
- **Selected Approach**: A new standalone local package, `packages/markdown_code_block_editor/`, providing the fenced-code-block-detecting `TextEditingController` subclass and a `CodeBlockHighlightedTextField`-style widget that accepts caller-supplied `TextStyle`/highlight-theme parameters rather than baking in any app's design tokens. The app-specific `lib/features/notes/presentation/widgets/code_block_highlighted_text_widget.dart` becomes a thin composition wrapper that supplies `design.md`-derived styling into the generic package widget.
- **Rationale**: Keeps the genuinely generic parsing/highlighting logic (which language grammars, which regex detects a fence) separate from this app's specific visual identity, satisfying both the reuse requirement and the existing "UI components cite `design.md` tokens" rule (the citation now happens at the thin app-side wrapper, where it belongs).
- **Trade-offs**: None significant — this is a natural seam that already existed conceptually (parsing/highlighting vs. styling); the package boundary just makes it explicit and enforced.

### Decision: Soft-delete modeled as a nullable `deletedAt` field, not a separate Trash entity/table
- **Context**: Requirement 7 needs trash/restore/permanent-delete/auto-purge behavior.
- **Alternatives Considered**: A separate `TrashedNote` entity/table mirroring `Note` (rejected).
- **Selected Approach**: `deletedAt: DateTime?` on the existing `notes` table/entity. Active notes: `deletedAt IS NULL`. Trash: `deletedAt IS NOT NULL`. Permanent-purge threshold computed as `deletedAt + 30 days`, not stored.
- **Rationale**: Simplification lens — avoids duplicating the entire note schema and any dual-write logic for a state that's fundamentally one boolean-ish field on the same row.
- **Trade-offs**: None significant; folder/tag associations are naturally preserved through restore since the row never moved.
- **Clarification (user question, 2026-08-02)**: `folderId` and `deletedAt` are fully independent, orthogonal nullable fields — a note with `folderId: null` is simply unfiled (Requirement 4.2), regardless of its `deletedAt` value, and vice versa. "Permanently deleted" is **not** a third value of `deletedAt` (there's no way to distinguish "trashed" from "permanently deleted" on a timestamp column alone once the row disappears) — permanent deletion (both explicit, 7.3, and auto-purge, 7.4) is a hard `DELETE FROM notes WHERE id = ?`, cascading to `note_tags` and the `notes_fts` index. Once gone, the row doesn't exist to query at all; there is no lingering "permanently-deleted" record.

### Decision: DataSource implementations named `*LocalDataSourceImpl`, not `*DriftDataSourceImpl`
- **Context**: The user pointed out that `NotesDataSource` (the abstract contract) already defines the method shape any implementation — local or, later, network — must satisfy, per the guide's §6.2 single-contract pattern. The original naming (`NotesDriftDataSourceImpl`) named the implementation after *this phase's* storage engine rather than its *role*, which doesn't extend cleanly.
- **Alternatives Considered**: Keep `NotesDriftDataSourceImpl` (rejected — ties the class name to a Phase-1-only technology choice, and doesn't match the guide's own §6.2 worked example, which names its two implementations `ProductsRemoteDataSourceImpl`/`ProductsLocalDataSourceImpl`, not by their backing technology).
- **Selected Approach**: Rename to `NotesLocalDataSourceImpl` / `FoldersLocalDataSourceImpl` / `TagsLocalDataSourceImpl` (still Drift-backed today). In v1.1, a `NotesNetworkDataSourceImpl` (Supabase-backed) implementing the same `NotesDataSource` contract can be added directly, with `NotesRepositoryImpl` composing both via `@Named('local')`/`@Named('remote')` exactly per guide §6.2/§6.3 — no rename needed when sync arrives.
- **Rationale**: Matches the guide's own established naming convention (role-based, not technology-based); makes the v1.1 extension point structurally obvious rather than requiring a future rename.
- **Trade-offs**: None — this is a pure naming correction, not a behavior change.

### Decision: Establish `core/design_system/` — typed `design.md`-token classes + reusable button/text-field primitives
- **Context**: The user asked that presentation components stay in separate, reusable files rather than combined with feature flow — text fields, button variants (primary/secondary/tertiary-text/icon), text styles, and colors specifically — and that text-field behavior be unified across the app. Separately, `.kiro/steering/design-system.md` already mandates that every visual value be "surfaced through a typed Dart constants/theme class (this project's equivalent of `ScapiaColors`/`ScapiaStyles`)," but no such class existed yet since this is the first feature spec in a greenfield project.
- **Alternatives Considered**: Each feature widget citing `design.md` tokens ad hoc with inline `Color`/`TextStyle` literals (rejected — exactly what the design-system steering already prohibits, and would duplicate button/text-field chrome across every input in the app instead of unifying it).
- **Selected Approach**: `lib/core/design_system/` with one class per token category (`KnowledgeHubColors`, `KnowledgeHubTextStyles`, `KnowledgeHubSpacing`, `KnowledgeHubRadii`, `KnowledgeHubElevation` — each a 1:1 static-getter mirror of a `design.md` token category) plus reusable stateless widgets (`PrimaryButtonWidget`, `SecondaryButtonWidget`, `TertiaryTextButtonWidget`, `CircularIconButtonWidget`, `AppTextFieldWidget`). Feature widgets compose these; flow-specific wiring (which Bloc event fires `onPressed`/`onChanged`) stays at the call site, never inside the primitive itself.
- **Rationale**: `AppTextFieldWidget` in particular is the single answer to "how do we keep text-field behavior identical across the app" — one border/radius/focus-state/height implementation, reused by the note title field and the folder/tag name inputs, instead of three independent `TextField`s that could drift apart over time.
- **Trade-offs**: Stays in `core/`, not `packages/*` — it's tied to this app's specific `design.md` hex values/tokens, so it deliberately fails the guide's §3.1 "zero project context" reuse test (a different project has a different design system). This is the same reasoning that keeps `StreamUseCase` out of `packages/*`.
- **Follow-up**: `.kiro/steering/structure.md`'s `core/` directory list (`error/`, `usecase/`, `network/`, `di/`, `router/`, `domain_shared/`) doesn't yet mention `design_system/` — worth a small steering update once this establishes the pattern, but not actioned here since it wasn't explicitly requested this round.

### Decision: Folder/tag management are dialogs off the note list, not separate pages
- **Context**: Task-graph sanity review during `/kiro-spec-tasks` surfaced that `design.md`'s File Structure Plan defined only 3 pages (list, editor, trash) but `FolderCubit`/`TagCubit` clearly need a creation UI, and no corresponding file existed — a small gap, not a contradiction.
- **Selected Approach**: Added `folder_creation_dialog_widget.dart`/`tag_creation_dialog_widget.dart` to the File Structure Plan, launched from `note_list_page.dart`. Confirmed search has no separate page either — `search_bar_widget.dart` and its results are embedded in `note_list_page.dart`.
- **Rationale**: Matches the already-approved design's actual page count (3) rather than introducing new pages/routes not previously decided; keeps the fix additive (two new widget files) rather than reopening the page-count decision.
- **Trade-offs**: None — purely closes a small omission.

## Risks & Mitigations
- **FTS5 `ORDER BY rank` performance beyond 10k rows** — only evidence of degradation was in a network-backed virtual filesystem at 6M rows, not representative of local on-device SQLite; re-benchmark with a synthetic 10k+ dataset during implementation (per the PRD's own risk mitigation) rather than assuming it holds indefinitely.
- **SQLite rowid mapping for FTS5 external-content table** — the `notes` table's primary key is a TEXT UUID, not an INTEGER, so the external-content FTS5 table's `content_rowid` mapping relies on SQLite's implicit hidden rowid rather than the declared primary key. This is a documented SQLite pattern, not exotic, but must be verified with a dedicated round-trip test (insert → search → confirm correct UUID returned) during implementation.
- **`core/usecase/` shared-kernel addition (`StreamUseCase`) outside this feature's own folder** — mitigated by flagging it explicitly as a Revalidation Trigger in `design.md`; the guide update was actioned directly (see Follow-up above), not left as a future recommendation.
- **New `packages/` reuse convention introduced by this spec** — `app_lifecycle_service`, `sqlite_wal_fts_toolkit`, and `markdown_code_block_editor` are this app's first standalone packages; the guide's §3.1 now documents the convention (the "copy verbatim into another project" test) so future features apply it consistently instead of each reinventing the core/-vs-package boundary call.

## References
- [Drift documentation — SQL extensions (FTS5)](https://drift.simonbinder.eu/sql_api/extensions/) — confirms native `fts5`, `bm25()`, `highlight()`, `snippet()` support.
- [SQLite FTS5 documentation](https://sqlite.org/fts5.html) — external-content tables, `detail` mode storage trade-offs.
- [Flutter issue flutter/flutter#162966](https://github.com/flutter/flutter) — `flutter_markdown` discontinuation tracking.
- [Drift GitHub issue simolus3/drift#3702](https://github.com/simolus3/drift) — `sqlite3_flutter_libs` becoming a no-op as of v0.6.0.
