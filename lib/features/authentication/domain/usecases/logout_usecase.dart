import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase({required this.repository});

  Future<Either<Failures, Unit>> execute() {
    return repository.logout();
  }
}