import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zent_fe/data/services/chat_service.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final String time;
  final String? imageUrl;
  bool isSeen;
  final DateTime dateTime;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.imageUrl,
    this.isSeen = false,
    required this.dateTime,
  });

  static DateTime? parseDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      String cleanStr = dateStr.trim();

      // Remove any spaces before + or - timezone offsets
      cleanStr = cleanStr.replaceAll(
        RegExp(r'\s+([+-]\d{2}(?::?\d{2})?)'),
        r'$1',
      );

      // Normalize timezone offset with seconds (e.g. '+00:00:00' -> '+00:00')
      final match = RegExp(r'([+-]\d{2}:\d{2}):\d{2}$').firstMatch(cleanStr);
      if (match != null) {
        cleanStr = cleanStr.substring(0, match.start) + match.group(1)!;
      }

      // Support Unix Epoch Timestamps (seconds or milliseconds)
      final numericVal = int.tryParse(cleanStr);
      if (numericVal != null) {
        if (cleanStr.length <= 10) {
          return DateTime.fromMillisecondsSinceEpoch(numericVal * 1000);
        } else {
          return DateTime.fromMillisecondsSinceEpoch(numericVal);
        }
      }

      if (cleanStr.endsWith(' UTC')) {
        cleanStr = '${cleanStr.substring(0, cleanStr.length - 4)}Z';
      }
      if (cleanStr.length > 10 && cleanStr[10] == ' ') {
        cleanStr = '${cleanStr.substring(0, 10)}T${cleanStr.substring(11)}';
      }
      return DateTime.parse(cleanStr);
    } catch (_) {
      return DateTime.tryParse(dateStr);
    }
  }
}

class DetailedChatViewModel extends ChangeNotifier with SafeChangeNotifier {
  final ChatService chatService;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  // Static RAM caches for instant room loading on re-entrance
  static final Map<String, List<ChatMessage>> _roomMessagesCache = {};
  static final Map<String, String> _roomPartnerNamesCache = {};
  static final Map<String, bool> _hasMoreCache = {};
  static String? _cachedUserId;
  static String? _cachedMyName;

  String? currentChatId;
  String chatPartnerName = "";
  String myName = "";
  String? currentUserId;
  bool isLoading = false;
  bool isLoadMoreLoading = false;
  bool hasMore = true;

  List<ChatMessage> messages = [];
  final TextEditingController messageController = TextEditingController();
  StreamSubscription<dynamic>? _wsSubscription;

