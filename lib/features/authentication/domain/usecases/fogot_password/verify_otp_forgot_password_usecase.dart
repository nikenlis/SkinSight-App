import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';

import '../../entities/verify_otp_forgot_password_entity.dart';
import '../../repositories/auth_repository.dart';

class VerifyOtpForgotPasswordUsecase {
  final AuthRepository repository;

  VerifyOtpForgotPasswordUsecase({required this.repository});

  Future<Either<Failures, VerifyOtpForgotPasswordEntity>> execute({required String email, required String otp}){
    return repository.verifyOtpForgotPassword(email: email, otp: otp);
  }
}