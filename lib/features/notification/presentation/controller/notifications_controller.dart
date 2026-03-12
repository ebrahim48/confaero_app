import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../connection/domain/services/connection_service.dart';

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
  // Search controller
  final searchController = TextEditingController();

  // Notifications list
  final notifications = <NotificationItem>[].obs;

  // Loading state
  final isLoading = false.obs;

  // Filtered notifications
  final filteredNotifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  @override
  void onClose() {
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
      Get.snackbar(
        'Error',
        'Could not load connection requests',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptConnection(String requestId) async {
    try {
      await _connectionService.acceptRequest(requestId);
      Get.snackbar(
        'Success',
        'Connection request accepted!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff32A69A),
        colorText: Colors.white,
      );
      // Refresh the list after accepting
      loadNotifications();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to accept request: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
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

    Get.snackbar(
      'Deleted',
      'Notification removed',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    loadNotifications();
  }
}
