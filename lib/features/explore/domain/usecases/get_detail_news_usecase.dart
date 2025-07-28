import 'package:dartz/dartz.dart';
import 'package:skinsight/features/explore/domain/entities/detail_news_entity.dart';
import 'package:skinsight/features/explore/domain/repositories/explore_repository.dart';

import '../../../../core/error/failures.dart';

class GetDetailNewsUsecase {
  final ExploreRepository repository;

  GetDetailNewsUsecase({required this.repository});

  Future<Either<Failures, DetailNewsEntity>> execute({required String articleLink}) {
    return repository.getDetailNews(articleLink: articleLink);
  }

}