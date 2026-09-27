import 'package:injectable/injectable.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/usecase/usecase.dart';
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/tags_repository.dart';

@LazySingleton()
class CreateTagUc implements UseCase<Tag, String> {
  const CreateTagUc(this._tagsRepository);
  final TagsRepository _tagsRepository;

  @override
  Future<Result<Failure, Tag>> call(String name) =>
      _tagsRepository.createTag(name);
}
