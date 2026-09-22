# Implementation Plan — notes-mvp

- [ ] 1. Foundation: shared kernel and local persistence setup
- [x] 1.1 Add the feature's new dependencies and scaffold the three standalone reusable packages
  - Add local path dependencies for the three new packages plus `drift`, `sqlite3`, `uuid`, and `bloc_concurrency` to the app's dependency manifest
  - Create the three package directories (SQLite WAL+FTS5 toolkit, Markdown code-block editor, app-lifecycle service), each with its own standalone package manifest and no dependency on the app itself
  - Observable: dependency resolution succeeds with all three local packages recognized as buildable, empty packages
  - _Requirements: 8.1_

- [x] 1.2 (P) Add the reactive stream-based use case pattern to the app's shared architecture kernel
  - Add the two reactive base classes (params and no-params variants) alongside the four existing Future-based ones, matching the pattern now documented in the Clean Architecture guide
  - Ensure the reactive contract mirrors the existing error-handling convention so a failure can never be silently dropped mid-stream
  - Observable: a passing test demonstrates a sample reactive use case forwarding both a success stream and a failure without alteration
  - _Requirements: 4.4, 5.2, 5.4, 5.5, 6.1, 6.2, 6.3, 10.1_
  - _Boundary: core/usecase_
  - _Note: also created `core/error/{failure,result}.dart` (Result/Failure types) as an unowned implicit prerequisite — `core/usecase/usecase.dart` cannot compile without them and no other task claims `core/error/` as its boundary. Content matches guide §4.1/§4.2 exactly; flagged here so it isn't silently absorbed._

- [x] 1.3 (P) [USER-IMPLEMENT] Build the SQLite WAL-mode-and-full-text-search toolkit package
  - Implement a WAL-mode local database opener parameterized only by a file name
  - Implement full-text-search virtual-table and sync-trigger SQL generation parameterized only by table and column names, with no reference to any app-specific concept
  - Observable: a passing package-level test suite verifies WAL mode is active on a freshly opened database and that generated full-text-search SQL round-trips an insert-then-search against arbitrary table/column names
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 6.2, 6.3_
  - _Boundary: packages/sqlite_wal_fts_toolkit_
  - _USER-IMPLEMENT: implemented and reviewer-approved. Uses drift's `NativeDatabase` + a `setup` callback (not `drift_flutter`, which needs Flutter) to stay pure-Dart; FTS5 round-trip (insert/update/delete → search) verified against real SQLite, not just string assertions._

- [x] 1.4 (P) Build the app-lifecycle-to-stream service package
  - Implement a lifecycle-observing service exposing app-foreground/background/detached transitions as a stream, with no dependency on the app itself or on any dependency-injection framework
  - Observable: a passing package-level test verifies each lifecycle transition is emitted on the stream exactly once
  - _Requirements: 3.3_
  - _Boundary: packages/app_lifecycle_service_

- [x] 1.5 (P) Build the Markdown fenced-code-block editing package
  - Implement fenced-code-block detection over plain text input and per-language syntax tokenization/coloring confined to detected code-block ranges, for at least Dart, JavaScript, Python, Swift, and Kotlin
  - Accept all styling (fonts, colors) as caller-supplied parameters rather than any baked-in value
  - Observable: a passing package-level test verifies text outside a fenced code block remains completely unstyled while text inside one is tokenized per the detected language
  - _Requirements: 2.3, 2.4_
  - _Boundary: packages/markdown_code_block_editor_
  - _Note: uses `package:highlight` directly (no `flutter_code_editor` dependency) — sanctioned in research.md as the "thin wrapper" alternative. `design.md`'s Technology Stack table still says "built on `flutter_code_editor`/`highlight`," which is now stale wording, not a code deviation._

- [x] 1.6 (P) Establish the app's typed design-system tokens and reusable presentation primitives
  - Create typed constant classes mirroring the design system's colors, typography, spacing, radius, and elevation values
  - Create reusable primary/secondary/tertiary-text/icon button components and the single shared text-field component, each accepting flow-specific behavior only via callback parameters
  - Observable: every color/typography/spacing/radius/elevation value used anywhere in this feature traces to one of these typed constants, with no literal value inlined in a widget
  - _Requirements: 2.1, 2.2_
  - _Boundary: core/design_system_
  - _Note: token-class unit tests only (no widget-render tests), per the project's explicit no-widget-test policy for `core/design_system` primitives. `AppTextFieldWidget` needed one remediation round: label restructured to a stacked caption above the field (not `InputDecoration.labelText`'s floating pattern) with a new `hintText` param, and vertical padding tuned to hit `design.md`'s documented 56px height exactly._

