import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';

@freezed
abstract class Note with _$Note {
  const Note._();

  const factory Note({
    required String id,
    required String title,
    required String body,
    String? folderId,
    @Default(<String>[]) List<String> tagIds,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Note;

  bool get isTrashed => deletedAt != null;

  bool get isUnfiled => folderId == null;
}
