import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class RequestNewOtpUsecase {
  final AuthRepository repository;

  RequestNewOtpUsecase({required this.repository});
  Future<Either<Failures, String>> execute() {
    return repository.requestNewOtp();
  }
}