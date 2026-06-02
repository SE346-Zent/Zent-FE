import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:zent_fe/data/datasources/local/auth_local_datasource.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/domain/repositories/auth_repository.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/routing/router.dart';
import 'package:zent_fe/routing/routes.dart';

class _WsConfig {
  final Map<String, String>? headers;
  final List<String>? protocols;

  const _WsConfig({this.headers, this.protocols});
}

class ChatRoomResponse {
  final String id;
  final String oppositeUserName;
  final String? latestMessage;
  final String? latestMessageAt;
  final String? oppositeAvatarUrl;
  final int unreadCount;

  ChatRoomResponse({
    required this.id,
    required this.oppositeUserName,
    this.latestMessage,
    this.latestMessageAt,
    this.oppositeAvatarUrl,
    required this.unreadCount,
  });

  factory ChatRoomResponse.fromJson(Map<String, dynamic> json) {
    return ChatRoomResponse(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      oppositeUserName:
          (json['oppositeUserName'] ?? json['opposite_user_name'] ?? 'User')
              ?.toString() ??
          '',
      latestMessage: json['latestMessage']?.toString(),
      latestMessageAt: (json['latestMessageAt'] ?? json['latest_message_at'])
          ?.toString(),
      oppositeAvatarUrl:
          (json['oppositeAvatarUrl'] ?? json['opposite_avatar_url'])
              ?.toString(),
      unreadCount:
          int.tryParse(
            (json['unreadCount'] ?? json['unread_count'])?.toString() ?? '0',
          ) ??
          0,
    );
  }
}

class MessageResponse {
  final String id;
  final String roomId;
  final String senderId;
  final String senderName;
  final String? content;
  final String? imageUrl;
  final String createdAt;
  final List<String> readBy;

