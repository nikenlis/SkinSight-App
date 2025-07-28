import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/authentication/domain/repositories/auth_repository.dart';

class GenerateOtpForgotPasswordUsecase {
  final AuthRepository repository;

  GenerateOtpForgotPasswordUsecase({required this.repository});

  Future<Either<Failures, String>> execute({required String email}){
    return repository.generateOtpForgotPassword(email: email);
  }
}