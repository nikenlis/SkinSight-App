import 'package:dartz/dartz.dart';
import 'package:skinsight/features/chatbot/domain/repositories/chatbot_repository.dart';

import '../../../../core/error/failures.dart';

class GetOutputChatbotUsecase {
  final ChatbotRepository repository;

  GetOutputChatbotUsecase({required this.repository});
  Future<Either<Failures, String>> execute({required String message}) {
    return repository.getOutput(message: message);
  }
}