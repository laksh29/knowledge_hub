import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart' as db;
import 'package:knowledge_hub/features/notes/data/models/folder_model.dart';
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';

void main() {
  group('FolderModel.fromDriftRow', () {
    test('maps every Drift row column onto the model unchanged', () {
      const db.Folder row = db.Folder(id: 'folder-1', name: 'Work');

      final FolderModel model = FolderModel.fromDriftRow(row);

      expect(model.id, 'folder-1');
      expect(model.name, 'Work');
    });
  });

  group('FolderModel.toCompanion', () {
    test('carries every field as an explicit, present Value', () {
      const FolderModel model = FolderModel(id: 'folder-1', name: 'Work');

      final db.FoldersCompanion companion = model.toCompanion();

      expect(companion.id, const Value('folder-1'));
      expect(companion.name, const Value('Work'));
    });
  });

  group('FolderModel.toEntity', () {
    test('converts to the domain Folder entity', () {
      const FolderModel model = FolderModel(id: 'folder-1', name: 'Work');

      final Folder entity = model.toEntity();

      expect(entity.id, model.id);
      expect(entity.name, model.name);
    });
  });
}
