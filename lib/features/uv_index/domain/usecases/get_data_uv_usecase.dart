import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/uv_index/domain/entities/uv_entity.dart';
import 'package:skinsight/features/uv_index/domain/repositories/uv_repository.dart';

class GetDataUvUsecase {
  final UvRepository repository;

  GetDataUvUsecase({required this.repository});

  Future<Either<Failures, UviDataEntity>> execute({required double latitude, required double longitude }){
    return repository.getDataUv(latitude: latitude, longitude: longitude);
  }
}