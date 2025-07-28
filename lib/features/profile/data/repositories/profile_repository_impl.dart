import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/profile/domain/entities/profile_entity.dart';
import 'package:skinsight/features/profile/domain/repositories/profile_repository.dart';

import '../../../../core/common/network_info.dart';
import '../../../../core/error/exceptions.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository{
  final NetworkInfo networkInfo;
    final ProfileRemoteDatasource remoteDatasource;

  ProfileRepositoryImpl({required this.networkInfo, required this.remoteDatasource});
  @override
  Future<Either<Failures, ProfileEntity>> getProfile() async {
     bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getProfile();
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
  Future<Either<Failures, ProfileEntity>> updateProfile({String? fullName, File? profilePicture}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.updateProfile(fullName: fullName, profilePicture: profilePicture);
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
  Future<Either<Failures, String>> changePasswordProfile({required String? currentPassword, required String newPassword, required String confirmPassword}) async {
     bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.changePasswordProfile(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword
            );
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