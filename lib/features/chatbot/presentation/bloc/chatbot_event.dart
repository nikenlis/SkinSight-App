part of 'chatbot_bloc.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object> get props => [];
}

class GetOutputChatbotEvent extends ChatbotEvent {
  final String message;

  const GetOutputChatbotEvent({required this.message});
}