  MessageResponse({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    this.content,
    this.imageUrl,
    required this.createdAt,
    required this.readBy,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      roomId: (json['roomId'] ?? json['room_id'])?.toString() ?? '',
      senderId: (json['senderId'] ?? json['sender_id'])?.toString() ?? '',
      senderName:
          (json['senderName'] ?? json['sender_name'] ?? 'User')?.toString() ??
          '',
      content: json['content']?.toString(),
      imageUrl: (json['imageUrl'] ?? json['image_url'])?.toString(),
      createdAt: (json['createdAt'] ?? json['created_at'])?.toString() ?? '',
      readBy:
          (json['readBy'] as List?)?.map((e) => e.toString()).toList() ??
          (json['read_by'] as List?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }
}

class ChatService extends ChangeNotifier {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  WebSocketChannel? _channel;
  StreamController<dynamic>? _messageStreamController;
  Stream<dynamic>? get messageStream => _messageStreamController?.stream;
  StreamSubscription? _wsSubscription;

  bool _isConnected = false;
  bool get isConnected => _isConnected;
  bool _isConnecting = false;
  bool get isConnecting => _isConnecting;

  String? _currentViewingRoomId;
  String? get currentViewingRoomId => _currentViewingRoomId;

  static final String _baseURL = dotenv.get("BASE_URL");

  String get _cleanBaseURL {
    return _baseURL.endsWith('/')
        ? _baseURL.substring(0, _baseURL.length - 1)
        : _baseURL;
  }

  static final Duration _timeOut = Duration(
    seconds: int.tryParse(dotenv.get("TIME_OUT")) ?? 30,
  );

  ChatService({required this.client, required this.authLocalDataSource});

  String getAttachmentUrl(String objectName) {
    if (objectName.startsWith('http')) {
      debugPrint("WS Image URL already absolute: $objectName");
      return objectName;
    }
    final ociBaseUrl = dotenv.get("OCI_STORAGE_URL");
    final resolvedUrl = '$ociBaseUrl$objectName';
    debugPrint(
      "WS Image URL resolved: objectName=$objectName -> resolvedUrl=$resolvedUrl",
    );
    return resolvedUrl;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await authLocalDataSource.getAccessToken();
    debugPrint(
      "ChatService _getHeaders: token length = ${token?.length ?? 0}, token is null = ${token == null}",
    );
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // --- REST ENDPOINTS ---

  Future<List<ChatRoomResponse>> getRooms({
    int page = 1,
    int limit = 20,
  }) async {
    // Omit page and limit query parameters to avoid u64 query deserialization errors in the backend
    final uri = Uri.parse('$_cleanBaseURL/chat/rooms');
    final headers = await _getHeaders();
    final response = await client.get(uri, headers: headers).timeout(_timeOut);

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final data = jsonMap['data'] as List<dynamic>?;
      if (data != null) {
        return data
            .map((e) => ChatRoomResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } else {
      throw Exception(
        'Failed to get chat rooms: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<MessageResponse>> getMessages(
    String roomId, {
    String? cursor,
    int limit = 20,
  }) async {
    final queryParams = <String, String>{};
    if (cursor != null) {
      queryParams['cursor'] = cursor;
    }
    // Omit limit to avoid query deserialization errors in the backend
    final uri = Uri.parse(
      '$_cleanBaseURL/chat/rooms/$roomId/messages',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);
    final headers = await _getHeaders();
    final response = await client.get(uri, headers: headers).timeout(_timeOut);

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final data = jsonMap['data'] as List<dynamic>?;
      if (data != null) {
        return data
            .map((e) => MessageResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } else {
      throw Exception(
        'Failed to get messages: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<String> uploadAttachment(String filePath, {String? roomId}) async {
    final uri = Uri.parse('$_cleanBaseURL/chat/attachments');
    final request = http.MultipartRequest('POST', uri);

    final token = await authLocalDataSource.getAccessToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    if (roomId != null) {
      request.fields['room_id'] = roomId;
    }

    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    final streamedResponse = await request.send().timeout(_timeOut);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final data = jsonMap['data'];
      if (data != null && data['objectName'] != null) {
        return data['objectName'] as String;
      }
      throw Exception('Attachment upload response missing objectName');
    } else {
      throw Exception('Failed to upload attachment: ${response.statusCode}');
    }
  }

  // --- WEBSOCKET FLOWS ---

  Future<WebSocket?> _tryConnect(String url, String token) async {
    final baseUri = Uri.parse(_cleanBaseURL);
    final cleanOrigin = Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.port == 0 ? null : baseUri.port,
    ).toString();

    final configs = [
      // 1. Clean native client (No custom headers) - standard for mobile apps
      const _WsConfig(headers: null, protocols: null),
      // 2. Combined browser-spoofing + Auth headers as fallback
      _WsConfig(
        headers: {
          'Origin': cleanOrigin,
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Authorization': 'Bearer $token',
        },
        protocols: null,
      ),
    ];

    for (var i = 0; i < configs.length; i++) {
      final config = configs[i];
      try {
        debugPrint(
          "WS: Connecting to $url via WebSocket.connect (Config $i)...",
        );
        final socket = await WebSocket.connect(
          url,
          headers: config.headers,
          protocols: config.protocols,
        ).timeout(const Duration(seconds: 4));

        debugPrint("WS: Handshake successful on config $i for $url");
        return socket;
      } catch (e) {
        debugPrint(
          "WS Connection handshake caught exception on config $i for $url: $e",
        );
      }
    }

    return null;
  }

  Timer? _reconnectTimer;
  bool _isIntentionalDisconnect = false;

  Future<void> connect() async {
    if (_isConnected || _isConnecting) return;
    _isConnecting = true;

    try {
      _isIntentionalDisconnect = false;
      _reconnectTimer?.cancel();
      _reconnectTimer = null;

      // Explicitly close any old connection/channel before connecting again
      _isConnected = false;
      _wsSubscription?.cancel();
      _wsSubscription = null;
      _channel?.sink.close();
      _channel = null;
      if (_messageStreamController != null) {
        _messageStreamController?.close();
        _messageStreamController = null;
      }

      final token = await authLocalDataSource.getAccessToken();
      if (token == null) return;

      _messageStreamController = StreamController<dynamic>.broadcast();

      final baseUri = Uri.parse(_cleanBaseURL);
      final String wsScheme = baseUri.scheme == 'https' ? 'wss' : 'ws';
      final int defaultPort = wsScheme == 'wss' ? 443 : 80;

      // Clean, simplified candidates targetting only the canonical /chat path
      final candidates = <String>[
        '$wsScheme://${baseUri.host}:$defaultPort/chat',
        '$wsScheme://${baseUri.host}/chat',
        if (wsScheme == 'wss') ...[
          'ws://${baseUri.host}:80/chat',
          'ws://${baseUri.host}/chat',
        ],
      ];

      for (final url in candidates) {
        debugPrint("WS attempting to connect to: $url");
        final socket = await _tryConnect(url, token);
        if (socket != null) {
          debugPrint("WS successfully connected to: $url");
          _isConnected = true;
          _channel = IOWebSocketChannel(socket);
          notifyListeners();

          // Immediately register AUTH frame with server
          sendAuth(token);

          // Establish message listening stream on the active connection channel
          _wsSubscription = _channel!.stream.listen(
            (message) {
              debugPrint("WS Received: $message");
              try {
                final decoded = json.decode(message as String);
                if (decoded['type'] == 'TOKEN_EXPIRING') {
                  _handleTokenExpiring();
                } else if (decoded['type'] == 'ERROR' &&
                    decoded['code'] == 4001) {
                  // Token used for WS is expired/invalid, we must refresh it immediately!
                  _handleTokenExpiring();
                }
                _messageStreamController?.add(decoded);
              } catch (e) {
                debugPrint("Error decoding WS message: $e");
              }
            },
            onError: (err) {
              debugPrint("WS Error: $err");
              disconnect(intentional: false);
            },
            onDone: () {
              debugPrint("WS Done");
              disconnect(intentional: false);
            },
          );
          return;
        }
      }

      debugPrint("WS Error: All WebSocket candidates failed.");
      disconnect(intentional: false);
    } finally {
      _isConnecting = false;
    }
  }

  void disconnect({bool intentional = true}) {
    if (intentional) {
      _isIntentionalDisconnect = true;
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
    }

    _isConnected = false;
    _wsSubscription?.cancel();
    _wsSubscription = null;
    _channel?.sink.close();
    _channel = null;
    _messageStreamController?.close();
    _messageStreamController = null;
    notifyListeners();

    if (!intentional && !_isIntentionalDisconnect) {
      _reconnectTimer?.cancel();
      debugPrint(
        "WS: Unintentional disconnect detected. Scheduling reconnect in 4 seconds...",
      );
      _reconnectTimer = Timer(const Duration(seconds: 4), () {
        if (!_isConnected && !_isIntentionalDisconnect) {
          debugPrint("WS: Reconnecting now...");
          connect();
        }
      });
    }
  }

  void _sendFrame(Map<String, dynamic> frame) {
    if (_channel != null && _isConnected) {
      final encoded = json.encode(frame);
      debugPrint("WS Sending: $encoded");
      _channel!.sink.add(encoded);
    }
  }

  void sendAuth(String token) {
    _sendFrame({'type': 'AUTH', 'token': token});
  }

  void sendRefreshToken(String newToken) {
    _sendFrame({'type': 'REFRESH_TOKEN', 'token': newToken});
  }

  void startViewing(String roomId) {
    _currentViewingRoomId = roomId;
    // Align with guide: 'room_id' instead of 'roomId'
    _sendFrame({'type': 'VIEWING', 'room_id': roomId});
  }

  void stopViewing(String roomId) {
    if (_currentViewingRoomId == roomId) {
      _currentViewingRoomId = null;
    }
    // Align with guide: 'LEAVING' without arguments
    _sendFrame({'type': 'LEAVING'});
  }

  void sendMessage(String roomId, String text, {String? imageUrl}) {
    // Align with guide: 'room_id', 'content', 'image_url', 'reply_to'
    _sendFrame({
      'type': 'MESSAGE',
      'room_id': roomId,
      'content': text.isEmpty ? null : text,
      'image_url': imageUrl,
      'reply_to': null,
    });

    // Notify local chat list to refresh optimistically
    _messageStreamController?.add({'type': 'MESSAGE_SENT', 'room_id': roomId});
  }

  void markAsRead(String messageId) {
    markMessagesAsRead([messageId]);
  }

  void markMessagesAsRead(List<String> messageIds) {
    if (messageIds.isEmpty) return;
    _sendFrame({'type': 'MARK_READ', 'message_ids': messageIds});
  }

  Future<void> _handleTokenExpiring() async {
    debugPrint("WS received TOKEN_EXPIRING. Refreshing token via REST API...");
    try {
      // 1. Call REST API via AuthRepository to get a fresh accessToken
      await sl<AuthRepository>().refreshToken();
      // 2. Fetch the fresh new accessToken from secure storage
      final freshToken = await authLocalDataSource.getAccessToken();
      if (freshToken != null) {
        debugPrint("WS sending fresh REFRESH_TOKEN frame...");
        sendRefreshToken(freshToken);
      }
    } catch (e) {
      debugPrint("WS handle token expiring failed: $e");
      final errorStr = e.toString().toLowerCase();
      // If it's a network error, we shouldn't log out. Only log out if it's an API/Auth error
      if (!errorStr.contains('socketexception') &&
          !errorStr.contains('timeoutexception')) {
        debugPrint("WS token refresh failed due to auth error. Logging out...");
        await sl<AuthRepository>().logout();
        sl<AuthViewModel>().clearUser();
        appRouter.go(Routes.login);
      }
    }
  }
}
