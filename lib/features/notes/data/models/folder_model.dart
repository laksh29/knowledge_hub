import 'package:drift/drift.dart' show Value;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart' as db;
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';

part 'folder_model.freezed.dart';

@freezed
abstract class FolderModel with _$FolderModel {
  const FolderModel._();

  const factory FolderModel({required String id, required String name}) = _FolderModel;

  factory FolderModel.fromDriftRow(db.Folder row) => FolderModel(id: row.id, name: row.name);

  db.FoldersCompanion toCompanion() => db.FoldersCompanion(id: Value(id), name: Value(name));

  Folder toEntity() => Folder(id: id, name: name);
}
