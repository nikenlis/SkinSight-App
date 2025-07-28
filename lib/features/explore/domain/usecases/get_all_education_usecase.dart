import 'package:dartz/dartz.dart';
import 'package:skinsight/features/explore/domain/repositories/explore_repository.dart';
import '../../../../core/error/failures.dart';
import '../entities/education_entity.dart';


class GetAllEducationUsecase {
  final ExploreRepository repository;

  GetAllEducationUsecase({required this.repository});
  Future<Either<Failures, PagignationEducationEntity>> execute(int? page,  {required String? nextPage, required String? prevPage}) {
    return repository.getAllEducation(page, nextPage: nextPage, prevPage: prevPage);
  }
}