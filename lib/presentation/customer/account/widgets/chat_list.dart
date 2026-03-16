import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/chat_bloc.dart';
import '../blocs/chat_state.dart';
import 'chat_list_item.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  void _onChatTapped(ChatPreview chat) {
    debugPrint("action triggered: tap chat with ${chat.name}");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatLoadFailure) {
          return Center(child: Text("Error: ${state.errorMessage}"));
        } else if (state is ChatLoadSuccess) {
          final chats = state.chats;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ChatListItem(
                chat: chat,
                onTap: () => _onChatTapped(chat),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
