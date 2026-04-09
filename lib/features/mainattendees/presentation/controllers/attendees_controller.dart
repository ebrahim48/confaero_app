// lib/features/attendees/controllers/attendees_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/services/socket_service.dart';
import '../../domain/services/attendee_service.dart';
import '../../data/models/attendee_model.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class AttendeesController extends GetxController {
  final AttendeeService _attendeeService = Get.find<AttendeeService>();
  final SocketService _socketService = Get.find<SocketService>();
  final TextEditingController searchController = TextEditingController();

  // Total stats
  final RxInt totalAttendees = 0.obs;
  final RxInt bookmarkedCount = 0.obs;

  // Attendees list
  final RxList<AttendeeModel> attendees = <AttendeeModel>[].obs;
  final RxList<AttendeeModel> filteredAttendees = <AttendeeModel>[].obs;

  // Filter state
  final RxBool showBookmarkedOnly = false.obs;

  // Socket subscriptions
  StreamSubscription<Map<String, dynamic>>? _onlineSubscription;
  StreamSubscription<Map<String, dynamic>>? _offlineSubscription;

  @override
  void onInit() {
    super.onInit();
    loadAttendees();

    // Listen to search
    searchController.addListener(() {
      filterAttendees();
    });

    // Listen to Socket.IO for real-time online/offline updates
    _onlineSubscription = _socketService.onUserOnline.listen(_handleUserOnline);
    _offlineSubscription = _socketService.onUserOffline.listen(_handleUserOffline);
  }

  /// Handle user coming online
  void _handleUserOnline(Map<String, dynamic> data) {
    final userId = data['userId']?.toString() ?? '';
    if (userId.isNotEmpty) {
      // Mark attendee as online
      final index = attendees.indexWhere((a) => a.id == userId);
      if (index != -1) {
        attendees[index].isOnline = true;
        attendees.refresh();
        filteredAttendees.refresh();
      }
    }
  }

  /// Handle user going offline
  void _handleUserOffline(Map<String, dynamic> data) {
    final userId = data['userId']?.toString() ?? '';
    if (userId.isNotEmpty) {
      // Mark attendee as offline
      final index = attendees.indexWhere((a) => a.id == userId);
      if (index != -1) {
        attendees[index].isOnline = false;
        attendees.refresh();
        filteredAttendees.refresh();
      }
    }
  }

  /// Check if a specific attendee is online
  bool isUserOnline(String userId) => _socketService.isUserOnline(userId);

  /// Load all attendees
  Future<void> loadAttendees() async {
    try {
      final eventId = SessionController.to.eventId;
      if (eventId.isEmpty) return;
      
      final response = await _attendeeService.getEventAttendees(
        eventId,
        bookmarkedOnly: showBookmarkedOnly.value,
      );

      attendees.value = response.attendees;
      totalAttendees.value = response.total;
      bookmarkedCount.value = response.bookmarkedCount;
      filteredAttendees.value = attendees;

      // Show message if no attendees available
      if (attendees.isEmpty) {
        ToastMessageHelper.showToastMessage(
          'Attendees list coming soon. Check back later!',
          title: 'Info',
        );
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage(
        'Attendees list coming soon. Check back later!',
        title: 'Info',
      );
    }
  }

  /// Toggle between all and bookmarked view
  Future<void> toggleBookmarkedFilter() async {
    showBookmarkedOnly.value = !showBookmarkedOnly.value;
    await loadAttendees();
  }

  /// Filter attendees by search query
  void filterAttendees() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredAttendees.value = attendees;
    } else {
      filteredAttendees.value = attendees
          .where((a) =>
              a.name.toLowerCase().contains(query) ||
              a.company.toLowerCase().contains(query) ||
              a.role.toLowerCase().contains(query))
          .toList();
    }
  }

  /// Toggle bookmark for an attendee
  Future<void> toggleBookmark(String id) async {
    final index = attendees.indexWhere((a) => a.id == id);
    if (index == -1) return;

    final attendee = attendees[index];
    final eventId = SessionController.to.eventId;

    try {
      final newBookmarkStatus = await _attendeeService.bookmarkAttendee(
        eventId,
        id,
      );
      
      // Update local state
      attendee.isBookmarked = newBookmarkStatus;
      attendees.refresh();
      
      // Refresh the list to get updated counts
      await loadAttendees();
      
      ToastMessageHelper.showToastMessage(
        newBookmarkStatus ? 'Added to bookmarks' : 'Removed from bookmarks',
        title: 'Bookmark',
      );
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to update bookmark', title: 'Error');
    }
  }

  /// Say Hi - send connection request
  void sayHi(String name, String attendeeId) {
    ToastMessageHelper.showToastMessage(
      'Connection request sent to $name',
      title: 'Connection',
    );
    // TODO: Implement actual connection request API
  }

  /// Send Email
  void sendMail(String email) {
    ToastMessageHelper.showToastMessage(
      'Opening email client...',
      title: 'Email',
    );
    // TODO: Use url_launcher to open mailto: link
  }

  @override
  void onClose() {
    searchController.dispose();
    _onlineSubscription?.cancel();
    _offlineSubscription?.cancel();
    super.onClose();
  }
}
