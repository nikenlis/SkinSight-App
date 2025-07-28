import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/explore/domain/entities/news_entity.dart';
import '../entities/detail_education_entity.dart';
import '../entities/detail_news_entity.dart';
import '../entities/education_entity.dart';

abstract class ExploreRepository {
Future<Either<Failures, List<NewsEntity>>> getAllNews(int? page);
Future<Either<Failures, PagignationEducationEntity>> getAllEducation(int? page, {required String? nextPage, required String? prevPage});
Future<Either<Failures, DetailNewsEntity>> getDetailNews({required String articleLink});
Future<Either<Failures, DetailEducationEntity>> getDetailEducation({required String articleLink});
}