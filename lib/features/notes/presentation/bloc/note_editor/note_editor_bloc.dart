import 'dart:async';

import 'package:app_lifecycle_service/app_lifecycle_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/utils/debounce_threshold_controller.dart';
import 'package:knowledge_hub/core/utils/public_utils.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_note_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/save_note_content_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/note_editor/note_editor_event.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/note_editor/note_editor_state.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/note_editor_view_model.dart';

/// USER-IMPLEMENT (notes-mvp task 4.2). Orchestrates capture, editing, and
/// the four autosave triggers (design.md §"NoteEditorBloc" — Requirements
/// 1.1-1.3, 2.1, 2.2, 3.1-3.8). This is a stub: the constructor wiring,
/// event registrations, and state shape are fixed by the design; every
/// handler body currently throws [UnimplementedError] and must be replaced
/// with the real orchestration.
///
/// ## Design note — what the real implementation needs to do
///
/// **The single write path (3.8's zero-data-loss guarantee).** All four
/// triggers below must converge on the same `_saveNoteContentUc.call(...)`
/// invocation, built from whatever the current buffered title/body content
/// is at the moment each trigger fires. There must be exactly one method
/// that performs the save (e.g. a private `_save(...)` helper each handler
/// calls) — this is the crux of the "one write path to reason about" goal;
/// resist the temptation to give any trigger its own bespoke save logic.
///
/// **Trigger 1 — 300ms idle debounce.** `on<NoteEditorBodyChanged>` (and
/// likely `on<NoteEditorTitleChanged>`) needs a `transformer:` that waits
/// for 300ms of no further events before processing — `bloc_concurrency`
/// alone does not provide a debounce transformer (it ships `concurrent`/
/// `sequential`/`droppable`/`restartable`, not `debounce`); design.md's
/// wording ("a `bloc_concurrency` `restartable` transformer") implies
/// composing a debounce source (e.g. `package:stream_transform`'s
/// `.debounce(Duration)`, not currently a dependency of this project — add
/// it if you go this route) with `restartable()` so a fresh keystroke
/// cancels any pending in-flight save from a prior one. Deciding the exact
/// transformer composition is this task's core design problem — it is
/// deliberately left unresolved here.
///
/// **Trigger 2 — 100-character threshold.** Per design.md: "checked inside
/// the same handler and bypasses the debounce when reached first." This
/// means the char-count check happens synchronously inside the
/// `NoteEditorBodyChanged` handler body (comparing against the
/// last-persisted content's length, or a running counter since the last
/// save) — if the threshold is crossed, save immediately rather than
/// waiting on the debounce transformer to settle.
///
/// **Trigger 3 — app lifecycle transitions.** The constructor subscribes to
/// `_appLifecycleService.lifecycleChanges` and forwards each emission as a
/// `NoteEditorEvent.appLifecycleChanged(...)` — bridging the external
/// stream into the Bloc's own event pipeline (never mutating state directly
/// from the subscription callback) so it goes through the same handler
/// pipeline as everything else. `on<NoteEditorAppLifecycleChanged>` should
/// save immediately (no debounce) when the new state is `paused`,
/// `inactive`, or `detached` — the app may be about to be killed.
///
/// **Trigger 4 — manual save.** `on<NoteEditorManualSaveRequested>` saves
/// immediately, no debounce, no threshold check.
///
/// **Failure handling.** On `Err(failure)` from `_saveNoteContentUc`, emit
/// `NoteEditorState.saveFailed(viewModel, errorMessage)` where `viewModel`
/// is the *current in-memory draft*, not the last-persisted content — the
/// failed save must never discard what the user typed (3.8's other half of
/// the zero-data-loss guarantee). Use `mapFailureToMessage` (task 4.1,
/// `lib/features/notes/presentation/map_failure_to_message.dart`) to
/// produce `errorMessage`.
///
/// **Lifecycle cleanup.** Cancel the lifecycle subscription in `close()`.
///

class NoteEditorBloc extends Bloc<NoteEditorEvent, NoteEditorState> {
  NoteEditorBloc({
    required CreateNoteUc createNoteUc,
    required SaveNoteContentUc saveNoteContentUc,
    required AppLifecycleService appLifecycleService,
  }) : _createNoteUc = createNoteUc,
       _saveNoteContentUc = saveNoteContentUc,
       _appLifecycleService = appLifecycleService,
       super(const NoteEditorState.initializing()) {
    on<NoteEditorStarted>(_onStarted);
    on<NoteEditorTitleChanged>(_onTitleChanged);
    on<NoteEditorBodyChanged>(_onBodyChanged);
    on<NoteEditorManualSaveRequested>(_onManualSaveRequested);
    on<NoteEditorAppLifecycleChanged>(_onAppLifecycleChanged);

    _lifecycleSubscription = _appLifecycleService.lifecycleChanges.listen(
      (AppLifecycleState lifecycleState) => add(NoteEditorEvent.appLifecycleChanged(lifecycleState)),
    );
  }

