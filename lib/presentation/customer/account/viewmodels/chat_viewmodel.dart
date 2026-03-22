import 'package:flutter/material.dart';

class ChatPreview {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String? avatarUrl;

  const ChatPreview({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    this.avatarUrl,
  });
}

class ChatViewModel extends ChangeNotifier {
  List<ChatPreview> _chats = [];
  List<ChatPreview> get chats => _chats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchChats() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      _chats = [
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
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
