import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/uv_index/domain/entities/uv_entity.dart';

abstract class UvRepository {
  Future<Either<Failures, UviDataEntity>> getDataUv({required double latitude, required double longitude });
}