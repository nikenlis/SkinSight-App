import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';

import '../../repositories/auth_repository.dart';

class ResetPasswordForgotPasswordUsecase {
  final AuthRepository repository;

  ResetPasswordForgotPasswordUsecase({required this.repository});
  Future<Either<Failures, String>> execute({required String token, required String newPassword, required String confirmPassword,}){
    return repository.resetPasswordForgotPassword(token: token, newPassword: newPassword, confirmPassword: confirmPassword);
  }
}