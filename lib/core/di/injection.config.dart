// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:knowledge_hub/features/notes/data/datasources/folders_data_source.dart'
    as _i794;
import 'package:knowledge_hub/features/notes/data/datasources/folders_local_data_source_impl.dart'
    as _i783;
import 'package:knowledge_hub/features/notes/data/datasources/notes_data_source.dart'
    as _i851;
import 'package:knowledge_hub/features/notes/data/datasources/notes_local_data_source_impl.dart'
    as _i456;
import 'package:knowledge_hub/features/notes/data/datasources/tags_data_source.dart'
    as _i782;
import 'package:knowledge_hub/features/notes/data/datasources/tags_local_data_source_impl.dart'
    as _i644;
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart'
    as _i573;
import 'package:knowledge_hub/features/notes/data/repositories/folders_repository_impl.dart'
    as _i505;
import 'package:knowledge_hub/features/notes/data/repositories/notes_repository_impl.dart'
    as _i11;
import 'package:knowledge_hub/features/notes/data/repositories/tags_repository_impl.dart'
    as _i914;
import 'package:knowledge_hub/features/notes/domain/repositories/folders_repository.dart'
    as _i925;
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart'
    as _i431;
import 'package:knowledge_hub/features/notes/domain/repositories/tags_repository.dart'
    as _i990;
import 'package:knowledge_hub/features/notes/domain/usecases/create_folder_uc.dart'
    as _i278;
import 'package:knowledge_hub/features/notes/domain/usecases/create_note_uc.dart'
    as _i751;
import 'package:knowledge_hub/features/notes/domain/usecases/create_tag_uc.dart'
    as _i668;
import 'package:knowledge_hub/features/notes/domain/usecases/delete_folder_uc.dart'
    as _i692;
import 'package:knowledge_hub/features/notes/domain/usecases/delete_tag_uc.dart'
    as _i686;
import 'package:knowledge_hub/features/notes/domain/usecases/move_note_to_trash_uc.dart'
    as _i614;
import 'package:knowledge_hub/features/notes/domain/usecases/permanently_delete_note_uc.dart'
    as _i112;
import 'package:knowledge_hub/features/notes/domain/usecases/purge_expired_trash_uc.dart'
    as _i799;
import 'package:knowledge_hub/features/notes/domain/usecases/restore_note_from_trash_uc.dart'
    as _i919;
import 'package:knowledge_hub/features/notes/domain/usecases/save_note_content_uc.dart'
    as _i904;
import 'package:knowledge_hub/features/notes/domain/usecases/watch_filtered_notes_uc.dart'
    as _i553;
import 'package:knowledge_hub/features/notes/domain/usecases/watch_folders_uc.dart'
    as _i854;
import 'package:knowledge_hub/features/notes/domain/usecases/watch_note_search_results_uc.dart'
    as _i370;
import 'package:knowledge_hub/features/notes/domain/usecases/watch_tags_uc.dart'
    as _i395;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i782.TagsDataSource>(
      () => _i644.TagsLocalDataSourceImpl(gh<_i573.NotesDatabase>()),
    );
    gh.lazySingleton<_i990.TagsRepository>(
      () => _i914.TagsRepositoryImpl(gh<_i782.TagsDataSource>()),
    );
    gh.lazySingleton<_i851.NotesDataSource>(
      () => _i456.NotesLocalDataSourceImpl(gh<_i573.NotesDatabase>()),
    );
    gh.lazySingleton<_i794.FoldersDataSource>(
      () => _i783.FoldersLocalDataSourceImpl(gh<_i573.NotesDatabase>()),
    );
    gh.lazySingleton<_i925.FoldersRepository>(
      () => _i505.FoldersRepositoryImpl(gh<_i794.FoldersDataSource>()),
    );
    gh.lazySingleton<_i278.CreateFolderUc>(
      () => _i278.CreateFolderUc(gh<_i925.FoldersRepository>()),
    );
    gh.lazySingleton<_i692.DeleteFolderUc>(
      () => _i692.DeleteFolderUc(gh<_i925.FoldersRepository>()),
    );
    gh.lazySingleton<_i854.WatchFoldersUc>(
      () => _i854.WatchFoldersUc(gh<_i925.FoldersRepository>()),
    );
    gh.lazySingleton<_i431.NotesRepository>(
      () => _i11.NotesRepositoryImpl(gh<_i851.NotesDataSource>()),
    );
    gh.lazySingleton<_i668.CreateTagUc>(
      () => _i668.CreateTagUc(gh<_i990.TagsRepository>()),
    );
    gh.lazySingleton<_i686.DeleteTagUc>(
      () => _i686.DeleteTagUc(gh<_i990.TagsRepository>()),
    );
    gh.lazySingleton<_i395.WatchTagsUc>(
      () => _i395.WatchTagsUc(gh<_i990.TagsRepository>()),
    );
    gh.lazySingleton<_i751.CreateNoteUc>(
      () => _i751.CreateNoteUc(gh<_i431.NotesRepository>()),
    );
    gh.lazySingleton<_i614.MoveNoteToTrashUc>(
      () => _i614.MoveNoteToTrashUc(gh<_i431.NotesRepository>()),
    );
    gh.lazySingleton<_i112.PermanentlyDeleteNoteUc>(
      () => _i112.PermanentlyDeleteNoteUc(gh<_i431.NotesRepository>()),
    );
    gh.lazySingleton<_i799.PurgeExpiredTrashUc>(
      () => _i799.PurgeExpiredTrashUc(gh<_i431.NotesRepository>()),
    );
    gh.lazySingleton<_i919.RestoreNoteFromTrashUc>(
      () => _i919.RestoreNoteFromTrashUc(gh<_i431.NotesRepository>()),
    );
    gh.lazySingleton<_i904.SaveNoteContentUc>(
      () => _i904.SaveNoteContentUc(gh<_i431.NotesRepository>()),
    );
    gh.lazySingleton<_i553.WatchFilteredNotesUc>(
      () => _i553.WatchFilteredNotesUc(gh<_i431.NotesRepository>()),
    );
    gh.lazySingleton<_i370.WatchNoteSearchResultsUc>(
      () => _i370.WatchNoteSearchResultsUc(gh<_i431.NotesRepository>()),
    );
    return this;
  }
}
