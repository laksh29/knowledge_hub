import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';

part 'trashed_note_view_model.freezed.dart';

/// Mirrors `NotesRepositoryImpl`'s own trash-retention window
/// (`lib/features/notes/data/repositories/notes_repository_impl.dart`,
/// currently a `USER-IMPLEMENT` stub hardcoding `Duration(days: 30)`) and
/// Requirement 7.4 ("When a note has remained in Trash for 30 days... shall
/// permanently delete that note"). design.md calls the 30-day figure "a
/// domain constant" (§"NotesRepository" Responsibilities & Constraints) but
/// does not name or locate an actual shared constant anywhere in the
/// codebase today — this presentation-layer label is purely informational
/// (it does not gate or trigger the purge itself, which stays
/// repository/bootstrap-owned per that same note), so it mirrors the figure
/// locally with this explicit citation rather than reaching into the data
/// layer to import a constant that doesn't exist.
const int _trashRetentionDays = 30;

/// Presentation-ready shape for a single trashed-note row. Carries only the
/// fields a `TrashPage` list row needs to render — the domain [Note] entity
/// never leaks through this ViewModel's public shape (mirrors
/// `TagViewModel`/`FolderViewModel`'s convention).
///
/// Uses a private constructor (`TrashedNoteViewModel._()`) so the computed
/// [daysRemainingLabel] getter below can be declared directly on the
/// `@freezed` class, matching the `Note`/`TagState` pattern elsewhere in
/// this codebase (freezed's own "Getters require a MyClass._() constructor"
/// requirement).
@freezed
abstract class TrashedNoteViewModel with _$TrashedNoteViewModel {
  const TrashedNoteViewModel._();

  const factory TrashedNoteViewModel({
    required String noteId,
    required String title,
    required DateTime deletedAt,
  }) = _TrashedNoteViewModel;

  /// A trashed note's `deletedAt` is non-null by definition (`Note.isTrashed
  /// == (deletedAt != null)`) — this factory is only ever fed notes read
  /// back from `WatchFilteredNotesUc(lifecycleScope: trash)`, which the
  /// repository already filters to trashed notes only. If `deletedAt` is
  /// somehow null anyway (a data-layer invariant violation rather than
  /// anything this presentation-layer ViewModel should silently mask),
  /// falling back to `DateTime.now()` is the safest defensive choice: it
  /// renders as "full window remaining" rather than crashing the trash list
  /// or fabricating a stale/negative days-remaining count.
  factory TrashedNoteViewModel.fromNote(Note note) => TrashedNoteViewModel(
    noteId: note.id,
    title: note.title,
    deletedAt: note.deletedAt ?? DateTime.now(),
  );

  /// "N days remaining" / "1 day remaining" / "Expires today" derived from
  /// [deletedAt] plus the [_trashRetentionDays]-day retention window
  /// (Requirement 7.4). Clamped at zero so a note past its window (a purge
  /// race the bootstrap-owned `PurgeExpiredTrashUc` hasn't caught up to yet)
  /// reads as "Expires today" rather than a confusing negative count.
  String get daysRemainingLabel {
    final DateTime expiresAt = deletedAt.add(const Duration(days: _trashRetentionDays));
    // Calendar-date difference, not a raw `Duration.inDays` between two
    // instants -- the latter truncates toward zero, so a note trashed
    // "5 days ago" would read as "24 days remaining" rather than "25"
    // whenever the wall clock has drifted even a few milliseconds past the
    // exact 5-day mark between `deletedAt` being recorded and this getter
    // being evaluated. Comparing date-only components keeps the label
    // stable for the whole calendar day, matching how a user reads "N days
    // remaining" (a day-granularity count, not an hour-granularity one).
    final DateTime today = DateTime.now();
    final DateTime expiresOnDate = DateTime(expiresAt.year, expiresAt.month, expiresAt.day);
    final DateTime todayDate = DateTime(today.year, today.month, today.day);
    final int daysRemaining = expiresOnDate.difference(todayDate).inDays;
    if (daysRemaining <= 0) {
      return 'Expires today';
    }
    if (daysRemaining == 1) {
      return '1 day remaining';
    }
    return '$daysRemaining days remaining';
  }
}
