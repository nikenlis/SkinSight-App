import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class CheckCredentialUsecase {
  final AuthRepository repository;

  CheckCredentialUsecase({required this.repository});
  Future<Either<Failures, String>> execute() {
    return repository.checkCredential();
  }
}