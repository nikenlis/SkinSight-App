part of 'chatbot_bloc.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object> get props => [];
}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoading extends ChatbotState {}

class ChatbotFailed extends ChatbotState {
  final String message;

  const ChatbotFailed({required this.message});
}

class ChatbotLoaded extends ChatbotState {
  final String data;

  const ChatbotLoaded({required this.data});
  @override
  List<Object> get props => [data];
}
