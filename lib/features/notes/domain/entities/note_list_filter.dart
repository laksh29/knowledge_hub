import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_list_filter.freezed.dart';

enum TagFilterMode { anyOf, allOf }

enum NoteLifecycleScope { active, trash }

@freezed
abstract class NoteListFilterParams with _$NoteListFilterParams {
  const factory NoteListFilterParams({
    String? folderId,
    @Default(<String>[]) List<String> tagIds,
    @Default(TagFilterMode.anyOf) TagFilterMode tagFilterMode,
    @Default(NoteLifecycleScope.active) NoteLifecycleScope lifecycleScope,
  }) = _NoteListFilterParams;
}
