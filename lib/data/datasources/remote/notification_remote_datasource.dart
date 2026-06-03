import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/notification_list_item_model.dart';
import '../../models/api_response.dart';
import '../local/auth_local_datasource.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationListItemModel>> getNotifications({
    int page = 1,
    int limit = 20,
    int? categoryId,
  });

  Future<int> getUnreadCount();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  static final String _baseURL = dotenv.get("BASE_URL");

  NotificationRemoteDataSourceImpl({
    required this.client,
    required this.authLocalDataSource,
  });

  Future<Map<String, String>> _getHeaders() async {
    final token = await authLocalDataSource.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<NotificationListItemModel>> getNotifications({
    int page = 1,
    int limit = 20,
    int? categoryId,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (categoryId != null) {
      queryParams['categoryId'] = categoryId.toString();
    }

    final uri = Uri.parse(
      '$_baseURL/notifications',
    ).replace(queryParameters: queryParams);
    final headers = await _getHeaders();

    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        jsonMap,
        (data) => data as List<dynamic>,
      );

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        return apiResponse.data!
            .map(
              (e) =>
                  NotificationListItemModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception(apiResponse.message ?? 'Failed to fetch notifications');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  @override
  Future<int> getUnreadCount() async {
    final uri = Uri.parse('$_baseURL/notifications/unread-count');
    final headers = await _getHeaders();

    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      // Support both { data: N } and { data: { unreadCount: N } }
      final data = jsonMap['data'];
      if (data is int) return data;
      if (data is Map && data['unreadCount'] != null) {
        return (data['unreadCount'] as num).toInt();
      }
      return 0;
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
