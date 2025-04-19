import 'package:chatbot/features/blocs/chat/chat_event.dart';
import 'package:chatbot/features/blocs/chat/chat_state.dart';
import 'package:chatbot/features/data/repositories/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc(this.chatRepository) : super(ChatInitial()) {
    on<LoadChatHistory>((event, emit) async {
      emit(ChatLoading());
      try {
        final history = await chatRepository.fetchMessages(event.userId);
        emit(ChatLoaded(history));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<SendChatMessage>((event, emit) async {
      final currentState = state;
      List<Map<String, String>> updatedMessages = [];

      if (currentState is ChatLoaded) {
        updatedMessages = List.from(currentState.messages);
      }

      updatedMessages.add({'role': 'user', 'text': event.message});
      emit(ChatLoaded(updatedMessages));
      await chatRepository.saveMessage(event.userId, event.message, true);

      final reply = await chatRepository.getGeminiReply(event.message);
      updatedMessages.add({'role': 'bot', 'text': reply});
      emit(ChatLoaded(updatedMessages));
      // await chatRepository.saveMessage(event.userId, event.message, true);
    });
  }
}