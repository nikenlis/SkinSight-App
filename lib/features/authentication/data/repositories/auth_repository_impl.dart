import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:skinsight/core/error/failures.dart';

import 'package:skinsight/features/authentication/domain/entities/auth_entity.dart';
import 'package:skinsight/features/authentication/domain/entities/auth_verify_otp_entity.dart';
import 'package:skinsight/features/authentication/domain/entities/verify_otp_forgot_password_entity.dart';

import '../../../../core/common/network_info.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final AuthLocalDatasource localDatasource;
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(
      {required this.networkInfo,
      required this.localDatasource,
      required this.remoteDatasource});

  @override
  Future<Either<Failures, AuthEntity>> signIn(
      {required String email, required String password}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.signIn(email: email, password: password);
        await localDatasource.cachedToken(response.token);
        await localDatasource
            .cachedAssesmentStatus(response.isAssessmentCompleted);
        await localDatasource.cachedVerifyOtpStatus(response.isVerified);
        return Right(response.toEntity());
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message ?? 'Waktu permintaan habis.'));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on SocketException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failures, AuthEntity>> signUp(
      {required String name,
      required String email,
      required String password,
      required String confirmPassword}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response = await remoteDatasource.signUp(
            name: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword);
        await localDatasource.cachedToken(response.token);
        await localDatasource
            .cachedAssesmentStatus(response.isAssessmentCompleted);
        await localDatasource.cachedVerifyOtpStatus(response.isVerified);
        return Right(response.toEntity());
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message ?? 'Waktu permintaan habis.'));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on SocketException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failures, String>> checkCredential() async {
    try {
      final token = await localDatasource.getToken();
      return Right(token);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    } catch (e) {
      return const Left(ServerFailure('Terjadi kesalahan'));
    }
  }

  @override
  Future<Either<Failures, AuthVerifyOtpEntity>> verifyOtp(
      {required String otp}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response = await remoteDatasource.verifyOtp(otp: otp);
        await localDatasource.cachedVerifyOtpStatus(response.isValid);
        return Right(response.toEntity());
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message ?? 'Waktu permintaan habis.'));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on SocketException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failures, String>> requestNewOtp() async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response = await remoteDatasource.requestNewOtp();
        return Right(response);
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message ?? 'Waktu permintaan habis.'));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on SocketException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failures, Unit>> logout() async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        await remoteDatasource.logout();
        await localDatasource.removeToken();

        return Right(unit);
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message ?? 'Waktu permintaan habis.'));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on SocketException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failures, String>> generateOtpForgotPassword(
      {required String email}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.generateOtpForgotPassword(email: email);
        return Right(response);
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message ?? 'Waktu permintaan habis.'));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on SocketException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failures, VerifyOtpForgotPasswordEntity>> verifyOtpForgotPassword({required String email, required String otp}) async {
   bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.verifyOtpForgotPassword(email: email, otp: otp);
        return Right(response.toEntity());
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message ?? 'Waktu permintaan habis.'));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on SocketException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }
  
  @override
  Future<Either<Failures, String>> resetPasswordForgotPassword({required String token, required String newPassword, required String confirmPassword}) async {
   bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.resetPasswordForgotPassword(token: token, newPassword: newPassword, confirmPassword: confirmPassword);
        return Right(response);
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message ?? 'Waktu permintaan habis.'));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on SocketException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }
  
  @override
  Future<Either<Failures, String>> requestNewOtpForgotPassword({required String email}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response = await remoteDatasource.requestNewOtpForgotPassword(email: email);
        return Right(response);
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message ?? 'Waktu permintaan habis.'));
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on SocketException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnexpectedFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }
}
