import 'package:injectable/injectable.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/usecase/usecase.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/tags_repository.dart';

@LazySingleton()
class DeleteTagUc implements UseCase<void, String> {
  const DeleteTagUc(this._tagsRepository);
  final TagsRepository _tagsRepository;

  @override
  Future<Result<Failure, void>> call(String tagId) =>
      _tagsRepository.deleteTag(tagId);
}
