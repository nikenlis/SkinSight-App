import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/profile/domain/repositories/profile_repository.dart';

import '../entities/profile_entity.dart';

class GetProfileUsecase {
  final ProfileRepository repository;

  GetProfileUsecase({required this.repository});

  Future<Either<Failures, ProfileEntity>> execute(){
    return repository.getProfile();
  }
}