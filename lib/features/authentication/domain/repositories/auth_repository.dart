import 'package:skinsight/features/authentication/domain/entities/auth_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_verify_otp_entity.dart';
import '../entities/verify_otp_forgot_password_entity.dart';

abstract class AuthRepository {
  Future<Either<Failures, AuthEntity>> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword
  });

  Future<Either<Failures, AuthEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failures, String>> checkCredential();
  Future<Either<Failures, AuthVerifyOtpEntity>> verifyOtp({required String otp});
  Future<Either<Failures, String>> requestNewOtp();
  Future<Either<Failures, String>> generateOtpForgotPassword({required String email});
  Future<Either<Failures, VerifyOtpForgotPasswordEntity>> verifyOtpForgotPassword({required String email, required String otp});
  Future<Either<Failures, String>> requestNewOtpForgotPassword({required String email});
  Future<Either<Failures, String>> resetPasswordForgotPassword({required String token, required String newPassword, required String confirmPassword,});
  Future<Either<Failures, Unit>> logout();
}

