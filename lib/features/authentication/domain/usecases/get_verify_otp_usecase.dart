import 'package:dartz/dartz.dart';
import 'package:skinsight/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_verify_otp_entity.dart';

class GetVerifyOtpUsecase {
  final AuthRepository repository;

  GetVerifyOtpUsecase({required this.repository});
  Future<Either<Failures, AuthVerifyOtpEntity>> execute ({required String otp}) {
    return repository.verifyOtp(otp: otp);
  }
}