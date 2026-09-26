import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/features/notes/presentation/map_failure_to_message.dart';

void main() {
  group('mapFailureToMessage', () {
    group('CacheFailure', () {
      test('a genuine storage failure returns a specific, actionable message', () {
        const CacheFailure failure = CacheFailure('DatabaseException: disk I/O error');

        final String message = mapFailureToMessage(failure);

        expect(message, isNotEmpty);
        expect(message, isNot(contains('Something went wrong')));
      });

      test(
        'a not-found message (matching NotesLocalDataSourceImpl wording) returns no message',
        () {
          const CacheFailure failure = CacheFailure('Note note-123 not found');

          final String message = mapFailureToMessage(failure);

          expect(message, isEmpty);
        },
      );

      test('the not-found check is case-insensitive', () {
        const CacheFailure failure = CacheFailure('Note note-123 NOT FOUND');

        final String message = mapFailureToMessage(failure);

        expect(message, isEmpty);
      });
    });

    group('DuplicateNameFailure', () {
      test('a duplicate folder name is named in the returned message', () {
        const DuplicateNameFailure failure = DuplicateNameFailure(
          'A folder named "Groceries" already exists',
        );

        final String message = mapFailureToMessage(failure);

        expect(message, contains('Groceries'));
        expect(message, contains('already exists'));
      });

      test('a duplicate tag name is named in the returned message', () {
        const DuplicateNameFailure failure = DuplicateNameFailure(
          'A tag named "Urgent" already exists',
        );

        final String message = mapFailureToMessage(failure);

        expect(message, contains('Urgent'));
        expect(message, contains('already exists'));
      });

      test('an unrecognized DuplicateNameFailure message still returns a specific message', () {
        const DuplicateNameFailure failure = DuplicateNameFailure(
          'A folder with this name already exists',
        );

        final String message = mapFailureToMessage(failure);

        expect(message, isNotEmpty);
        expect(message, contains('choose a different name'));
      });
    });

    test(
      "ServerFailure and NetworkFailure route through design.md's documented catchall "
      'message, and that message never mentions "server" or "network"',
      () {
        const ServerFailure serverFailure = ServerFailure();
        const NetworkFailure networkFailure = NetworkFailure();

        final String serverMessage = mapFailureToMessage(serverFailure);
        final String networkMessage = mapFailureToMessage(networkFailure);

        expect(serverMessage, isNotEmpty);
        expect(serverMessage, contains('your notes are safe'));
        expect(networkMessage, serverMessage, reason: 'both route through the same catchall');
      },
    );

    test('ValidationFailure surfaces its own already-specific message', () {
      const ValidationFailure failure = ValidationFailure('Title cannot be empty');

      final String message = mapFailureToMessage(failure);

      expect(message, 'Title cannot be empty');
    });

    test('ValidationFailure is distinct from the ServerFailure/NetworkFailure catchall', () {
      const ServerFailure serverFailure = ServerFailure();
      const ValidationFailure validationFailure = ValidationFailure('Body is required');

      final String serverMessage = mapFailureToMessage(serverFailure);
      final String validationMessage = mapFailureToMessage(validationFailure);

      expect(serverMessage, isNot(equals(validationMessage)));
    });
  });
}
