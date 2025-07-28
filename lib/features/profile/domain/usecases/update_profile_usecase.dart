import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/profile/domain/repositories/profile_repository.dart';

import '../entities/profile_entity.dart';

class UpdateProfileUsecase {
  final ProfileRepository repository;

  UpdateProfileUsecase({required this.repository});

  Future<Either<Failures, ProfileEntity>> execute({String? fullName, File? profilePicture}) {
    return repository.updateProfile(fullName: fullName, profilePicture: profilePicture);
  }
}