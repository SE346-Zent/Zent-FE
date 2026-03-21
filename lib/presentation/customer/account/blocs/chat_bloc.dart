import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatDataFetchRequested>(_onChatDataFetchRequested);
  }

  Future<void> _onChatDataFetchRequested(
    ChatDataFetchRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final mockData = [
        const ChatPreview(
          id: '1',
          name: 'Bae Suzy',
          lastMessage: 'I have sent you some important informat...',
          time: '10h30',
          unreadCount: 3,
        ),
        const ChatPreview(
          id: '2',
          name: 'Bae Suzy',
          lastMessage: 'I have sent you some important informat...',
          time: '10h30',
          unreadCount: 0,
        ),
        const ChatPreview(
          id: '3',
          name: 'Bae Suzy',
          lastMessage: 'I have sent you some important informat...',
          time: '10h30',
          unreadCount: 3,
        ),
        const ChatPreview(
          id: '4',
          name: 'Bae Suzy',
          lastMessage: 'I have sent you some important informat...',
          time: '10h30',
          unreadCount: 0,
        ),
      ];
      emit(ChatLoadSuccess(mockData));
    } catch (e) {
      emit(ChatLoadFailure(e.toString()));
    }
  }
}
