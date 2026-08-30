import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_editor_event.freezed.dart';

/// The four independent triggers [NoteEditorBloc] must converge onto the
/// same save path (design.md §"NoteEditorBloc"):
/// - [NoteEditorTitleChanged] / [NoteEditorBodyChanged] carry both the
///   300ms-idle-debounce trigger and the 100-character-threshold trigger —
///   the debounce is a transformer concern on the event handler, the
///   char-count bypass is a synchronous check inside the handler body, not
///   a separate event.
/// - [NoteEditorAppLifecycleChanged] is dispatched internally by the Bloc's
///   subscription to `AppLifecycleService.lifecycleChanges` (constructor
///   injection, never `BuildContext`) — the Bloc bridges the external
///   stream into its own event pipeline so a lifecycle transition is
///   processed exactly like any other trigger, not via a side-channel.
/// - [NoteEditorManualSaveRequested] is the explicit user action.
@freezed
sealed class NoteEditorEvent with _$NoteEditorEvent {
  /// Starts the editor for a brand-new note. [NoteEditorBloc] is expected to
  /// call `CreateNoteUc` and transition `NoteEditorInitializing()` ->
  /// `NoteEditorNotSaved(...)`.
  const factory NoteEditorEvent.started() = NoteEditorStarted;

  const factory NoteEditorEvent.titleChanged(String title) = NoteEditorTitleChanged;

  const factory NoteEditorEvent.bodyChanged(String body) = NoteEditorBodyChanged;

  const factory NoteEditorEvent.manualSaveRequested() = NoteEditorManualSaveRequested;

  const factory NoteEditorEvent.appLifecycleChanged(AppLifecycleState lifecycleState) =
      NoteEditorAppLifecycleChanged;
}
