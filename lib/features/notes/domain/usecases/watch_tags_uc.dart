import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/usecase/usecase.dart';
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/tags_repository.dart';

class WatchTagsUc implements StreamUseCaseNoParams<List<Tag>> {
  const WatchTagsUc(this._tagsRepository);
  final TagsRepository _tagsRepository;

  @override
  Stream<Result<Failure, List<Tag>>> call() => _tagsRepository.watchTags();
}
