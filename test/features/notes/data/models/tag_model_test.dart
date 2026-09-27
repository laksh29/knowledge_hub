import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart' as db;
import 'package:knowledge_hub/features/notes/data/models/tag_model.dart';
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';

void main() {
  group('TagModel.fromDriftRow', () {
    test('maps every Drift row column onto the model unchanged', () {
      const db.Tag row = db.Tag(id: 'tag-1', name: 'errands');

      final TagModel model = TagModel.fromDriftRow(row);

      expect(model.id, 'tag-1');
      expect(model.name, 'errands');
    });
  });

  group('TagModel.toCompanion', () {
    test('carries every field as an explicit, present Value', () {
      const TagModel model = TagModel(id: 'tag-1', name: 'errands');

      final db.TagsCompanion companion = model.toCompanion();

      expect(companion.id, const Value('tag-1'));
      expect(companion.name, const Value('errands'));
    });
  });

  group('TagModel.toEntity', () {
    test('converts to the domain Tag entity', () {
      const TagModel model = TagModel(id: 'tag-1', name: 'errands');

      final Tag entity = model.toEntity();

      expect(entity.id, model.id);
      expect(entity.name, model.name);
    });
  });
}
