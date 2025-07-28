import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/product/domain/entities/product_entity.dart';
import 'package:skinsight/features/recomendation_product/data/datasources/recomendation_product_remote_datasource.dart';
import 'package:skinsight/features/recomendation_product/domain/repositories/recomendation_product_repository.dart';

import '../../../../core/common/network_info.dart';
import '../../../../core/error/exceptions.dart';

class RecomendationProductRepositoryImpl implements RecomendationProductRepository{
    final NetworkInfo networkInfo;
    final RecomendationProductRemoteDatasource remoteDatasource;

  RecomendationProductRepositoryImpl({required this.networkInfo, required this.remoteDatasource});

  
  @override
  Future<Either<Failures, List<ProductEntity>>> getRecomendationProduct() async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getRecomendationProduct();
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

}