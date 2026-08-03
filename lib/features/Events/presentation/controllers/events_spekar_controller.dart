import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../mainattendees/domain/services/attendee_service.dart';
import '../../../message/presentation/widgets/view/message_chat_screen.dart';

class EventSpekarController extends GetxController {
  final AttendeeService _attendeeService = Get.find<AttendeeService>();

  final TextEditingController searchController = TextEditingController();

  final RxInt totalAttendees = 0.obs;
  final RxInt bookmarked = 0.obs;
  final RxBool isLoading = false.obs;

  final RxList<Map<String, dynamic>> attendees = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> allAttendees = <Map<String, dynamic>>[].obs;

  String get currentEventId => SessionController.to.eventId;

  @override
  void onInit() {
    super.onInit();
    loadSpeakers();
    searchController.addListener(() => searchSpeakers(searchController.text));
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadSpeakers() async {
    isLoading.value = true;
    try {
      final response = await _attendeeService.getEventAttendees(
        currentEventId,
        filter: 'SPEAKER',
      );

      final parsed = response.attendees.map((s) => <String, dynamic>{
            'id': s.accountId.isNotEmpty ? s.accountId : s.id,
            'accountId': s.accountId,
            'name': s.name,
            'company': s.company,
            'role': s.role,
            'sessions': '${s.sessionsCount} sessions',
            'image': s.avatarUrl.isNotEmpty ? s.avatarUrl : 'assets/images/profile.png',
            'isBookmarked': s.isBookmarked,
            'email': s.email ?? '',
          }).toList();

      allAttendees.assignAll(parsed);
      attendees.assignAll(parsed);
      totalAttendees.value = response.total;
      bookmarked.value = response.bookmarkedCount;
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void toggleBookmark(String id) {
    final index = attendees.indexWhere((a) => a['id'] == id);
    if (index != -1) {
      attendees[index]['isBookmarked'] = !(attendees[index]['isBookmarked'] as bool);
      attendees.refresh();
      bookmarked.value = attendees.where((a) => a['isBookmarked'] == true).length;
    }
  }

  void searchSpeakers(String query) {
    if (query.isEmpty) {
      attendees.assignAll(allAttendees);
    } else {
      attendees.assignAll(
        allAttendees
            .where((a) =>
                a['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
                a['company'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  void sayHi(BuildContext context, Map<String, dynamic> attendee) {
    final receiverId = attendee['accountId']?.toString().isNotEmpty == true
        ? attendee['accountId'].toString()
        : attendee['id']?.toString() ?? '';
    if (receiverId.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'This speaker cannot be messaged right now.',
        title: 'Info',
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessageChatScreen(
          receiverId: receiverId,
          receiverName: attendee['name']?.toString() ?? 'Speaker',
          receiverImage: attendee['image']?.toString() ?? '',
        ),
      ),
    );
  }

  Future<void> sendMail(String? email) async {
    if (email == null || email.trim().isEmpty) {
      ToastMessageHelper.showToastMessage(
        'No email address is available for this speaker.',
        title: 'Info',
      );
      return;
    }
    final uri = Uri.parse('mailto:${email.trim()}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ToastMessageHelper.showToastMessage(
        'No email app found on this device.',
        title: 'Error',
      );
    }
  }
}
