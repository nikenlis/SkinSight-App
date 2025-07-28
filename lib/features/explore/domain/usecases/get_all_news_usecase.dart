import 'package:dartz/dartz.dart';
import 'package:skinsight/features/explore/domain/repositories/explore_repository.dart';

import '../../../../core/error/failures.dart';
import '../entities/news_entity.dart';

class GetAllNewsUsecase {
  final ExploreRepository repository;

  GetAllNewsUsecase({required this.repository});

  Future<Either<Failures, List<NewsEntity>>> execute(int? page) {
    return repository.getAllNews(page);
  }

}