import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/assesment/domain/entities/assesment_entity.dart';
import 'package:skinsight/features/assesment/domain/entities/assesment_form_entity.dart';
import 'package:skinsight/features/assesment/domain/repositories/assesment_repository.dart';
import 'package:skinsight/features/authentication/data/datasources/auth_local_datasource.dart';

import '../../../../core/common/network_info.dart';
import '../../../../core/error/exceptions.dart';
import '../datasources/assesment_remote_datasource.dart';

class AssesmentRepositoryImpl implements AssesmentRepository{
    final NetworkInfo networkInfo;
  final AssesmentRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AssesmentRepositoryImpl({required this.networkInfo, required this.remoteDatasource, required this.localDatasource});

  @override
  Future<Either<Failures, AssesmentEntity>> getAssesment(AssesmentFormEntity data) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        
        final response =
            await remoteDatasource.getAssesment(gender: data.gender, age: data.age, skinType: data.skinType != null ? data.skinType : null, scanImage: data.scanImage);
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