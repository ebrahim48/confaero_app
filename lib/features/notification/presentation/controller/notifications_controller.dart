import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  // Load notifications (static data)
  void loadNotifications() {
    isLoading.value = true;

    // Static notification template
    final notificationTemplate = {
      'title': 'Rehearsal for Event!',
      'message': 'Rehearsal for Event will be held tomorrow...',
      'avatarUrl': 'assets/images/profile.png',
    };

    // Generate 9 notifications (6 with "5:35 pm", 3 with "29/12/26")
    notifications.value = [
      // 6 notifications with time "5:35 pm"
      ...List.generate(
        6,
            (index) => NotificationItem(
          id: '${index + 1}',
          title: notificationTemplate['title']!,
          message: notificationTemplate['message']!,
          time: '5:35 pm',
          avatarUrl: notificationTemplate['avatarUrl'],
          isRead: false,
        ),
      ),
      // 3 notifications with date "29/12/26"
      ...List.generate(
        3,
            (index) => NotificationItem(
          id: '${index + 7}',
          title: notificationTemplate['title']!,
          message: notificationTemplate['message']!,
          time: '29/12/26',
          avatarUrl: notificationTemplate['avatarUrl'],
          isRead: false,
        ),
      ),
    ];

    filteredNotifications.value = notifications;
    isLoading.value = false;
  }

  // Search notifications
  void searchNotifications(String query) {
    if (query.isEmpty) {
      filteredNotifications.value = notifications;
    } else {
      filteredNotifications.value = notifications
          .where((notification) =>
      notification.title.toLowerCase().contains(query.toLowerCase()) ||
          notification.message.toLowerCase().contains(query.toLowerCase()))
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