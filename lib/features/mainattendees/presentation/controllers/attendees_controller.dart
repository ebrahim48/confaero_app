import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/services/socket_service.dart';
import '../../../connection/domain/services/connection_service.dart';
import '../../../message/presentation/widgets/view/message_chat_screen.dart';
import '../../domain/services/attendee_service.dart';
import '../../data/models/attendee_model.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class AttendeesController extends GetxController {
  final AttendeeService _attendeeService = Get.find<AttendeeService>();
  final SocketService _socketService = Get.find<SocketService>();
  final TextEditingController searchController = TextEditingController();

  final RxInt totalAttendees = 0.obs;
  final RxInt bookmarkedCount = 0.obs;
  final RxBool isLoading = false.obs;

  final RxList<AttendeeModel> attendees = <AttendeeModel>[].obs;
  final RxList<AttendeeModel> filteredAttendees = <AttendeeModel>[].obs;

  // '' = all attendees, 'SPEAKER' = speakers only
  final RxString selectedRole = ''.obs;

  StreamSubscription<Map<String, dynamic>>? _onlineSubscription;
  StreamSubscription<Map<String, dynamic>>? _offlineSubscription;

  @override
  void onInit() {
    super.onInit();
    loadAttendees();
    searchController.addListener(filterAttendees);
    _onlineSubscription = _socketService.onUserOnline.listen(_handleUserOnline);
    _offlineSubscription = _socketService.onUserOffline.listen(_handleUserOffline);
  }

  void _handleUserOnline(Map<String, dynamic> data) {
    final userId = data['userId']?.toString() ?? '';
    if (userId.isNotEmpty) {
      final index = attendees.indexWhere((a) => a.accountId == userId || a.id == userId);
      if (index != -1) {
        attendees[index].isOnline = true;
        attendees.refresh();
        filteredAttendees.refresh();
      }
    }
  }

  void _handleUserOffline(Map<String, dynamic> data) {
    final userId = data['userId']?.toString() ?? '';
    if (userId.isNotEmpty) {
      final index = attendees.indexWhere((a) => a.accountId == userId || a.id == userId);
      if (index != -1) {
        attendees[index].isOnline = false;
        attendees.refresh();
        filteredAttendees.refresh();
      }
    }
  }

  bool isUserOnline(String userId) => _socketService.isUserOnline(userId);

  Future<void> loadAttendees() async {
    isLoading.value = true;
    try {
      final eventId = SessionController.to.eventId;
      if (eventId.isEmpty) return;

      final filter = selectedRole.value.isNotEmpty ? selectedRole.value : null;
      final response = await _attendeeService.getEventAttendees(
        eventId,
        filter: filter,
      );

      attendees.value = response.attendees;
      totalAttendees.value = response.total;
      bookmarkedCount.value = response.bookmarkedCount;
      filteredAttendees.value = attendees;
    } catch (e) {
      attendees.clear();
      filteredAttendees.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectRole(String role) async {
    selectedRole.value = role;
    await loadAttendees();
  }

  Future<void> refreshAttendees() async => loadAttendees();

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

  Future<void> toggleBookmark(AttendeeModel attendee) async {
    final eventId = SessionController.to.eventId;
    final bookmarkId = attendee.accountId.isNotEmpty ? attendee.accountId : attendee.id;
    final prev = attendee.isBookmarked;
    attendee.isBookmarked = !prev;
    attendees.refresh();
    filteredAttendees.refresh();
    try {
      await _attendeeService.bookmarkAttendee(eventId, bookmarkId);
      bookmarkedCount.value = attendees.where((a) => a.isBookmarked).length;
    } catch (_) {
      attendee.isBookmarked = prev;
      attendees.refresh();
      filteredAttendees.refresh();
      ToastMessageHelper.showToastMessage('Failed to update bookmark', title: 'Error');
    }
  }

  void sayHi(BuildContext context, AttendeeModel attendee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessageChatScreen(
          receiverId: attendee.accountId.isNotEmpty ? attendee.accountId : attendee.id,
          receiverName: attendee.name,
          receiverImage: attendee.avatarUrl,
        ),
      ),
    );
  }

  Future<void> sendMail(String? email) async {
    if (email == null || email.isEmpty) {
      ToastMessageHelper.showToastMessage('Email not available', title: 'Info');
      return;
    }
    final uri = Uri.parse('mailto:$email');
    if (!await launchUrl(uri)) {
      ToastMessageHelper.showToastMessage('Could not open mail app', title: 'Error');
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    _onlineSubscription?.cancel();
    _offlineSubscription?.cancel();
    super.onClose();
  }
}
