import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/exceptions.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/product/data/datasources/product_remote_datasource.dart';
import 'package:skinsight/features/product/domain/entities/category_brand_entity.dart';
import 'package:skinsight/features/product/domain/entities/product_entity.dart';
import 'package:skinsight/features/product/domain/entities/product_filter_entity.dart';
import 'package:skinsight/features/product/domain/repositories/product_repository.dart';

import '../../../../core/common/network_info.dart';

class ProductRepositoryImpl implements ProductRepository{
  final NetworkInfo networkInfo;
  final ProductRemoteDatasource remoteDatasource;

  ProductRepositoryImpl({required this.networkInfo, required this.remoteDatasource});
  @override
  Future<Either<Failures, PaginatedProductResultEntity>> getAllData({int? page, String? sort, String? type, String? brand, String? search}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getProduct(page: page, sort: sort, type: type, brand: brand, search: search);
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
  Future<Either<Failures, ProductFilterEntity>> getProductFilter() async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getProductFilter();
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
  Future<Either<Failures, List<CategoryBrandEntity>>> getCategoryBrand({required String brand}) async {
   bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getCategoryBrand(brand: brand);
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
  Future<Either<Failures, List<ProductEntity>>> getProductByCategoryBrand({required String brand, required String category}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getProductByCategoryBrand(brand: brand, category: category);
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