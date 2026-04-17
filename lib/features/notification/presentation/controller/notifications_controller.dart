import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/socket_service.dart';
import '../../../connection/domain/services/connection_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

// Notification Model
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final String? avatarUrl;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.avatarUrl,
    this.isRead = false,
  });
}

class NotificationsController extends GetxController {
  final SocketService _socketService = Get.find<SocketService>();

  // Search controller
  final searchController = TextEditingController();

  // Notifications list
  final notifications = <NotificationItem>[].obs;

  // Loading state
  final isLoading = false.obs;

  // Filtered notifications
  final filteredNotifications = <NotificationItem>[].obs;

  // Socket subscription
  StreamSubscription<Map<String, dynamic>>? _notificationSubscription;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();

    // Listen for real-time notifications via Socket.IO
    _notificationSubscription = _socketService.onNewNotification.listen(_handleSocketNotification);
  }

  /// Handle a real-time notification from Socket.IO.
  void _handleSocketNotification(Map<String, dynamic> data) {
    final notification = NotificationItem(
      id: data['_id']?.toString() ?? data['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: data['title']?.toString() ?? 'New Notification',
      message: data['message']?.toString() ?? data['body']?.toString() ?? '',
      time: 'Just now',
      avatarUrl: data['avatarUrl']?.toString(),
    );

    // Add to the top of the list
    notifications.insert(0, notification);
    filteredNotifications.insert(0, notification);
  }

  @override
  void onClose() {
    _notificationSubscription?.cancel();
    searchController.dispose();
    super.onClose();
  }

  final ConnectionService _connectionService = Get.find<ConnectionService>();

  // Load notifications (Pending Connection Requests)
  Future<void> loadNotifications() async {
    isLoading.value = true;
    try {
      final requests = await _connectionService.getPendingRequests();

      notifications.value =
          requests.map((req) {
            return NotificationItem(
              id: req.id,
              title: 'Connection Request',
              message: '${req.sender.name} has sent you a connection request.',
              time:
                  'Just now', // Can be derived from req.createdAt if available
              avatarUrl:
                  req.sender.avatarUrl.isNotEmpty
                      ? req.sender.avatarUrl
                      : 'assets/images/sampleprofile.png',
            );
          }).toList();

      filteredNotifications.value = notifications;
    } catch (e) {
      ToastMessageHelper.showToastMessage('Could not load connection requests', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptConnection(String requestId) async {
    try {
      await _connectionService.acceptRequest(requestId);
      ToastMessageHelper.showToastMessage('Connection request accepted!', title: 'Success');
      // Refresh the list after accepting
      loadNotifications();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to accept request: $e', title: 'Error');
    }
  }

  // Search notifications
  void searchNotifications(String query) {
    if (query.isEmpty) {
      filteredNotifications.value = notifications;
    } else {
      filteredNotifications.value =
          notifications
              .where(
                (notification) =>
                    notification.title.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    notification.message.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
    }
  }

  // Mark as read
  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      // In real app, update backend
      print('Notification $id marked as read');
    }
  }

  // Delete notification
  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    filteredNotifications.removeWhere((n) => n.id == id);

    ToastMessageHelper.showToastMessage('Notification removed', title: 'Deleted');
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    loadNotifications();
  }
}
