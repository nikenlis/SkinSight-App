import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/profile/domain/repositories/profile_repository.dart';

class ChangePasswordProfileUsecase {
  final ProfileRepository repository;

  ChangePasswordProfileUsecase({required this.repository});
  Future<Either<Failures, String>> execute({required String? currentPassword, required String newPassword, required String confirmPassword}){
    return repository.changePasswordProfile(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword);
  }
}