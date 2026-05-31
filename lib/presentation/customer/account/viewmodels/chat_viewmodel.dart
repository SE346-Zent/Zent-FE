import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zent_fe/data/services/chat_service.dart';

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

class ChatViewModel extends ChangeNotifier with SafeChangeNotifier {
  final ChatService chatService;
  StreamSubscription<dynamic>? _wsSubscription;

  List<ChatPreview> _chats = [];
  List<ChatPreview> get chats => _chats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isInitialized = false;
  bool _wasConnected = false;

  ChatViewModel({required this.chatService}) {
    _wasConnected = chatService.isConnected;
    _setupWebSocketListener();
    chatService.addListener(_onChatServiceChanged);
  }

  void _onChatServiceChanged() {
    final isConnected = chatService.isConnected;
    if (_isInitialized && isConnected && !_wasConnected) {
      debugPrint(
        "ChatViewModel: WS Reconnected! Re-fetching latest chat rooms state...",
      );
      fetchChats(showLoading: false);
    }
    _wasConnected = isConnected;
  }

  void _setupWebSocketListener() {
    chatService.connect();
    _wsSubscription = chatService.messageStream?.listen((event) {
      if (event is Map<String, dynamic> && event['type'] == 'MESSAGE') {
        // Refresh chat list silently on new messages
        fetchChats(showLoading: false);
      }
    });
  }

  Future<void> fetchChats({bool showLoading = true}) async {
    if (showLoading) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final rooms = await chatService.getRooms();
      _chats = rooms.map((room) {
        String formattedTime = '';
        if (room.latestMessageAt != null) {
          try {
            final dt = DateTime.parse(room.latestMessageAt!).toLocal();
            formattedTime = DateFormat('HH:mm').format(dt);
          } catch (_) {
            formattedTime = '';
          }
        }
        String displayMessage = 'No messages yet';
        if (room.latestMessageAt != null) {
          if (room.latestMessage != null && room.latestMessage!.isNotEmpty) {
            displayMessage = room.latestMessage!;
          } else {
            displayMessage = 'Sent an image';
          }
        }

        return ChatPreview(
          id: room.id,
          name: room.oppositeUserName,
          lastMessage: displayMessage,
          time: formattedTime,
          unreadCount: room.unreadCount,
          avatarUrl: room.oppositeAvatarUrl,
        );
      }).toList();
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    chatService.removeListener(_onChatServiceChanged);
    _wsSubscription?.cancel();
    super.dispose();
  }
}
