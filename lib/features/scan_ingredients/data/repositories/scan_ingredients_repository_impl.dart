import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/scan_ingredients/domain/entities/history_scan_ingredient_entity.dart';
import 'package:skinsight/features/scan_ingredients/domain/entities/scan_ingredients_entity.dart';
import 'package:skinsight/features/scan_ingredients/domain/repositories/scan_ingredients_repository.dart';

import '../../../../core/common/network_info.dart';
import '../../../../core/error/exceptions.dart';
import '../datasources/scan_ingredients_remote_datasource.dart';

class ScanIngredientsRepositoryImpl implements ScanIngredientsRepository{
  final NetworkInfo networkInfo;
  final ScanIngredientsRemoteDatasource remoteDatasource;

  ScanIngredientsRepositoryImpl({required this.networkInfo, required this.remoteDatasource});
  @override
  Future<Either<Failures, ScanIngredientsEntity>> getScanIngredients({required File image, required String name}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getScanIngredients(image: image, name: name);
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
  Future<Either<Failures, List<HistoryScanIngredientEntity>>> getHistoryScanIngredients() async {
   bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getHistoryScanIngredients();
        return Right(response.map((e) => e.toEntity()).toList());
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
  Future<Either<Failures, ScanIngredientsEntity>> getDetailHistoryScanIngredients({required String id})async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getDetailHistoryScanIngredients(id: id);
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