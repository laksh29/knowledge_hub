import 'package:drift/drift.dart' show Value;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart' as db;
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';

part 'tag_model.freezed.dart';

@freezed
abstract class TagModel with _$TagModel {
  const TagModel._();

  const factory TagModel({required String id, required String name}) = _TagModel;

  factory TagModel.fromDriftRow(db.Tag row) => TagModel(id: row.id, name: row.name);

  db.TagsCompanion toCompanion() => db.TagsCompanion(id: Value(id), name: Value(name));

  Tag toEntity() => Tag(id: id, name: name);
}
