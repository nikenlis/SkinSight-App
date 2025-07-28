import 'package:dartz/dartz.dart';
import 'package:skinsight/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_entity.dart';

class GetSignupUsecase {
  final AuthRepository repository;

  GetSignupUsecase({required this.repository});

  Future<Either<Failures, AuthEntity>> execute({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return repository.signUp(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword);
  }
}
