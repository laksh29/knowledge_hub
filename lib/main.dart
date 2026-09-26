import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/di/injection.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_folder_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_tag_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/delete_folder_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/delete_tag_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_filtered_notes_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_folders_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_note_search_results_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_tags_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/search/search_bloc.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/folder/folder_cubit.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/note_list/note_list_cubit.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/tag/tag_cubit.dart';
import 'package:knowledge_hub/features/notes/presentation/pages/note_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const KnowledgeHubApp());
}

/// App root (task 6.2). Provides the four presentation-layer Blocs/Cubits
/// whose lifecycle spans the whole app — `NoteListCubit`, `SearchBloc`,
/// `FolderCubit`, `TagCubit` — at the same level as `NoteListPage` (`home`),
/// each constructed via `getIt<UseCase>()` calls rather than registered in
/// `get_it` itself, per the guide's Bloc/Cubit convention. `NoteEditorBloc`
/// and `TrashCubit` are deliberately NOT provided here — their lifecycle is
/// scoped to a single pushed page, so they are constructed at the
/// `Navigator.push` call site instead (see `note_list_page.dart`).
class KnowledgeHubApp extends StatelessWidget {
  const KnowledgeHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteListCubit>(
          create: (_) => NoteListCubit(watchFilteredNotesUc: getIt<WatchFilteredNotesUc>()),
        ),
        BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(watchNoteSearchResultsUc: getIt<WatchNoteSearchResultsUc>()),
        ),
        BlocProvider<FolderCubit>(
          create: (_) => FolderCubit(
            createFolderUc: getIt<CreateFolderUc>(),
            watchFoldersUc: getIt<WatchFoldersUc>(),
            deleteFolderUc: getIt<DeleteFolderUc>(),
          ),
        ),
        BlocProvider<TagCubit>(
          create: (_) => TagCubit(
            createTagUc: getIt<CreateTagUc>(),
            watchTagsUc: getIt<WatchTagsUc>(),
            deleteTagUc: getIt<DeleteTagUc>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Knowledge Hub',
        theme: ThemeData(scaffoldBackgroundColor: KnowledgeHubColors.canvas),
        home: const NoteListPage(),
      ),
    );
  }
}
