import 'package:dartz/dartz.dart';
import 'package:skinsight/features/assesment/domain/entities/assesment_entity.dart';
import 'package:skinsight/features/assesment/domain/repositories/assesment_repository.dart';

import '../../../../core/error/failures.dart';
import '../entities/assesment_form_entity.dart';


class GetAssesmentUsecase {
  final AssesmentRepository repository;

  GetAssesmentUsecase({required this.repository});

  Future<Either<Failures, AssesmentEntity>> execute(AssesmentFormEntity data) {
    return repository.getAssesment(data);
  }
}
