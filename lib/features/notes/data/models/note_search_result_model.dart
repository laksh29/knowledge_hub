import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/data/models/note_model.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_search_result.dart';

part 'note_search_result_model.freezed.dart';

/// Data-layer counterpart of [NoteSearchResult] — wraps a [NoteModel] plus
/// the two FTS5 `highlight()`-marked-up snippet strings a search query
/// produces. Mechanical mapping only; the actual FTS5 query that produces
/// these values is `NotesDataSource.watchSearchResults`'s job (a
/// USER-IMPLEMENT stub — see notes-mvp tasks.md task 2.6).
@freezed
abstract class NoteSearchResultModel with _$NoteSearchResultModel {
  const NoteSearchResultModel._();

  const factory NoteSearchResultModel({
    required NoteModel note,
    required String highlightedTitleSnippet,
    required String highlightedBodySnippet,
  }) = _NoteSearchResultModel;

  NoteSearchResult toEntity({required List<String> tagIds}) => NoteSearchResult(
    note: note.toEntity(tagIds: tagIds),
    highlightedTitleSnippet: highlightedTitleSnippet,
    highlightedBodySnippet: highlightedBodySnippet,
  );
}
