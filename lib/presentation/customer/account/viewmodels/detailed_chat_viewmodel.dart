import 'package:flutter/material.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class DetailedChatViewModel extends ChangeNotifier {
  String? currentChatId;
  String chatPartnerName = "Bae Suzy";

  List<ChatMessage> messages = [];
  final TextEditingController messageController = TextEditingController();

  void init(String chatId) {
    currentChatId = chatId;
    // Mock data
    messages = [
      ChatMessage(
        id: '1',
        text: 'Hello, nice to meet you. Hope you have a good day.',
        isMe: true,
        time: '09:30',
      ),
      ChatMessage(
        id: '2',
        text: 'What do you want ?',
        isMe: false,
        time: '09:32',
      ),
    ];
    notifyListeners();
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          isMe: true,
          time: 'Now',
        ),
      );
      messageController.clear();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
