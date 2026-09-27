import 'dart:io';

import 'package:app_lifecycle_service/app_lifecycle_service.dart';
import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_wal_fts_toolkit/sqlite_wal_fts_toolkit.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

const String _notesDatabaseFileName = 'notes.sqlite';

/// Configures the app's dependency-injection container.
///
/// `NotesDatabase` needs an already-resolved `QueryExecutor`, which in turn
/// needs the app documents directory path from `path_provider` -- an async
/// call that must complete before `NotesDatabase`'s synchronous constructor
/// can run. Rather than fighting `injectable`'s `@preResolve` codegen for
/// this single case, this function resolves that path itself and registers
/// `NotesDatabase` manually with the already-built executor captured in the
/// closure, alongside the other manual `AppLifecycleService` registration
/// (its implementation carries no DI annotations of its own). Every other
/// dependency (data sources, repositories, use cases) is auto-registered by
/// `getIt.init()`, generated from the `@LazySingleton` annotations on their
/// declaration sites.
@InjectableInit()
Future<void> configureDependencies() async {
  await _registerNotesDatabase();
  getIt.registerLazySingleton<AppLifecycleService>(
    () => AppLifecycleServiceImpl(),
  );
  getIt.init();
}

Future<void> _registerNotesDatabase() async {
  final Directory documentsDirectory = await getApplicationDocumentsDirectory();
  final String databaseFilePath = path.join(
    documentsDirectory.path,
    _notesDatabaseFileName,
  );
  final QueryExecutor executor = await openWalModeSqliteDatabase(
    fileName: databaseFilePath,
  );
  getIt.registerLazySingleton<NotesDatabase>(() => NotesDatabase(executor));
}
