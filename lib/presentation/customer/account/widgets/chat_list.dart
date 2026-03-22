import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/chat_viewmodel.dart';
import 'package:zent_fe/presentation/customer/account/widgets/chat_list_item.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  void _onChatTapped(ChatPreview chat) {
    debugPrint("action triggered: tap chat with ${chat.name}");
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (viewModel.errorMessage != null) {
      return Center(child: Text("Error: ${viewModel.errorMessage}"));
    } else if (viewModel.chats.isNotEmpty) {
      return ListView.builder(
        itemCount: viewModel.chats.length,
        itemBuilder: (context, index) {
          final chat = viewModel.chats[index];
          return ChatListItem(chat: chat, onTap: () => _onChatTapped(chat));
        },
      );
    }
    return const SizedBox.shrink();
  }
}
