import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';

abstract class ChatbotRepository {
  Future<Either<Failures, String>> getOutput ({required String message});
}