import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zent_fe/domain/entities/notification_item.dart';
import 'package:zent_fe/domain/entities/enums/user_roles.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/routing/router.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';

/// Handles navigation when a notification is tapped.
/// Supports storing pending notification for deferred navigation (e.g. after app load).
class NotificationNavigator {
  static const String _pendingNotiKey = 'pending_notification_data';

  /// Navigate based on notification data and the current user's role.
  static void navigate(
    BuildContext context,
    NotificationItem notification,
    UserRoles currentRole,
  ) {
    Map<String, dynamic>? data = notification.data;
    if (data != null &&
        data.containsKey('payload') &&
        data['payload'] is String) {
      try {
        data = jsonDecode(data['payload']);
      } catch (_) {}
    }

    final categoryName = notification.categoryName.toLowerCase();

    debugPrint('NotificationNavigator: categoryName=$categoryName, data=$data');

    // Chat / message notifications (all roles)
    if (categoryName.contains('message') || categoryName.contains('chat')) {
      final roomId = (data?['roomId'] ?? data?['room_id'])?.toString();
      if (roomId != null && roomId.isNotEmpty) {
        _navigateToChat(context, roomId, currentRole);
        return;
      }
    }

    // Work order assigned / cancelled notifications
    if (categoryName.contains('assign') ||
        categoryName.contains('cancel') ||
        categoryName.contains('work_order') ||
        categoryName.contains('work order')) {
      final workOrderId = (data?['workOrderId'] ?? data?['work_order_id'])
          ?.toString();
      if (workOrderId != null && workOrderId.isNotEmpty) {
        _navigateToWorkOrder(context, workOrderId, currentRole);
        return;
      }
    }

    // Refusal / rejection notifications
    if (categoryName.contains('refus') || categoryName.contains('reject')) {
      final workOrderId = (data?['workOrderId'] ?? data?['work_order_id'])
          ?.toString();
      if (workOrderId != null && workOrderId.isNotEmpty) {
        _navigateToWorkOrder(context, workOrderId, currentRole);
        return;
      }
    }

    // Rating notifications
    if (categoryName.contains('rat')) {
      // Navigate to work order history
      _navigateToWorkOrderHistory(context, currentRole);
      return;
    }

    // Part request notifications
    if (categoryName.contains('part')) {
      if (currentRole == UserRoles.admin) {
        context.pushNamed(RouteNames.adminPartRequests);
        return;
      }
    }

    // Fallback: navigate to notification list
    _navigateToNotifications(context, currentRole);
  }

  static void _navigateToChat(
    BuildContext context,
    String roomId,
    UserRoles role,
  ) {
    switch (role) {
      case UserRoles.customer:
        context.pushNamed(
          RouteNames.customerDetailedChat,
          pathParameters: {'chatId': roomId},
        );
        break;
      case UserRoles.technician:
        context.pushNamed(
          RouteNames.techDetailedChat,
          pathParameters: {'chatId': roomId},
        );
        break;
      case UserRoles.admin:
      case UserRoles.superAdmin:
        // Admin/SuperAdmin chat: navigate to customer messages with room context
        context.pushNamed(
          RouteNames.customerDetailedChat,
          pathParameters: {'chatId': roomId},
        );
        break;
      default:
        break;
    }
  }

  static void _navigateToWorkOrder(
    BuildContext context,
    String workOrderId,
    UserRoles role,
  ) {
    switch (role) {
      case UserRoles.customer:
        // Navigate to active repairs
        context.pushNamed(RouteNames.customerActiveRepairs);
        break;
      case UserRoles.technician:
        context.pushNamed(
          RouteNames.techWorkOrderDetails,
          pathParameters: {'workOrderId': workOrderId},
        );
        break;
      case UserRoles.admin:
      case UserRoles.superAdmin:
        context.pushNamed(
          RouteNames.adminAssignedWorkOrderDetails,
          pathParameters: {'workOrderId': workOrderId},
        );
        break;
      default:
        break;
    }
  }

  static void _navigateToWorkOrderHistory(
    BuildContext context,
    UserRoles role,
  ) {
    switch (role) {
      case UserRoles.customer:
        context.pushNamed(RouteNames.customerWorkOrderHistory);
        break;
      case UserRoles.technician:
        context.pushNamed(RouteNames.techWorkOrderHistory);
        break;
      case UserRoles.admin:
      case UserRoles.superAdmin:
        context.pushNamed(RouteNames.adminWorkOrderHistory);
        break;
      default:
        break;
    }
  }

