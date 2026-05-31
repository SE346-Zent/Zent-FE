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
  final String? latestMessageAt;

  const ChatPreview({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    this.avatarUrl,
    this.latestMessageAt,
  });
}

class ChatViewModel extends ChangeNotifier with SafeChangeNotifier {
  final ChatService chatService;
  StreamSubscription<dynamic>? _wsSubscription;
  Stream<dynamic>? _currentStream;

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
    _setupWebSocketListener();
  }

  void _setupWebSocketListener() {
    chatService.connect();
    final stream = chatService.messageStream;
    if (stream == null) return;
    if (_currentStream == stream) return;

    _wsSubscription?.cancel();
    _currentStream = stream;

    _wsSubscription = stream.listen((event) {
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
        DateTime? parsedDt;

        if (room.latestMessageAt != null) {
          try {
            String dateStr = room.latestMessageAt!;
            if (dateStr.endsWith(' +00:00:00')) {
              dateStr = dateStr.replaceAll(' +00:00:00', 'Z');
            }
            parsedDt = DateTime.parse(dateStr);
            formattedTime = DateFormat('HH:mm').format(parsedDt.toLocal());
          } catch (e) {
            debugPrint(
              'Failed to parse date: ${room.latestMessageAt}, error: $e',
            );
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
          latestMessageAt: room.latestMessageAt,
        );
      }).toList();

      // Sort by most recent message first
      _chats.sort((a, b) {
        if (a.latestMessageAt == null && b.latestMessageAt == null) {
          return 0;
        }
        if (a.latestMessageAt == null) {
          return 1;
        }
        if (b.latestMessageAt == null) {
          return -1;
        }
        try {
          String aStr = a.latestMessageAt!;
          if (aStr.endsWith(' +00:00:00')) {
            aStr = aStr.replaceAll(' +00:00:00', 'Z');
          }

          String bStr = b.latestMessageAt!;
          if (bStr.endsWith(' +00:00:00')) {
            bStr = bStr.replaceAll(' +00:00:00', 'Z');
          }

          final aDt = DateTime.parse(aStr);
          final bDt = DateTime.parse(bStr);
          return bDt.compareTo(aDt); // descending
        } catch (_) {
          return 0;
        }
      });

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