  void _sortMessages() {
    messages.sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  bool _isInitialized = false;
  bool _wasConnected = false;
  bool _isDisposed = false;

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  bool _isMe(String? senderId) {
    if (senderId == null || currentUserId == null) return false;
    final normalizedSender = senderId.toLowerCase().replaceAll('-', '');
    final normalizedCurrent = currentUserId!.toLowerCase().replaceAll('-', '');
    return normalizedSender == normalizedCurrent;
  }

  DetailedChatViewModel({
    required this.chatService,
    required this.getCurrentUserUseCase,
  }) {
    _wasConnected = chatService.isConnected;
    chatService.addListener(_onChatServiceChanged);
  }

  void _onChatServiceChanged() async {
    final isConnected = chatService.isConnected;
    if (_isInitialized &&
        isConnected &&
        !_wasConnected &&
        currentChatId != null) {
      debugPrint(
        "DetailedChatViewModel: WS Reconnected! Re-fetching latest room messages...",
      );
      try {
        final fetchedMessages = await chatService.getMessages(currentChatId!);
        if (fetchedMessages.isNotEmpty) {
          final unreadMessageIds = fetchedMessages
              .where(
                (m) => !_isMe(m.senderId) && !m.readBy.any((id) => _isMe(id)),
              )
              .map((m) => m.id)
              .toList();
          if (unreadMessageIds.isNotEmpty) {
            chatService.markMessagesAsRead(unreadMessageIds);
          }

          final updatedMessages = fetchedMessages.reversed.map((msg) {
            final parsedDt =
                ChatMessage.parseDateTime(msg.createdAt) ?? DateTime.now();
            final formattedTime = DateFormat(
              'HH:mm',
            ).format(parsedDt.toLocal());
            return ChatMessage(
              id: msg.id,
              text: msg.content ?? "",
              isMe: _isMe(msg.senderId),
              time: formattedTime,
              imageUrl: msg.imageUrl,
              isSeen: _isMe(msg.senderId) && msg.readBy.any((id) => !_isMe(id)),
              dateTime: parsedDt,
            );
          }).toList();

          for (final msg in updatedMessages) {
            if (!messages.any((m) => m.id == msg.id)) {
              messages.add(msg);
            }
          }
          _sortMessages();
          if (currentChatId != null) {
            _roomMessagesCache[currentChatId!] = List.from(messages);
          }
          // Re-send VIEWING room frame to register session with server again
          chatService.startViewing(currentChatId!);
          notifyListeners();
        }
      } catch (e) {
        debugPrint("DetailedChatViewModel re-fetch on reconnect failed: $e");
      }
    }
    _wasConnected = isConnected;
  }

  Future<void> init(String chatId, {String? initialPartnerName}) async {
    currentChatId = chatId;

    // Check if cache exists for instant room rendering
    final hasCache = _roomMessagesCache.containsKey(chatId);
    if (hasCache) {
      messages = List.from(_roomMessagesCache[chatId]!);
      chatPartnerName =
          _roomPartnerNamesCache[chatId] ?? (initialPartnerName ?? "");
      hasMore = _hasMoreCache[chatId] ?? true;
      isLoading = false;
    } else {
      chatPartnerName = initialPartnerName ?? "";
      isLoading = true;
      hasMore = true;
    }
    isLoadMoreLoading = false;
    currentUserId = _cachedUserId;
    myName = _cachedMyName ?? "";
    notifyListeners();

    try {
      // 1. Fetch current user if not cached
      if (currentUserId == null) {
        final user = await getCurrentUserUseCase.execute();
        currentUserId = user?.id;
        myName = user?.name ?? user?.email ?? "Me";
        _cachedMyName = myName;
        debugPrint(
          "DetailedChatViewModel init: user loaded -> email: ${user?.email}, id: ${user?.id}",
        );

        // Fallback/Migration: If user is null, ID is empty, or is 'temp_id', extract ID from JWT token directly
        if (currentUserId == null ||
            currentUserId!.isEmpty ||
            currentUserId == 'temp_id') {
          try {
            final token = await chatService.authLocalDataSource
                .getAccessToken();
            if (token != null) {
              final parts = token.split('.');
              if (parts.length == 3) {
                final payload = utf8.decode(
                  base64Url.decode(base64Url.normalize(parts[1])),
                );
                final payloadMap = jsonDecode(payload) as Map<String, dynamic>;
                currentUserId = payloadMap['sub'] as String?;
                debugPrint(
                  "DetailedChatViewModel init: Migrated session with sub/currentUserId = $currentUserId",
                );
              }
            }
          } catch (e) {
            debugPrint(
              "DetailedChatViewModel: Failed to decode token for currentUserId fallback: $e",
            );
          }
        }
        _cachedUserId = currentUserId;
      }

      // 2. Fetch messages from REST API
      final fetchedMessages = await chatService.getMessages(chatId);

      // Get partner name from the rooms list first
      try {
        final rooms = await chatService.getRooms();
        final room = rooms.firstWhere((r) => r.id == chatId);
        chatPartnerName = room.oppositeUserName;
      } catch (_) {
        // Fallback to checking messages if rooms list fails
        if (fetchedMessages.isNotEmpty) {
          final firstOtherMessage = fetchedMessages.firstWhere(
            (m) => !_isMe(m.senderId),
            orElse: () => fetchedMessages.first,
          );
          chatPartnerName = _isMe(firstOtherMessage.senderId)
              ? "Chat Partner"
              : firstOtherMessage.senderName;
        } else {
          chatPartnerName = "Chat Partner";
        }
      }

      // Update partner name in cache
      _roomPartnerNamesCache[chatId] = chatPartnerName;

      // Convert fetched messages to UI messages
      messages = fetchedMessages.reversed.map((msg) {
        final parsedDt = ChatMessage.parseDateTime(msg.createdAt);
        final formattedTime = parsedDt != null
            ? DateFormat('HH:mm').format(parsedDt.toLocal())
            : '';
        return ChatMessage(
          id: msg.id,
          text: msg.content ?? "",
          isMe: _isMe(msg.senderId),
          time: formattedTime,
          imageUrl: msg.imageUrl,
          isSeen: _isMe(msg.senderId) && msg.readBy.any((id) => !_isMe(id)),
          dateTime: parsedDt ?? DateTime.fromMillisecondsSinceEpoch(0),
        );
      }).toList();

      _sortMessages();

      // Update room messages and status in cache
      _roomMessagesCache[chatId] = List.from(messages);
      _hasMoreCache[chatId] = hasMore;

      // 3. Mark all unread incoming messages as read
      final unreadMessageIds = fetchedMessages
          .where((m) => !_isMe(m.senderId) && !m.readBy.any((id) => _isMe(id)))
          .map((m) => m.id)
          .toList();
      if (unreadMessageIds.isNotEmpty) {
        chatService.markMessagesAsRead(unreadMessageIds);
      }

      // 4. Start WebSocket viewing session
      chatService.connect();
      chatService.startViewing(chatId);

      // 5. Listen to real-time WebSocket messages
      _wsSubscription?.cancel();
      _wsSubscription = chatService.messageStream?.listen((event) {
        if (event is Map<String, dynamic>) {
          final type = event['type'] as String?;
          if (type == 'MESSAGE') {
            // Robust support for both snake_case and camelCase roomId
            final roomId = (event['room_id'] ?? event['roomId']) as String?;
            if (roomId == currentChatId) {
              // Support flat event structure (per guide) or wrapped 'message' object
              final Map<String, dynamic> msgMap =
                  event['message'] is Map<String, dynamic>
                  ? event['message'] as Map<String, dynamic>
                  : event;

              // Strict field mapping with fallbacks to guarantee successful parse
              final msgId = (msgMap['id'] ?? msgMap['_id']) as String?;
              final senderId =
                  (msgMap['sender_id'] ?? msgMap['senderId']) as String?;
              final content = msgMap['content'] as String?;
              final imageUrl =
                  (msgMap['image_url'] ?? msgMap['imageUrl']) as String?;
              final createdAt =
                  (msgMap['created_at'] ?? msgMap['createdAt']) as String?;

              if (msgId == null || senderId == null) {
                debugPrint("WS Message payload is missing mandatory fields.");
                return;
              }

              final parsedDt =
                  ChatMessage.parseDateTime(createdAt) ?? DateTime.now();
              final formattedTime = DateFormat(
                'HH:mm',
              ).format(parsedDt.toLocal());

              final uiMsg = ChatMessage(
                id: msgId,
                text: content ?? "",
                isMe: _isMe(senderId),
                time: formattedTime,
                imageUrl: imageUrl,
                dateTime: parsedDt,
              );

              // Match and replace local optimistic temporary message to prevent double-rendering
              if (_isMe(senderId)) {
                final tempIndex = messages.indexWhere((m) {
                  final isTemp =
                      int.tryParse(m.id) != null && m.id.length >= 13;
                  if (!isTemp || !m.isMe) return false;
                  if (uiMsg.imageUrl != null) {
                    return m.imageUrl == uiMsg.imageUrl ||
                        (m.imageUrl != null &&
                            uiMsg.imageUrl!.endsWith(m.imageUrl!)) ||
                        (uiMsg.imageUrl != null &&
                            m.imageUrl!.endsWith(uiMsg.imageUrl!));
                  } else {
                    return m.text == uiMsg.text;
                  }
                });

                if (tempIndex != -1) {
                  messages[tempIndex] = uiMsg;
                  if (currentChatId != null) {
                    _roomMessagesCache[currentChatId!] = List.from(messages);
                  }
                  notifyListeners();
                  return;
                }
              }

              // Avoid duplicate rendering if REST loaded the message concurrently
              if (!messages.any((m) => m.id == uiMsg.id)) {
                messages.add(uiMsg);
                _sortMessages();
                if (currentChatId != null) {
                  _roomMessagesCache[currentChatId!] = List.from(messages);
                }
              }

              // Automatically send read receipt if this incoming message is from the other user
              if (!_isMe(senderId)) {
                chatService.markAsRead(msgId);
              }

              notifyListeners();
            }
          } else if (type == 'READ_RECEIPT') {
            final msgId =
                (event['message_id'] ?? event['messageId']) as String?;
            final userId = (event['user_id'] ?? event['userId']) as String?;
            if (msgId != null && userId != null && !_isMe(userId)) {
              final index = messages.indexWhere((m) => m.id == msgId);
              if (index != -1) {
                messages[index].isSeen = true;
                if (currentChatId != null) {
                  _roomMessagesCache[currentChatId!] = List.from(messages);
                }
                notifyListeners();
              }
            }
          }
        }
      });
    } catch (e) {
      debugPrint("Error initializing detailed chat: $e");
    } finally {
      isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> loadMoreMessages() async {
    if (isLoadMoreLoading ||
        !hasMore ||
        currentChatId == null ||
        messages.isEmpty) {
      return;
    }

    isLoadMoreLoading = true;
    notifyListeners();

    try {
      final cursorId = messages.first.id;
      final fetchedMessages = await chatService.getMessages(
        currentChatId!,
        cursor: cursorId,
        limit: 20,
      );

      if (fetchedMessages.isEmpty) {
        hasMore = false;
      } else {
        final olderMessages = fetchedMessages.reversed.map((msg) {
          final parsedDt =
              ChatMessage.parseDateTime(msg.createdAt) ?? DateTime.now();
          final formattedTime = DateFormat('HH:mm').format(parsedDt.toLocal());
          return ChatMessage(
            id: msg.id,
            text: msg.content ?? "",
            isMe: _isMe(msg.senderId),
            time: formattedTime,
            imageUrl: msg.imageUrl,
            isSeen: _isMe(msg.senderId) && msg.readBy.any((id) => !_isMe(id)),
            dateTime: parsedDt,
          );
        }).toList();

        final uniqueOlder = olderMessages
            .where((om) => !messages.any((m) => m.id == om.id))
            .toList();

        messages.insertAll(0, uniqueOlder);
        _sortMessages();

        if (fetchedMessages.length < 20) {
          hasMore = false;
        }
      }

      if (currentChatId != null) {
        _roomMessagesCache[currentChatId!] = List.from(messages);
        _hasMoreCache[currentChatId!] = hasMore;
      }
    } catch (e) {
      debugPrint("DetailedChatViewModel loadMoreMessages failed: $e");
    } finally {
      isLoadMoreLoading = false;
      notifyListeners();
    }
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty && currentChatId != null) {
      chatService.sendMessage(currentChatId!, text);

      // Optimistic local add: since server does not echo back to the sender
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();
      final formattedTime = DateFormat('HH:mm').format(now);
      final uiMsg = ChatMessage(
        id: tempId,
        text: text,
        isMe: true,
        time: formattedTime,
        dateTime: now,
      );
      messages.add(uiMsg);
      _sortMessages();

      if (currentChatId != null) {
        _roomMessagesCache[currentChatId!] = List.from(messages);
      }

      messageController.clear();
      notifyListeners();
    }
  }

  Future<void> sendImage() async {
    if (currentChatId == null) return;

    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (image == null) return;

    isLoading = true;
    notifyListeners();

    try {
      // 1. Upload attachment
      final objectName = await chatService.uploadAttachment(
        image.path,
        roomId: currentChatId,
      );

      // 2. Send WS message with imageUrl
      chatService.sendMessage(currentChatId!, "", imageUrl: objectName);

      // Optimistic local add: since server does not echo back to the sender
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();
      final formattedTime = DateFormat('HH:mm').format(now);
      final uiMsg = ChatMessage(
        id: tempId,
        text: "",
        isMe: true,
        time: formattedTime,
        imageUrl: objectName,
        dateTime: now,
      );
      messages.add(uiMsg);
      _sortMessages();

      if (currentChatId != null) {
        _roomMessagesCache[currentChatId!] = List.from(messages);
      }
    } catch (e) {
      debugPrint("Failed to send image: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendCameraImage() async {
    if (currentChatId == null) return;

    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (image == null) return;

    isLoading = true;
    notifyListeners();

    try {
      // 1. Upload attachment
      final objectName = await chatService.uploadAttachment(
        image.path,
        roomId: currentChatId,
      );

      // 2. Send WS message with imageUrl
      chatService.sendMessage(currentChatId!, "", imageUrl: objectName);

      // Optimistic local add: since server does not echo back to the sender
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();
      final formattedTime = DateFormat('HH:mm').format(now);
      final uiMsg = ChatMessage(
        id: tempId,
        text: "",
        isMe: true,
        time: formattedTime,
        imageUrl: objectName,
        dateTime: now,
      );
      messages.add(uiMsg);
      _sortMessages();

      if (currentChatId != null) {
        _roomMessagesCache[currentChatId!] = List.from(messages);
      }
    } catch (e) {
      debugPrint("Failed to send image: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    chatService.removeListener(_onChatServiceChanged);
    _wsSubscription?.cancel();
    if (currentChatId != null) {
      chatService.stopViewing(currentChatId!);
    }
    messageController.dispose();
    super.dispose();
  }
}