  static void _navigateToNotifications(BuildContext context, UserRoles role) {
    switch (role) {
      case UserRoles.customer:
        context.pushNamed(RouteNames.customerNotifications);
        break;
      case UserRoles.technician:
        context.pushNamed(RouteNames.techNotifications);
        break;
      case UserRoles.admin:
      case UserRoles.superAdmin:
        context.pushNamed(RouteNames.adminNotifications);
        break;
      default:
        break;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Deferred navigation: store pending notification, process after app load
  // ─────────────────────────────────────────────────────────────────────────

  /// Save notification data for deferred navigation (e.g. when tapping a push
  /// notification while the app is cold-starting).
  static Future<void> savePendingNotification(
    Map<String, dynamic> notiData,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // The backend nests the actual data inside a JSON string under the 'payload' key
      Map<String, dynamic> parsedData = Map.from(notiData);
      if (notiData.containsKey('payload') && notiData['payload'] is String) {
        try {
          final decoded = jsonDecode(notiData['payload']);
          if (decoded is Map<String, dynamic>) {
            parsedData.addAll(decoded);
          }
        } catch (_) {}
      }

      // Store as JSON-like simple key pairs
      final workOrderId =
          (parsedData['workOrderId'] ?? parsedData['work_order_id'])
              ?.toString() ??
          '';
      final roomId =
          (parsedData['roomId'] ?? parsedData['room_id'])?.toString() ?? '';
      final categoryId = parsedData['categoryId']?.toString() ?? '';
      final categoryName = parsedData['categoryName']?.toString() ?? '';

      await prefs.setString(
        _pendingNotiKey,
        '$workOrderId|$roomId|$categoryId|$categoryName',
      );
    } catch (e) {
      debugPrint('Error saving pending notification: $e');
    }
  }

  /// Retrieve and clear any pending notification data.
  /// Returns null if there is no pending notification.
  static Future<Map<String, String>?> consumePendingNotification() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_pendingNotiKey);
      if (raw == null || raw.isEmpty) return null;

      await prefs.remove(_pendingNotiKey);

      final parts = raw.split('|');
      if (parts.length < 4) return null;

      return {
        'workOrderId': parts[0],
        'roomId': parts[1],
        'categoryId': parts[2],
        'categoryName': parts[3],
      };
    } catch (e) {
      debugPrint('Error consuming pending notification: $e');
      return null;
    }
  }

  /// Process a pending notification after app has loaded.
  /// Call this after login/home screen is ready.
  static Future<void> processPendingNotification(
    BuildContext context,
    UserRoles currentRole,
  ) async {
    final pending = await consumePendingNotification();
    if (pending == null) return;
    if (!context.mounted) return;

    final workOrderId = pending['workOrderId']!;
    final roomId = pending['roomId']!;

    debugPrint(
      'Processing pending notification: $pending for role $currentRole',
    );

    // Verify the notification is still relevant (guard against account mismatch)
    // We can't fully validate account here, but the APIs will return 403 if wrong

    if (roomId.isNotEmpty) {
      _navigateToChat(context, roomId, currentRole);
    } else if (workOrderId.isNotEmpty) {
      _navigateToWorkOrder(context, workOrderId, currentRole);
    } else {
      _navigateToNotifications(context, currentRole);
    }
  }

  /// Process notification immediately using the global appRouter when a push notification is tapped
  /// and the app is already in memory (background state).
  static Future<void> processNotificationDataDirectly(
    Map<String, dynamic> notiData,
  ) async {
    try {
      final authVm = sl<AuthViewModel>();
      final role = authVm.role;
      if (role == UserRoles.unauthenticated) {
        // If not logged in or auth not ready, save it to be processed later by home screen
        savePendingNotification(notiData);
        return;
      }

      Map<String, dynamic> parsedData = Map.from(notiData);
      if (notiData.containsKey('payload')) {
        if (notiData['payload'] is String) {
          try {
            final decoded = jsonDecode(notiData['payload']);
            if (decoded is Map<String, dynamic>) {
              parsedData.addAll(decoded);
            }
          } catch (_) {}
        } else if (notiData['payload'] is Map<String, dynamic>) {
          parsedData.addAll(notiData['payload']);
        } else if (notiData['payload'] is Map) {
          try {
            parsedData.addAll(Map<String, dynamic>.from(notiData['payload']));
          } catch (_) {}
        }
      }

      final workOrderId =
          (parsedData['workOrderId'] ?? parsedData['work_order_id'])
              ?.toString() ??
          '';
      final roomId =
          (parsedData['roomId'] ?? parsedData['room_id'])?.toString() ?? '';

      Future.delayed(const Duration(milliseconds: 300), () {
        if (roomId.isNotEmpty) {
          switch (role) {
            case UserRoles.customer:
              appRouter.pushNamed(
                RouteNames.customerDetailedChat,
                pathParameters: {'chatId': roomId},
              );
              break;
            case UserRoles.technician:
              appRouter.pushNamed(
                RouteNames.techDetailedChat,
                pathParameters: {'chatId': roomId},
              );
              break;
            case UserRoles.admin:
            case UserRoles.superAdmin:
              appRouter.pushNamed(
                RouteNames.customerDetailedChat,
                pathParameters: {'chatId': roomId},
              );
              break;
            default:
              break;
          }
        } else if (workOrderId.isNotEmpty) {
          switch (role) {
            case UserRoles.customer:
              appRouter.pushNamed(RouteNames.customerActiveRepairs);
              break;
            case UserRoles.technician:
              appRouter.pushNamed(
                RouteNames.techWorkOrderDetails,
                pathParameters: {'workOrderId': workOrderId},
              );
              break;
            case UserRoles.admin:
            case UserRoles.superAdmin:
              appRouter.pushNamed(
                RouteNames.adminAssignedWorkOrderDetails,
                pathParameters: {'workOrderId': workOrderId},
              );
              break;
            default:
              break;
          }
        } else {
          switch (role) {
            case UserRoles.customer:
              appRouter.pushNamed(RouteNames.customerNotifications);
              break;
            case UserRoles.technician:
              appRouter.pushNamed(RouteNames.techNotifications);
              break;
            case UserRoles.admin:
            case UserRoles.superAdmin:
              appRouter.pushNamed(RouteNames.adminNotifications);
              break;
            default:
              break;
          }
        }
      });
    } catch (e) {
      debugPrint('Error processing notification data directly: $e');
    }
  }
}
