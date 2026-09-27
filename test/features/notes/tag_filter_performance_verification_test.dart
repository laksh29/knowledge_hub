import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/data/datasources/notes_local_data_source_impl.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart' hide Note;
import 'package:knowledge_hub/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_filtered_notes_uc.dart';

/// Task 7.3, Requirement 5.2. Search-latency measurement is deliberately
/// excluded — `NotesLocalDataSourceImpl.watchSearchResults` is still an
/// `UnimplementedError` stub (the same long-tracked gap blocking tasks
/// 5.2/7.1), so there is no working search implementation to measure yet.
/// Only tag-filter latency, which IS fully implemented, is verified here.
const int _noteCorpusSize = 10000;
const int _tagCorpusSize = 20;
const Duration _tagFilterLatencyBudget = Duration(milliseconds: 50);

void main() {
  late NotesDatabase database;
  late NotesRepository repository;
  late WatchFilteredNotesUc watchFilteredNotesUc;

  setUp(() async {
    database = NotesDatabase(NativeDatabase.memory());
    repository = NotesRepositoryImpl(NotesLocalDataSourceImpl(database));
    watchFilteredNotesUc = WatchFilteredNotesUc(repository);

    final DateTime seedTimestamp = DateTime.utc(2026, 1, 1);

    await database.batch((Batch batch) {
      batch.insertAll(
        database.tags,
        List<TagsCompanion>.generate(
          _tagCorpusSize,
          (int i) => TagsCompanion.insert(id: 'tag-$i', name: 'Tag $i'),
        ),
      );
      batch.insertAll(
        database.notes,
        List<NotesCompanion>.generate(
          _noteCorpusSize,
          (int i) => NotesCompanion.insert(
            id: 'note-$i',
            title: 'Note $i',
            body: 'Synthetic body for note $i',
            createdAt: seedTimestamp,
            updatedAt: seedTimestamp,
          ),
        ),
      );
    });

    // Every 5th note gets tag-0 (2,000 matches for an anyOf/allOf filter on
    // a single tag) plus one other tag, so tag assignment isn't perfectly
    // uniform -- closer to a realistic corpus than "every note has every tag".
    await database.batch((Batch batch) {
      final List<NoteTagsCompanion> associations = <NoteTagsCompanion>[];
      for (int i = 0; i < _noteCorpusSize; i++) {
        final String noteId = 'note-$i';
        if (i % 5 == 0) {
          associations.add(NoteTagsCompanion.insert(noteId: noteId, tagId: 'tag-0'));
        }
        // Shifted by 1 so this secondary assignment never collides with the
        // conditional tag-0 assignment above (which only ever lands on
        // tag-0 itself).
        final int secondaryTagIndex = ((i % _tagCorpusSize) + 1) % _tagCorpusSize;
        associations.add(NoteTagsCompanion.insert(noteId: noteId, tagId: 'tag-$secondaryTagIndex'));
      }
      batch.insertAll(database.noteTags, associations);
    });
  });

  tearDown(() async {
    await database.close();
  });

  group('Tag-filter performance against a 10,000-note corpus', () {
    test(
      'filtering by a single tag stays at or under the 50ms latency budget',
      timeout: const Timeout(Duration(seconds: 30)),
      () async {
        final Stopwatch stopwatch = Stopwatch()..start();
        final Result<Failure, List<Note>> result = await watchFilteredNotesUc(
          const NoteListFilterParams(tagIds: <String>['tag-0'], tagFilterMode: TagFilterMode.anyOf),
        ).first;
        stopwatch.stop();

        expect(result, isA<Ok<Failure, List<Note>>>());
        final List<Note> matches = (result as Ok<Failure, List<Note>>).value;
        expect(matches, isNotEmpty, reason: 'sanity check -- tag-0 was actually assigned to some notes');

        expect(
          stopwatch.elapsed,
          lessThanOrEqualTo(_tagFilterLatencyBudget),
          reason:
              'Requirement 5.2 budgets tag-filter updates at 50ms across the '
              'full corpus; measured ${stopwatch.elapsedMilliseconds}ms',
        );
      },
    );

    test(
      'filtering by multiple tags in allOf mode stays at or under the 50ms latency budget',
      timeout: const Timeout(Duration(seconds: 30)),
      () async {
        final Stopwatch stopwatch = Stopwatch()..start();
        final Result<Failure, List<Note>> result = await watchFilteredNotesUc(
          const NoteListFilterParams(
            tagIds: <String>['tag-0', 'tag-5'],
            tagFilterMode: TagFilterMode.allOf,
          ),
        ).first;
        stopwatch.stop();

        expect(result, isA<Ok<Failure, List<Note>>>());
        expect(
          stopwatch.elapsed,
          lessThanOrEqualTo(_tagFilterLatencyBudget),
          reason:
              'Requirement 5.2 budgets tag-filter updates at 50ms across the '
              'full corpus; measured ${stopwatch.elapsedMilliseconds}ms',
        );
      },
    );
  });
}
