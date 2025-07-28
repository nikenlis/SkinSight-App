import '../../../../core/api/api_client.dart';
import '../../../authentication/data/models/auth_model.dart';

abstract class ChatbotRemoteDatasource {
  Future<String> getOutput({required String message});
}

class ChatbotRemoteDatasourceImpl implements ChatbotRemoteDatasource{
  @override
  Future<String> getOutput({required String message}) async {
    final response = await ApiClient.post<String>(
        endpoint: '/chat/send-message',
        headers: await ApiClient.getHeaders(requireAuth: true),
        body: {
          'message': message,
        },
        parser: (json) => json['data']['output'] as String);
    return response;
  }

}