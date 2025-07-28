import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/authentication/domain/repositories/auth_repository.dart';


class RequestNewOtpForgotPasswordUsecase {
  final AuthRepository repository;

  RequestNewOtpForgotPasswordUsecase({required this.repository});
  Future<Either<Failures, String>> execute({required String email}) {
    return repository.requestNewOtpForgotPassword(email: email);
  }
}