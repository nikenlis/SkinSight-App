import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/explore/domain/entities/detail_education_entity.dart';
import 'package:skinsight/features/explore/domain/repositories/explore_repository.dart';

class GetDetailEducationUsecase {
  final ExploreRepository repository;

  GetDetailEducationUsecase({required this.repository});
  Future<Either<Failures, DetailEducationEntity>> execute({required String articleLink}) {
    return repository.getDetailEducation(articleLink: articleLink);
  }
}