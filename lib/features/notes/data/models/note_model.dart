import 'package:drift/drift.dart' show Value;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart' as db;
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';

part 'note_model.freezed.dart';

@freezed
abstract class NoteModel with _$NoteModel {
  const NoteModel._();

  const factory NoteModel({
    required String id,
    required String title,
    required String body,
    String? folderId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _NoteModel;

  factory NoteModel.fromDriftRow(db.Note row) => NoteModel(
    id: row.id,
    title: row.title,
    body: row.body,
    folderId: row.folderId,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
  );

  db.NotesCompanion toCompanion() => db.NotesCompanion(
    id: Value(id),
    title: Value(title),
    body: Value(body),
    folderId: Value(folderId),
    createdAt: Value(createdAt),
    updatedAt: Value(updatedAt),
    deletedAt: Value(deletedAt),
  );

  Note toEntity({required List<String> tagIds}) => Note(
    id: id,
    title: title,
    body: body,
    folderId: folderId,
    tagIds: tagIds,
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
  );
}
