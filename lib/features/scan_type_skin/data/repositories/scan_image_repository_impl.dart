import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/core/common/network_info.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/authentication/data/datasources/auth_local_datasource.dart';
import 'package:skinsight/features/scan_type_skin/data/datasources/scan_image_remote_datasource.dart';
import 'package:skinsight/features/scan_type_skin/domain/entities/scan_image_entity.dart';
import 'package:skinsight/features/scan_type_skin/domain/repositories/scan_image_repository.dart';

import '../../../../core/error/exceptions.dart';

class ScanImageRepositoryImpl implements ScanImageRepository{
  final NetworkInfo networkInfo;
  final ScanImageRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  ScanImageRepositoryImpl({required this.networkInfo, required this.remoteDatasource, required this.localDatasource});
  @override
  Future<Either<Failures, ScanImageEntity>> getScanImage({required File image}) async {
     bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getScanImage(image: image);
        return Right(response.toEntity());
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message ?? 'Waktu permintaan habis.'));
      } on UnauthorizedException catch (e) {
        localDatasource.removeToken();
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