- [x] 1.7 [USER-IMPLEMENT] Define the local database schema for notes, folders, tags, and full-text search
  - Define the notes, folders, tags, and note-tags tables plus the full-text-search index over note title and body, built using the WAL+FTS5 toolkit's opener and SQL builders
  - Configure referential integrity so deleting a folder unfiles its notes and deleting a tag removes only its associations, never the notes themselves
  - Observable: a passing test suite verifies the schema creates successfully, the full-text index stays in sync after inserts/updates/deletes, and both cascade rules behave as specified
  - _Requirements: 4.1, 4.2, 4.3, 5.1, 6.2, 6.3_
  - _Depends: 1.3_
  - _Boundary: notes_database_
  - _USER-IMPLEMENT: implemented and reviewer-approved. `PRAGMA foreign_keys = ON;` set in `beforeOpen` (not `onCreate`) so it re-applies on every connection open, not just first creation — verified against drift's source. FTS5 hidden-rowid mapping (TEXT id, not INTEGER) independently confirmed correct via a round-trip._
  - _USER-IMPLEMENT: stub ready — signature + design note + failing tests committed, awaiting your implementation. Files: `lib/features/notes/data/local/notes_database.dart` (Notes/Folders/Tags/NoteTags table shells with only `id` columns declared, `NotesDatabase.migration` throws `UnimplementedError`; full column lists and FK/cascade wiring documented in the file's design-note comment), `test/features/notes/data/local/notes_database_test.dart` (5 failing tests: schema round-trip, unfiled note, folder-delete unfiles notes, tag-delete removes only the association, FTS5 search finds an inserted note). Note: `dart run build_runner build` needs `--force-jit` in this environment — the default AOT build-script compilation fails against `sqlite3`'s native build hooks ("dart compile does not support build hooks")._

- [ ] 2. Core: note-taking domain and data layer
- [x] 2.1 Define the note-taking domain model and supporting value objects
  - Define the note, folder, and tag business objects, the search-result representation carrying highlighted match snippets, and the filter parameters describing folder scope, tag selection with AND/OR mode, and active-versus-trash scope
  - Ensure a note's folder assignment and its trash status are represented as two fully independent optional values, never encoding one via the other
  - Observable: every field on every domain object has an explicit, concrete type with no dynamic or loosely-typed map anywhere
  - _Requirements: 4.1, 4.2, 5.1, 5.3, 6.4, 7.1_
  - _Note: freezed 3.2.5 (the pinned version) requires entity classes to be declared `abstract class X with _$X`, not the plain `class X with _$X` shown in flutter-clean-architecture-guide.md §5.1's example — that snippet predates a freezed 3.x breaking change. All future freezed usage in this project should follow `abstract class`, not the guide's literal snippet._

- [x] 2.2 Define the notes, folders, and tags persistence contracts
  - Define the abstract persistence contract for notes (create, save content, watch filtered/searched lists, move to/restore/permanently-delete-from trash, purge expired trash) and the equivalent contracts for folders and tags (create, watch list, delete)
  - Define the duplicate-name failure case as a distinct, explicit error type alongside the project's existing shared failure types
  - Observable: the contracts compile with fully explicit types on every parameter and return value, ready for a data-layer implementation to satisfy
  - _Requirements: 1.1, 1.2, 3.1, 3.2, 3.3, 3.4, 3.8, 4.4, 5.2, 5.4, 5.5, 6.1, 6.2, 6.3, 6.5, 7.1, 7.2, 7.3, 7.4, 10.1_

- [x] 2.3 (P) Implement local data access and storage mapping for notes
  - Implement the notes data-access implementation against the local database schema, converting between stored rows and domain objects in both directions
  - Name the implementation as a "local" variant of the shared contract (not tied to the storage engine's name) so a future network-backed variant can implement the same contract without renaming this one
  - Observable: a passing test suite verifies a note round-trips through storage unchanged, and that a stored note's tag associations resolve correctly
  - _Requirements: 1.1, 1.2, 3.1, 3.2, 3.3, 3.4_
  - _Depends: 1.7_
  - _Boundary: NotesLocalDataSourceImpl, NoteModel_
  - _Note: also created `lib/core/error/exception.dart` (ServerException/CacheException, per guide §4.3) as an unowned implicit prerequisite — no prior task created it and this is the first data-layer implementation task that needs it. `NotesDataSource`'s exact method shape isn't pinned in design.md (unlike the Repository contracts); designed here to satisfy this task's two Observables — `watchNotes` only supports folder + active/trash scoping, full AND/OR tag filtering is deferred to task 2.6. One review round: `saveNoteContent` initially leaked a raw `StateError` on a missing noteId instead of `CacheException` — fixed via `getSingleOrNull()` + explicit throw, with catch-clause ordering fixed so it isn't re-wrapped and message-mangled._

- [x] 2.4 (P) Implement local data access and storage mapping for folders
  - Implement the folders data-access implementation and its row-to-domain-object mapping in both directions, named as a "local" variant for the same future-extension reason as notes
  - Observable: a passing test suite verifies a folder round-trips through storage unchanged and that creating a duplicate folder name surfaces the distinct duplicate-name error
  - _Requirements: 4.1, 4.2, 4.3_
  - _Depends: 1.7_
  - _Boundary: FoldersLocalDataSourceImpl, FolderModel_
  - _Note: added `DuplicateNameException` alongside the existing `ServerException`/`CacheException`. One review round: the SELECT-then-INSERT duplicate-name precheck raced under concurrent calls (empirically proven), letting a UNIQUE-constraint `SqliteException` fall through as `CacheException` instead of `DuplicateNameException` — fixed by catching `extendedResultCode == 2067` (SQLITE_CONSTRAINT_UNIQUE) explicitly, ordered before the generic catch. This same precheck pattern will need the identical fix when task 2.5 (tags) is implemented._

- [x] 2.5 (P) Implement local data access and storage mapping for tags
  - Implement the tags data-access implementation and its row-to-domain-object mapping in both directions, named as a "local" variant for the same future-extension reason as notes and folders
  - Observable: a passing test suite verifies a tag round-trips through storage unchanged and that creating a duplicate tag name surfaces the distinct duplicate-name error
  - _Requirements: 5.1_
  - _Depends: 1.7_
  - _Boundary: TagsLocalDataSourceImpl, TagModel_
  - _Note: applied task 2.4's UNIQUE-constraint race fix proactively from the start — approved on the first review round with no rejection, including a fault-injection check confirming the concurrency test would actually catch the regression if the fix were removed._

- [x] 2.6 (P) [USER-IMPLEMENT] Implement the notes repository's persistence, search, and trash-lifecycle behavior
  - Implement the notes repository against its data-access dependency: content creation and saving, a live filtered/searched note stream that always applies a most-recently-modified-first default order, and the full trash lifecycle (move to trash without disturbing folder/tag assignment, restore, permanent delete as a real removal, and purging anything trashed more than 30 days ago)
  - Convert every caught storage exception into the shared failure type, never letting a raw exception escape this layer
  - Observable: a passing test suite verifies restoring a trashed note returns it to its original folder and tags unchanged, and that purging only ever removes notes trashed more than 30 days ago (verified at the exact boundary)
  - _Requirements: 1.1, 1.2, 3.1, 3.2, 3.3, 3.4, 3.8, 4.4, 5.2, 5.4, 5.5, 6.1, 6.2, 6.3, 6.4, 6.5, 7.1, 7.2, 7.3, 7.4, 10.1_
  - _Depends: 2.3_
  - _Boundary: NotesRepositoryImpl_
  - _USER-IMPLEMENT: implemented and reviewer-approved after 3 remediation rounds. Real bugs found and fixed along the way: zero error handling initially (raw exceptions escaped uncaught); a boundary-violating `Note.fromNoteModel` factory added to the already-approved domain entity that silently dropped folderId/tagIds/deletedAt (removed entirely, replaced with the existing `NoteModel.toEntity(tagIds:...)` from task 2.3); `watchNotes`/`watchSearchResults` used an unawaited `.forEach` and always returned an empty one-shot stream (fixed via `.asyncMap`); sort order was ascending instead of descending; the AND/OR tag filter treated an empty filter as "match nothing" instead of "no filter" and had the `allOf` direction backwards (fixed: filter tags must be a subset of note tags, not the reverse); error handling was broadened to specific `CacheException`/`ServerException` catches with message preservation and `dart:developer` logging, confirmed via probe that a genuine programming bug still propagates uncaught rather than being silently swallowed. 11 independent adversarial probes passed on final review._

- [x] 2.7 (P) Implement the folders repository's persistence and unfiling behavior
  - Implement the folders repository against its data-access dependency, including the rule that deleting a folder unfiles its member notes rather than deleting them
  - Observable: a passing test suite verifies notes previously in a deleted folder become unfiled rather than disappearing
  - _Requirements: 4.1, 4.2, 4.3_
  - _Depends: 2.4_
  - _Boundary: FoldersRepositoryImpl_
  - _Note:_ `FoldersRepositoryImpl` implemented against `FoldersDataSource`. `createFolder` converts `FolderModel`→`Folder` and maps `DuplicateNameException`→`Err(DuplicateNameFailure)`. `deleteFolder` is a pure passthrough — the unfiling cascade is DB-owned (`ON DELETE SET NULL`, proven at 1.7/2.4) and this layer doesn't reimplement it. `watchFolders` uses `StreamTransformer.fromHandlers` (not 2.6's `asyncMap`) to convert stream-level `CacheException`/`ServerException` *error* events into `Err(...)` *data* events, since `asyncMap` cannot intercept upstream error events — independently verified by the reviewer via a real `StreamController.addError()` probe (not just a synchronous-throw check). Error handling follows the 2.6 precedent: specific catches only, original exception messages preserved, `dart:developer` logging before every `Err(...)`. Approved with 2 non-blocking follow-up suggestions: (1) `FoldersLocalDataSourceImpl.watchFolders()`/`NotesLocalDataSourceImpl.watchNotes()` don't wrap Drift errors, so the new stream-error-to-`Err()` conversion path isn't reachable in production yet (pre-existing gap shared with 2.6, not a regression); (2) no permanent test for the `StreamTransformer`'s unrecognized-exception fallback branch (verified correct via reviewer's throwaway probe only).

