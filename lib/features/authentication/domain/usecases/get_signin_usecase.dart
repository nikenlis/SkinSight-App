import 'package:dartz/dartz.dart';
import 'package:skinsight/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_entity.dart';

class GetSigninUsecase {
  final AuthRepository repository;

  GetSigninUsecase({required this.repository});

  Future<Either<Failures, AuthEntity>> execute({
    required String email,
    required String password,
  }) {
    return repository.signIn(email: email, password: password);
  }
}
