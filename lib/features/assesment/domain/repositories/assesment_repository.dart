
import 'package:dartz/dartz.dart';
import 'package:skinsight/features/assesment/domain/entities/assesment_entity.dart';

import '../../../../core/error/failures.dart';
import '../entities/assesment_form_entity.dart';


abstract class AssesmentRepository {
  Future<Either<Failures, AssesmentEntity>> getAssesment(AssesmentFormEntity data);
}