- [x] 2.8 (P) Implement the tags repository's persistence and untagging behavior
  - Implement the tags repository against its data-access dependency, including the rule that deleting a tag removes only its note associations, never the notes
  - Observable: a passing test suite verifies notes previously carrying a deleted tag remain intact, minus that one tag association
  - _Requirements: 5.1_
  - _Depends: 2.5_
  - _Boundary: TagsRepositoryImpl_
  - _Note:_ `TagsRepositoryImpl` mirrors 2.7's `FoldersRepositoryImpl` shape exactly: `createTag` converts `TagModel`→`Tag` and maps `DuplicateNameException`→`Err(DuplicateNameFailure)`; `deleteTag` is a pure passthrough — the join-row cascade (`NoteTags` `ON DELETE CASCADE`, never touching `Notes`) is DB-owned and proven at 1.7/2.5; `watchTags` uses `StreamTransformer.fromHandlers` to convert stream-level `CacheException`/`ServerException` into `Err(...)` data events. Closes the gap flagged at 2.7's approval: added a permanent checked-in test for a genuine async `StreamController.addError()` stream error (not just a synchronous throw), which the reviewer confirmed is real and non-tautological via mutation testing (breaking the `CacheException` branch made the new test fail). Approved with one pre-existing, non-blocking, cross-cutting follow-up carried over from 2.7: no permanent test yet for the `StreamTransformer`'s unrecognized-exception fallback branch on either folders or tags.

