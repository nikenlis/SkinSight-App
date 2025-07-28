import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/exceptions.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/chatbot/domain/repositories/chatbot_repository.dart';

import '../../../../core/common/network_info.dart';
import '../datasources/chatbot_remote_datasource.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final NetworkInfo networkInfo;
  final ChatbotRemoteDatasource remoteDatasource;

  ChatbotRepositoryImpl(
      {required this.networkInfo, required this.remoteDatasource});
  @override
  Future<Either<Failures, String>> getOutput({required String message}) async {
    bool online = await networkInfo.isConnected();

    if (online) {
      try {
        final response =
            await remoteDatasource.getOutput(message: message);
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
