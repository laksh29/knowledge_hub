import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';

part 'note_search_result.freezed.dart';

@freezed
abstract class NoteSearchResult with _$NoteSearchResult {
  const factory NoteSearchResult({
    required Note note,
    required String highlightedTitleSnippet,
    required String highlightedBodySnippet,
  }) = _NoteSearchResult;
}
