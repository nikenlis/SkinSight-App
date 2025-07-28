import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/exceptions.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/uv_index/data/datasources/uv_remote_datasource.dart';
import 'package:skinsight/features/uv_index/domain/entities/uv_entity.dart';
import 'package:skinsight/features/uv_index/domain/repositories/uv_repository.dart';

import '../../../../core/common/network_info.dart';

class UvRepositoryImpl implements UvRepository{
   final NetworkInfo networkInfo;
   final UvRemoteDatasource remoteDatasource;

  UvRepositoryImpl({required this.networkInfo, required this.remoteDatasource});
  @override
  Future<Either<Failures, UviDataEntity>> getDataUv({required double latitude, required double longitude}) async {
   bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getDataUv(latitude: latitude, longitude: longitude);
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

}