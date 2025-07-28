import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/explore/data/datasources/explore_remote_datasource.dart';
import 'package:skinsight/features/explore/domain/entities/detail_education_entity.dart';
import 'package:skinsight/features/explore/domain/entities/detail_news_entity.dart';
import 'package:skinsight/features/explore/domain/entities/news_entity.dart';
import 'package:skinsight/features/explore/domain/repositories/explore_repository.dart';

import '../../../../core/common/network_info.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/education_entity.dart';

class ExploreRepositoryImpl implements ExploreRepository{
    final NetworkInfo networkInfo;
    final ExploreRemoteDatasource remoteDatasource;

  ExploreRepositoryImpl({required this.networkInfo, required this.remoteDatasource});
  @override
  Future<Either<Failures, List<NewsEntity>>> getAllNews(int? page) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getAllNews(page);
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
  Future<Either<Failures, PagignationEducationEntity>> getAllEducation(int? page,  {required String? nextPage, required String? prevPage}) async {
    bool online = await networkInfo.isConnected();
    print('dibgaian pall edu ${online }');


    if (online) {
      try {
        final response =
            await remoteDatasource.getAllEducation(page, nextPage: nextPage, prevPage: prevPage);
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
  Future<Either<Failures, DetailNewsEntity>> getDetailNews({required String articleLink}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getDetailNews(articleLink: articleLink);
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
  Future<Either<Failures, DetailEducationEntity>> getDetailEducation({required String articleLink}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getDetailEducation(articleLink: articleLink);
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