  final DebounceThresholdRegistry _debounceThresholdRegistry = DebounceThresholdRegistry(
    thresholdStep: 100,
    debounceDuration: const Duration(milliseconds: 300),
  );

  final CreateNoteUc _createNoteUc;
  final SaveNoteContentUc _saveNoteContentUc;
  final AppLifecycleService _appLifecycleService;
  late final StreamSubscription<AppLifecycleState> _lifecycleSubscription;

  String? _titleToBeSaved;
  String? _bodyToBeSaved;

  // create a note
  Future<void> _onStarted(
    NoteEditorStarted event,
    Emitter<NoteEditorState> emit,
  ) async {
    final Result<Failure, Note> createNote = await _createNoteUc.call();

    createNote.when(
      failure: (fail) {
        final String reason = fail.message;
        printLog("create note start failure: $reason");
        if (emit.isDone) return;
        emit(NoteEditorState.creationFailed(reason));
      },
      success: (note) {
        final NoteEditorViewModel vm = NoteEditorViewModel(
          noteId: note.id,
          title: note.title,
          body: note.body,
          folderId: note.folderId,
          tagIds: note.tagIds,
        );
        if (emit.isDone) return;
        emit(NoteEditorState.notSaved(vm));
      },
    );
  }

  // change the title
  Future<void> _onTitleChanged(
    NoteEditorTitleChanged event,
    Emitter<NoteEditorState> emit,
  ) async {
    _titleToBeSaved = event.title;
    await _debounceThresholdRegistry.run(
      currentCount: event.title.length,
      key: 'title',
      execute: () async {
        final result = await _saveNote(emit);

        return result;
      },
    );
  }

  // change the body
  Future<void> _onBodyChanged(
    NoteEditorBodyChanged event,
    Emitter<NoteEditorState> emit,
  ) async {
    _bodyToBeSaved = event.body;
    await _debounceThresholdRegistry.run(
      key: 'body',
      currentCount: event.body.length,
      execute: () async {
        final result = await _saveNote(emit);

        return result;
      },
    );
  }

  // manual update of note
  Future<void> _onManualSaveRequested(
    NoteEditorManualSaveRequested event,
    Emitter<NoteEditorState> emit,
  ) async {
    await _saveNote(
      emit,
    );
  }

  // save on app lifecycle change to pause/inactive/detached
  Future<void> _onAppLifecycleChanged(
    NoteEditorAppLifecycleChanged event,
    Emitter<NoteEditorState> emit,
  ) async {
    final bool shouldSave = switch (event.lifecycleState) {
      AppLifecycleState.paused => true,
      AppLifecycleState.inactive => true,
      AppLifecycleState.detached => true,
      _ => false,
    };

    if (shouldSave) {
      await _saveNote(
        emit,
      );
    }
  }

  Future<bool> _saveNote(
    Emitter<NoteEditorState> emit,
  ) async {
    final NoteEditorViewModel? vm = state.currentVm;

    if (vm == null) {
      printLog("save note - vm is null");

      if (emit.isDone) return false;
      emit(const NoteEditorState.creationFailed("note has not been created"));
      return false;
    }

    final NoteEditorViewModel newVm = NoteEditorViewModel(
      noteId: vm.noteId,
      title: _titleToBeSaved ?? '',
      body: _bodyToBeSaved ?? '',
      folderId: vm.folderId,
      tagIds: vm.tagIds,
    );
    if (emit.isDone) return false;
    emit(NoteEditorState.saving(newVm));

    final SaveNoteContentParams params = SaveNoteContentParams(
      noteId: newVm.noteId,
      title: newVm.title,
      body: newVm.body,
    );

    Result<Failure, Note> saveTitle = await _saveNoteContentUc.call(params);

    return saveTitle.when(
      failure: (fail) {
        final String reason = fail.message;
        printLog("save failed: $reason");
        if (emit.isDone) return false;
        emit(NoteEditorState.saveFailed(newVm, reason));
        return false;
      },
      success: (Note data) {
        final NoteEditorViewModel updatedVm = NoteEditorViewModel(
          noteId: data.id,
          title: data.title,
          body: data.body,
          folderId: data.folderId,
          tagIds: data.tagIds,
        );
        if (emit.isDone) return false;
        emit(NoteEditorState.saved(updatedVm));

        return true;
      },
    );
  }

  @override
  Future<void> close() {
    _lifecycleSubscription.cancel();
    _debounceThresholdRegistry.dispose();
    return super.close();
  }
}