- [ ] 3. Core: note lifecycle use cases
- [x] 3.1 (P) Implement note creation and content-save use cases
  - Implement the use case that creates a new empty note and the use case that persists in-progress title/body content to an existing note
  - Observable: a passing test suite verifies each use case forwards its parameters to the repository unchanged and propagates a failure untouched
  - _Requirements: 1.1, 1.2, 3.1, 3.2, 3.3, 3.4, 3.8_
  - _Depends: 2.6_
  - _Boundary: CreateNoteUc, SaveNoteContentUc_
  - _Note:_ Both are trivial passthroughs over `NotesRepository.createNote()`/`.saveNoteContent(params)` — no added logic. First use cases in this feature, so `mocktail` (guide §8.2's mandatory interaction-verification tool, absent from the project until now) was added as a dev dependency in a preceding commit, since a stateful `Fake` repository (the existing pattern for repository-contract tests) can't express "called exactly once with exactly these params." Tests assert exact param forwarding, untouched `Ok(...)` passthrough, and untouched `Err(...)` propagation via `verify(...).called(1)` + `verifyNoMoreInteractions(...)`.

- [x] 3.2 (P) Implement the reactive filtered-and-searchable note-list use cases
  - Implement the use case that watches a live note list filtered by folder and/or tags (with an AND/OR toggle) and scoped to active or trashed notes, and the use case that watches live, ranked, highlighted full-text search results
  - Observable: a passing test suite verifies AND-mode returns only notes carrying every selected tag while OR-mode returns notes carrying any selected tag, using the same underlying use case with different parameters
  - _Requirements: 4.4, 5.2, 5.4, 5.5, 6.1, 6.2, 6.3, 6.4, 6.5, 10.1_
  - _Depends: 2.6_
  - _Boundary: WatchFilteredNotesUc, WatchNoteSearchResultsUc_
  - _Note:_ Both are trivial reactive passthroughs (`StreamUseCase`) over `NotesRepository.watchNotes(filter)`/`.watchSearchResults(query)` — zero tag-matching logic in the use-case layer, that stays owned by `NotesRepositoryImpl` (task 2.6). The AND/OR Observable is satisfied via mock-forwarding: the same use-case instance is called with `tagFilterMode: allOf` vs `anyOf` params, and a mocked repository returns different canned streams per params value, proving correct parameterized passthrough — not reimplemented filtering. **Reviewer escalation (out of this task's boundary, tracked separately):** design.md:786 mandates a real AND/OR tag-filter-correctness regression test against `NotesRepositoryImpl.watchNotes()`; none exists — `notes_repository_impl_test.dart`'s `watchNotes` group is still the `skip:`-marked placeholder from task 2.6, and the adversarial probes that found/fixed the empty-filter and reversed-`allOf`-direction bugs during 2.6's review were never persisted as regression tests. Needs a follow-up task against task 2.6's boundary.

- [x] 3.3 (P) Implement the trash lifecycle use cases
  - Implement the use cases for moving a note to trash, restoring it, permanently deleting it directly from trash, and purging everything past the retention window
  - Observable: a passing test suite verifies each use case forwards to the repository unchanged and that the purge use case reports how many notes it removed
  - _Requirements: 7.1, 7.2, 7.3, 7.4_
  - _Depends: 2.6_
  - _Boundary: MoveNoteToTrashUc, RestoreNoteFromTrashUc, PermanentlyDeleteNoteUc, PurgeExpiredTrashUc_
  - _Note:_ Four trivial passthroughs over `NotesRepository`'s trash methods; `PurgeExpiredTrashUc` deliberately contains no 30-day boundary logic (owned by `NotesRepositoryImpl`, task 2.6). Removed-count Observable tested with a real value assertion (`Ok(5)` → `.value == 5`), not just a type check.

- [x] 3.4 (P) Implement folder management use cases
  - Implement the use cases to create a folder, watch the live folder list, and delete a folder
  - Observable: a passing test suite verifies each use case forwards to the repository unchanged and propagates a duplicate-name failure untouched
  - _Requirements: 4.1, 4.2, 4.3_
  - _Depends: 2.7_
  - _Boundary: CreateFolderUc, WatchFoldersUc, DeleteFolderUc_
  - _Note:_ Three trivial passthroughs over `FoldersRepository`; `DeleteFolderUc` contains no unfiling-cascade logic (DB-owned, task 2.7). Duplicate-name-failure propagation tested with real type/message/identity assertions, not just `isA<Err>()`.

- [x] 3.5 (P) Implement tag management use cases
  - Implement the use cases to create a tag, watch the live tag list, and delete a tag
  - Observable: a passing test suite verifies each use case forwards to the repository unchanged and propagates a duplicate-name failure untouched
  - _Requirements: 5.1_
  - _Depends: 2.8_
  - _Boundary: CreateTagUc, WatchTagsUc, DeleteTagUc_
  - _Note:_ Three trivial passthroughs over `TagsRepository`, mirroring 3.4's folder use cases exactly. `DeleteTagUc` contains no join-table/cascade logic (DB-owned, task 2.8). Completes all of group 3 (use cases) — every use case in the feature is now a reviewer-verified pure passthrough over its repository, with zero business logic duplicated outside the already-approved repository layer.

- [ ] 4. Core: presentation foundations
- [x] 4.1 Implement shared human-readable error messaging for the note-taking feature
  - Implement one function that exhaustively converts every known failure type into a specific, actionable, user-facing message (never a generic fallback), covering the storage-failure, duplicate-name, and not-found cases distinctly
  - Ensure every place that catches a storage exception logs the original exception and stack trace for developer diagnosis before converting it to a failure
  - Observable: a passing test suite verifies one specific message per failure type, including that a duplicate-name message names the exact folder/tag name that was attempted
  - _Requirements: 3.1, 3.2, 3.3, 3.4_ (note: this citation is a pre-existing tasks.md authoring bug — Requirement 3 is Autosave, unrelated to error messaging; flagged during review, not corrected here since fixing it is out of this task's scope)
  - _Depends: 2.6, 2.7, 2.8_
  - _Note:_ `mapFailureToMessage(Failure)` in `lib/features/notes/presentation/` exhaustively switches over all 5 sealed `Failure` subtypes. Per an explicit user decision, the not-found case is distinguished from a genuine storage failure via case-insensitive message-content matching on `CacheFailure.message` (not a new `NotFoundFailure` type) — deliberately avoids reopening the already-approved `NotesRepositoryImpl`/`FoldersRepositoryImpl`/`TagsRepositoryImpl`. `DuplicateNameFailure` messages are reparsed into the design.md template with the attempted name preserved. `ServerFailure`/`NetworkFailure` route through design.md's documented "any other/future Failure subtype" catchall message verbatim (both are currently unreachable in this offline-only v1 feature) — first review round rejected an initial version that invented undocumented bespoke copy for these two instead; fixed by routing through the exact catchall string and re-approved. Audited all ~30 catch sites across the 3 repository implementations for the log-before-convert requirement: already compliant, no changes needed.

- [x] 4.2 (P) [USER-IMPLEMENT] Implement the note editor's autosave state machine and its four save triggers
  - Implement the note-editing orchestration exposing a distinct state for each save-status scenario (not-saved, saving, saved, save-failed) rather than one state carrying a status flag, driven by four independent triggers: idle-based debounce, character-count threshold, app-lifecycle transition, and an explicit manual action
  - Ensure every trigger converges on the same underlying save operation so there is exactly one write path to reason about for the zero-data-loss guarantee
  - Also emit a distinct, retryable failure state when the initial `CreateNoteUc` call fails, so the user isn't stranded on a dead `NoteEditorInitializing` screen (design.md amendment, 2026-09-19 — see `NoteEditorCreationFailed`)
  - Observable: a passing test suite verifies each of the four triggers produces the same not-saved-to-saving-to-saved state sequence, that a failed save preserves the in-progress draft rather than discarding it, and that a failed note creation emits a retryable state rather than leaving the Bloc stuck initializing
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8_
  - _Depends: 3.1_
  - _Boundary: NoteEditorBloc_
  - _USER-IMPLEMENT:_ **Design correction discovered during implementation (2026-09-19)**: the original stub's design note suggested a `bloc_concurrency`/`stream_transform` event-transformer for the 300ms idle debounce — mechanically incompatible with the 100-char-threshold bypass, since a transformer gates *when the handler runs at all* and the handler can't bypass a delay it never got invoked during. Corrected to a hand-rolled `DebounceThresholdController`/`DebounceThresholdRegistry` (`lib/core/utils/debounce_threshold_controller.dart`, new reusable utility) — no event-transformer on `on<NoteEditorTitleChanged>`/`on<NoteEditorBodyChanged>`, the controller owns both the idle-debounce timing and the threshold-bypass decision per field. `NoteEditorCreationFailed(String errorMessage)` added as a 6th sealed state for the retry path. Freezed sealed-union getters need `const NoteEditorState._();` (a private constructor, matching `Note`/`Folder`/`Tag`'s existing pattern) — an in-class getter without one fails to compile for every generated variant, a lesson later applied upstream to `FolderState`/`TagState`/`TrashState` too. Went through many remediation rounds fixing real, independently-empirically-confirmed bugs: a broken `part of` file restructuring; missing `await` on the debounce registry call (caused a hard `emit`-after-handler-completed crash); a dead-code `isClosed` guard (an `@override emit()` that never actually intercepted anything, since flutter_bloc routes emission through each handler's own local `Emitter` parameter — fixed via `emit.isDone` checks, the correct idiom); undisposed debounce registry in `close()`; title/body silently wiped to `''` on every save that didn't explicitly touch that field (multiple rounds — final fix: two instance fields updated *synchronously* at the top of each change handler, before the debounce call, so any trigger always sees the latest typed content regardless of debounce timing); wrong debounce/threshold constants (100/300 were swapped); `_saveNote`'s return value discarded so the threshold never re-armed after a successful forced save (permanent runaway force-saving); and `folderId`/`tagIds` silently dropped from the `saving`/`saveFailed` states specifically (a 3rd `NoteEditorViewModel` construction site missed in an earlier "fixed folderId/tagIds" pass). `mapFailureToMessage` is deliberately NOT used yet, per explicit user decision — deferred until the use cases' error taxonomy is better known. `bloc_test` cannot be installed on this project's toolchain (see design.md's 2026-08-30 tooling correction) — tests use plain `flutter_test` (`expectLater`/`emitsInOrder`/predicates). Final review: APPROVED, 7 tests covering all four triggers, the creation-failed retry path, and folder/tag preservation through the full save lifecycle.

- [x] 4.3 (P) Implement the search experience's debounced, gated result stream
  - Implement the search orchestration that only queries once the input reaches at least 3 characters and has been idle for 300ms, exposing a distinct no-results state separate from the loading/results states
  - Observable: a passing test suite verifies no query fires below the character threshold or before the idle debounce settles, and that a query matching nothing produces the distinct no-results state
  - _Requirements: 6.1, 6.5_
  - _Depends: 3.2_
  - _Boundary: SearchBloc_
  - _Note:_ `SearchBloc` composes `stream_transform`'s `.debounce(300ms)` with `bloc_concurrency`'s `restartable()` (promoted `stream_transform` to a direct dependency) — genuinely idle-settling, empirically proven via manually-timed probes during review, not just cancellation-on-new-event. 5-state model per design.md plus a disclosed, reviewer-approved `SearchState.searchFailed` addition (design.md amended). The below-3-char reset path also rides the same debounce (bounded stale-state window, not indefinite) — a documented, accepted trade-off over adding a second un-debounced handler. `NoteSearchResultViewModel` added with no domain-entity leakage into its public shape.

- [x] 4.4 (P) Implement the note list, folder selection, and tag AND/OR filtering orchestration
  - Implement the note-list orchestration exposing the currently filtered list (defaulting to most-recently-modified-first) and the currently selected folder/tags/filter-mode
  - Observable: a passing test suite verifies selecting a folder, toggling tags, and switching AND/OR mode each produce the correctly filtered list
  - _Requirements: 4.4, 5.2, 5.3, 5.4, 5.5, 10.1_
  - _Depends: 3.2_
  - _Boundary: NoteListCubit_
  - _Note:_ Thin Cubit wrapping `WatchFilteredNotesUc`; `selectFolder`/`toggleTag`/`setTagFilterMode` mutate the active filter and re-subscribe. Doesn't re-sort (`NotesRepositoryImpl.watchNotes` already sorts most-recently-modified-first). Two judgment calls, documented inline: reuses domain `NoteListFilterParams` directly as `NoteListLoaded`'s `activeFilter` field (design.md names a `NoteListFilterViewModel` but never defines it or lists it in the File Structure Plan — the domain type is already primitive-only with no leakage concern), and adds a 3rd state `NoteListLoadFailed` for stream errors (design.md's 2-state model was silent on this), deliberately not carrying the prior list forward since it no longer corresponds to the current filter. The subscription-cancel-and-resubscribe race (rapid `selectFolder` calls with out-of-order stream resolution) was empirically verified safe via a throwaway probe — Dart's `StreamSubscription.cancel()` genuinely suppresses further delivery from the canceled subscription, confirmed not just reasoned about.

- [x] 4.5 (P) Implement folder management orchestration
  - Implement the folder-management orchestration exposing the live folder list and a distinct creation-failed state (carrying the current list forward) when a duplicate name is attempted
  - Observable: a passing test suite verifies a duplicate-name attempt emits the distinct failure state without losing the existing folder list
  - _Requirements: 4.1, 4.2, 4.3_
  - _Depends: 3.4_
  - _Boundary: FolderCubit_
  - _Note:_ Thin Cubit over `CreateFolderUc`/`WatchFoldersUc`/`DeleteFolderUc`. Routes every `createFolder` failure (not only `DuplicateNameFailure`) through `FolderCreationFailed`, carrying the current list forward. Went through 2 review rounds: round 1 rejected for reusing `FolderCreationFailed` to also represent live watch-stream failures (mislabeling + a concrete blank-error-message bug path via `mapFailureToMessage`'s not-found silent-no-op case) — fixed by adding a dedicated `FolderListLoadFailed` state (mirroring `NoteListLoadFailed`, task 4.4), no list carried forward. Round 2 rejected only for a missing design.md amendment note; fixed. Also discovered along the way: freezed sealed-union classes need a private constructor (`const FolderState._();`-style, matching `Note`/`Folder`/`Tag`'s existing pattern) or an extension to support custom getters — an in-class getter with a body fails to compile for every generated variant.

- [x] 4.6 (P) Implement tag management orchestration
  - Implement the tag-management orchestration exposing the live tag list and a distinct creation-failed state (carrying the current list forward) when a duplicate name is attempted
  - Observable: a passing test suite verifies a duplicate-name attempt emits the distinct failure state without losing the existing tag list
  - _Requirements: 5.1_
  - _Depends: 3.5_
  - _Boundary: TagCubit_
  - _Note:_ Thin Cubit over `CreateTagUc`/`WatchTagsUc`/`DeleteTagUc`, mirroring `FolderCubit`'s final (post-remediation) shape exactly: 4-state model from the start (`TagListLoading`/`TagListLoaded`/`TagCreationFailed`/`TagListLoadFailed`, the last distinguishing live watch-stream failures from `createTag` action failures), `const TagState._();` private constructor for the `currentTags` getter, `isClosed` guarded via direct checks before each `emit`. Approved on first review pass — the two lessons from task 4.5's rejection rounds were briefed upfront and applied correctly without needing a remediation cycle.

- [x] 4.7 (P) Implement trash management orchestration
  - Implement the trash orchestration exposing the live trashed-notes list and the restore/permanent-delete actions, reusing the same filtered-note-list mechanism scoped to trash rather than a separate mechanism
  - Observable: a passing test suite verifies restoring or permanently deleting an item updates the exposed list accordingly
  - _Requirements: 7.1, 7.2, 7.3, 7.4_
  - _Depends: 3.2, 3.3_
  - _Boundary: TrashCubit_
  - _Note:_ Last of the 4 sibling Cubits — approved on first review pass, all lessons from the earlier 3 Cubits' rejection rounds applied upfront (4-state model with `TrashListLoadFailed`, `const TrashState._();`, direct `isClosed` guards, design.md amended proactively). Reuses `WatchFilteredNotesUc(lifecycleScope: trash)` per the task's explicit instruction rather than a separate use case; `restore`/`permanentlyDelete` don't manually mutate the list — the live subscription is the sole source of truth, verified timing-correct via a `StreamController`-based test. `TrashedNoteViewModel.daysRemainingLabel` uses calendar-date difference (not raw `Duration.inDays`, which truncates under clock drift) and never goes negative for an overdue-but-not-yet-purged note.

- [ ] 5. Core: screens and widgets
- [x] 5.1 (P) Build the note editor screen with title/body editing, code-block highlighting, and save-status display
  - Build the screen presenting distinct title and body fields (body treated as Markdown source, monospace-and-highlighted only inside fenced code blocks, otherwise fully plain), using the shared text-field component for the title and the fenced-code-block editing package for the body
  - Build the save-status indicator as its own reusable component that visually distinguishes not-saved/saving/saved by switching on which editor state is active
  - Use the design system's canvas/ink/body text tokens and typography hierarchy for all page text, and the primary/tertiary button components for the manual-save and back actions
  - Observable: typing in the body shows syntax-highlighted, monospace fenced code blocks with everything else as plain text, and the save-status indicator visibly changes across the not-saved/saving/saved sequence
  - _Requirements: 1.1, 1.2, 2.1, 2.2, 2.3, 2.4, 3.5, 3.6, 3.7_
  - _Depends: 4.2_
  - _Boundary: NoteEditorPage_
  - _Note:_ First UI-screen task — no automated widget tests per this feature's confirmed policy; verified via `flutter analyze` and the reviewer's own throwaway `pumpWidget` tests (deleted, never committed). `SaveStatusIndicatorWidget`/`CodeBlockHighlightedTextWidget` implement the 2026-09-20-resolved design mappings exactly. The highest-risk part — preventing the title/body `TextEditingController`s from resetting cursor position on every autosave-triggered state emission — is correctly solved by gating resync strictly on `noteId` change (a `BlocListener.listenWhen` for title, a stable `Key` for body); reviewer proved this both by tracing the Bloc's state machine and empirically, including a fault-injection control (forcing `listenWhen` to always fire) that reproduced the cursor-jump bug the mitigation prevents. Two disclosed, accepted gaps: no localization infrastructure exists in this project (hardcoded UI strings), and design.md has no syntax-highlight color-token category (conservative derivations from existing text tokens used instead).

- [x] 5.2 (P) Build the note list screen with folder/tag filtering and integrated search
  - Build the single screen presenting the note list (each row using the design system's surface/radius/elevation/typography tokens), a folder selector, a tag filter control including the AND/OR mode toggle, and an embedded search entry (adapting the design system's pill-shaped search-bar shape/surface/radius to a single free-text field) with its own ranked, highlighted results and distinct no-results presentation — search is part of this one screen, not a separate page
  - Observable: selecting a folder or toggling tags visibly changes the displayed notes within the filter's expected responsiveness; typing a 3+ character query after the debounce settles shows ranked results with matched terms visibly highlighted, or the distinct no-results presentation when nothing matches; an empty filtered result shows a plain empty-list presentation rather than an error
  - _Requirements: 4.4, 5.2, 5.3, 5.4, 5.5, 6.1, 6.2, 6.4, 6.5, 9.1, 9.2, 10.1_
  - _Depends: 4.3, 4.4_ (also consumes `FolderCubit`/`TagCubit`, tasks 4.5/4.6 — not originally listed here, a task-authoring gap worth fixing in future specs; both were already approved when this task began)
  - _Boundary: NoteListPage_
  - _Note:_ Largest UI screen so far — combines `NoteListCubit`, `SearchBloc`, `FolderCubit`, and `TagCubit` on one page with `BlocSelector`-scoped rebuilds throughout. Went through one rejection round: the first pass omitted all tag-filter UI and reduced the folder selector to a reset-only "All notes" chip, incorrectly claiming `FolderCubit`/`TagCubit` were "deferred to task 6.1" — reviewer correctly identified that both Cubits were already fully approved and consumable via the same `context.read` pattern already used for the other two Blocs, so this left Requirements 4.4/5.3/5.4/5.5 with no observable behavior. Fixed by wiring in real folder/tag chips and the AND/OR toggle, driven by live `FolderCubit.currentFolders`/`TagCubit.currentTags`. FTS5 `<mark>` highlight markup is parsed into styled `TextSpan`s via a small `RegExp`-based helper, empirically verified correct across several edge cases (no match, match at string boundaries, multiple/adjacent matches). Two disclosed, accepted gaps mirroring task 5.1's precedent: no localization infrastructure, and no design.md token for highlighted-search-match color (uses `primary`, the system's one brand-accent color). Confirmed but explicitly out of this task's scope: `NotesLocalDataSourceImpl.watchSearchResults` is still an unimplemented USER-IMPLEMENT stub (discovered during this task, tracked separately) — the search UI is built correctly against `SearchBloc`'s contract, which is fully tested against mocks; real search won't work end-to-end until that stub is filled in.

- [x] 5.3 (P) Build the folder management dialog
  - Build the dialog (launched from the note list screen) presenting the folder creation entry using the shared text-field component and the folder list with delete actions, surfacing a duplicate-name attempt as a field-level message rather than a generic error
  - Observable: attempting to create a folder with an existing name shows the specific duplicate-name message without clearing the existing folder list from view
  - _Requirements: 4.1, 4.2, 4.3_
  - _Depends: 4.5_
  - _Boundary: FolderCreationDialogWidget_
  - _Note:_ A self-contained dialog (not launched here — task 6.2 wires the actual entry point on `NoteListPage`, per its own `_Depends:` list and design.md's File Structure Plan, confirmed by the reviewer as the correct interpretation, not a gap). `FolderCreationFailed`'s carried-forward folder list renders through the same branch as `FolderListLoaded`, satisfying the "without clearing the existing folder list" Observable directly; the field-level `errorText` comes from `AppTextFieldWidget`, distinct from `FolderListLoadFailed`'s separate stream-error presentation. Approved on first review pass, verified with two independent throwaway `pumpWidget` tests (implementer's and reviewer's own, both deleted, never committed) proving the exact duplicate-name message, list preservation, empty-name no-op guard, and correct per-row delete wiring.

- [x] 5.4 (P) Build the tag management dialog
  - Build the dialog (launched from the note list screen) presenting the tag creation entry using the shared text-field component and the tag list with delete actions, surfacing a duplicate-name attempt as a field-level message rather than a generic error
  - Observable: attempting to create a tag with an existing name shows the specific duplicate-name message without clearing the existing tag list from view
  - _Requirements: 5.1_
  - _Depends: 4.6_
  - _Boundary: TagCreationDialogWidget_
  - _Note:_ A faithful structural mirror of `FolderCreationDialogWidget` (task 5.3), adapted for `TagCubit`/`TagViewModel`. Explicitly verified `TagState`'s actual API before assuming it matched `FolderState`'s shape — `TagState` uses a private-constructor-based `currentTags` getter, not an extension, but the widget's own inline pattern-match over all 4 subclasses is independent of that getter either way. Same disclosed gaps as the folder dialog (no scrim token, no localization, pragmatic `_maxListHeight` constant) and same "not wired into NoteListPage here" reasoning (task 6.2 owns that). Approved on direct review after two consecutive reviewer-agent infrastructure failures (a connection drop, then a stall) — verified directly instead: `flutter analyze` clean, full suite green on rerun (one earlier run showed a single flaky failure in `NoteEditorBloc`'s real-timer debounce tests, unrelated to this change, not reproduced on a clean rerun).

- [ ] 5.5 (P) Build the trash screen
  - Build the screen presenting trashed notes with restore and permanent-delete actions per item
  - Observable: restoring an item returns it to the main note list with its original folder/tags visibly intact, and permanently deleting an item removes it from the trash list immediately
  - _Requirements: 7.1, 7.2, 7.3, 7.4_
  - _Depends: 4.7_
  - _Boundary: TrashPage_

- [ ] 6. Integration: wiring the feature together
- [ ] 6.1 Wire dependency injection for the complete note-taking feature
  - Register the local database, repositories, and data sources through the app's dependency-injection configuration, and manually register the app-lifecycle service implementation since it carries no framework annotations itself
  - Observable: the app starts up with every note-taking dependency resolvable with no manual wiring left at any call site
  - _Requirements: 8.1, 8.2_
  - _Depends: 2.6, 2.7, 2.8_

- [ ] 6.2 Wire note capture and folder/tag management entry points into app navigation
  - Wire the note list screen's capture action so that starting a new note reaches an empty, ready-to-type editor within 3 taps from app launch, and wire the note list screen's entry points that open the folder and tag management dialogs
  - Observable: launching the app and starting a new note reaches an editable, empty note in 3 taps or fewer, and opening either management entry point shows its dialog over the note list
  - _Requirements: 1.1, 1.2, 1.3_
  - _Depends: 6.1, 5.1, 5.2, 5.3, 5.4_

- [ ] 6.3 Wire the trash auto-purge check into app startup
  - Invoke the purge-expired-trash use case once during app startup, after dependency injection is configured, without blocking the app from becoming interactive
  - Observable: a note trashed more than 30 days before a simulated app start no longer appears anywhere after that start completes
  - _Requirements: 7.4_
  - _Depends: 6.1_

- [ ] 7. Validation: cross-cutting verification
- [ ] 7.1 Verify full offline operation across every core flow
  - Verify that creating, editing, deleting, searching, and organizing notes all function fully with no network connectivity, and that no network-dependent loading or error state ever appears for these flows
  - Observable: a full pass through create/edit/delete/search/organize with connectivity disabled completes with no network-related UI ever shown
  - _Requirements: 8.1, 8.2_
  - _Depends: 6.2, 6.3_

- [ ] 7.2 Verify zero data loss across app crash and force-quit
  - Verify that content typed into a note survives a simulated crash or force-quit at points corresponding to each of the four save triggers
  - Observable: an automated crash-recovery test confirms no typed content is lost regardless of which save trigger was most recently pending
  - _Requirements: 3.8_
  - _Depends: 6.2_

- [ ] 7.3 Verify search and tag-filter performance against a 10,000-note corpus
  - Run the search and tag-filter operations against a synthetic 10,000-note dataset and confirm they stay within their respective latency budgets
  - Observable: measured search latency stays at or under 100ms and tag-filter latency stays at or under 50ms across the full synthetic corpus
  - _Requirements: 5.2, 6.3_
  - _Depends: 6.1_

- [ ] 7.4 Verify persona-neutral behavior of core flows
  - Verify that the capture, search, and organization flows behave identically regardless of persona-specific affordances layered on top (code-block highlighting, course-style tags)
  - Observable: the same capture/search/organize sequence produces identical core behavior whether or not persona-specific affordances are exercised
  - _Requirements: 9.1, 9.2_
  - _Depends: 6.2, 6.3_

## Implementation Notes

- `dart run build_runner build` fails in this environment with "dart compile does not support build hooks, use 'dart build' instead" once `sqlite3`/`drift` are dependencies (they declare a native build hook for the sqlite3 native library) — always pass `--force-jit` (e.g. `dart run build_runner build --delete-conflicting-outputs --force-jit`) to skip the incompatible AOT build-script compilation path. Affects any task needing codegen (Drift, freezed, injectable) from this point on.
