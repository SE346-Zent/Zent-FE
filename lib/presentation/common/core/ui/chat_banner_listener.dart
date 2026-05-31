import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zent_fe/data/services/chat_service.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/domain/entities/enums/user_roles.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/routing/router.dart';
import 'in_app_chat_banner.dart';

class _BannerData {
  final String id;
  final String senderName;
  final String content;
  final String roomId;

  _BannerData({
    required this.id,
    required this.senderName,
    required this.content,
    required this.roomId,
  });
}

/// A top-level widget that listens to the WebSocket message stream and
/// shows an in-app banner notification when a chat message arrives from
/// another user.
///
/// Wrap this around the `MaterialApp.router` to display banners on top
/// of all screens using a Stack.
class ChatBannerListener extends StatefulWidget {
  final Widget child;

  const ChatBannerListener({super.key, required this.child});

  @override
  State<ChatBannerListener> createState() => _ChatBannerListenerState();
}

class _ChatBannerListenerState extends State<ChatBannerListener> {
  StreamSubscription<dynamic>? _wsSubscription;
  Stream<dynamic>? _currentStream;
  _BannerData? _currentBanner;
  String? _currentUserId;
  bool _userIdResolved = false;

  @override
  void initState() {
    super.initState();
    _resolveUserId();
    _listenToWebSocket();

    sl<ChatService>().addListener(_onChatServiceChanged);
    sl<AuthViewModel>().addListener(_onAuthStateChanged);
  }

  void _onChatServiceChanged() {
    _listenToWebSocket();
  }

  void _onAuthStateChanged() {
    _resolveUserId();
    _listenToWebSocket();
  }

  void _resolveUserId() {
    try {
      final authVm = sl<AuthViewModel>();
      _currentUserId = authVm.currentUser?.id;
      _userIdResolved = _currentUserId != null;
    } catch (_) {
      // AuthViewModel not ready yet
    }
  }

  void _listenToWebSocket() {
    try {
      final chatService = sl<ChatService>();
      if (!chatService.isConnected) {
        chatService.connect();
      }
      final stream = chatService.messageStream;
      if (stream == null) return;
      if (_currentStream == stream)
        return; // Already listening to the latest stream

      _wsSubscription?.cancel();
      _currentStream = stream;

      _wsSubscription = stream.listen((event) {
        if (event is Map<String, dynamic> && event['type'] == 'MESSAGE') {
          _handleIncomingMessage(event);
        }
      });
    } catch (_) {
      // ChatService not connected yet
    }
  }

  void _handleIncomingMessage(Map<String, dynamic> event) {
    if (!_userIdResolved) _resolveUserId();

    // Support flat event structure or wrapped 'message' object
    final Map<String, dynamic> msgMap = event['message'] is Map<String, dynamic>
        ? event['message'] as Map<String, dynamic>
        : event;

    final senderId =
        (msgMap['sender_id'] ??
                msgMap['senderId'] ??
                event['sender_id'] ??
                event['senderId'])
            ?.toString();
    final senderName = (msgMap['sender_name'] ?? msgMap['senderName'] ?? 'User')
        .toString();
    final content = (msgMap['content'] ?? '').toString();
    final roomId =
        (event['room_id'] ??
                event['roomId'] ??
                msgMap['room_id'] ??
                msgMap['roomId'])
            ?.toString();

    if (senderId == null || roomId == null) return;

    // Don't show banner for own messages
    if (_currentUserId != null) {
      final normalizedSender = senderId.toLowerCase().replaceAll('-', '');
      final normalizedCurrent = _currentUserId!.toLowerCase().replaceAll(
        '-',
        '',
      );
      if (normalizedSender == normalizedCurrent) return;
    }

    // Don't show banner if currently viewing this room
    try {
      final chatService = sl<ChatService>();
      if (chatService.currentViewingRoomId == roomId) return;
    } catch (_) {}

    // Show banner
    _showBanner(senderName, content, roomId);
  }

  void _showBanner(String senderName, String content, String roomId) {
    setState(() {
      _currentBanner = _BannerData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderName: senderName,
        content: content,
        roomId: roomId,
      );
    });
  }

  void _dismissCurrentBanner() {
    if (mounted) {
      setState(() {
        _currentBanner = null;
      });
    }
  }

  void _navigateToChat(String roomId, String senderName) {
    try {
      final authVm = sl<AuthViewModel>();
      final role = authVm.role;

      switch (role) {
        case UserRoles.customer:
          appRouter.pushNamed(
            RouteNames.customerDetailedChat,
            pathParameters: {'chatId': roomId},
            queryParameters: {'name': senderName},
          );
          break;
        case UserRoles.technician:
          appRouter.pushNamed(
            RouteNames.techDetailedChat,
            pathParameters: {'chatId': roomId},
            queryParameters: {'name': senderName},
          );
          break;
        case UserRoles.admin:
        case UserRoles.superAdmin:
          appRouter.pushNamed(
            RouteNames.customerDetailedChat,
            pathParameters: {'chatId': roomId},
            queryParameters: {'name': senderName},
          );
          break;
        default:
          break;
      }
    } catch (e) {
      debugPrint('ChatBannerListener: Navigation failed: $e');
    }
  }

  @override
  void dispose() {
    sl<ChatService>().removeListener(_onChatServiceChanged);
    sl<AuthViewModel>().removeListener(_onAuthStateChanged);
    _wsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banner = _currentBanner;

    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        widget.child,
        if (banner != null)
          InAppChatBanner(
            key: ValueKey(banner.id),
            senderName: banner.senderName,
            content: banner.content,
            onTap: () {
              // The banner internal dismiss triggers onDismiss automatically,
              // but we need to ensure we navigate too.
              _navigateToChat(banner.roomId, banner.senderName);
            },
            onDismiss: _dismissCurrentBanner,
          ),
      ],
    );
  }
}
