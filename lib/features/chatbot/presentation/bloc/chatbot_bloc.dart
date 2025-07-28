import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skinsight/features/chatbot/domain/usecases/get_output_chatbot_usecase.dart';

part 'chatbot_event.dart';
part 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final GetOutputChatbotUsecase _getOutputChatbotUsecase;
  ChatbotBloc(this._getOutputChatbotUsecase) : super(ChatbotInitial()) {
    on<GetOutputChatbotEvent>((event, emit) async {
      emit(ChatbotLoading());
      final result =
          await _getOutputChatbotUsecase.execute(message: event.message);

      result.fold(
        (failure) {
          emit(ChatbotFailed(message: failure.message));
        },
        (data) {
          emit(ChatbotLoaded(
            data: data,
          ));
        },);
    });
  }
}
