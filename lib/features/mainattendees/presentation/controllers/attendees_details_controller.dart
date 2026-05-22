import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../connection/domain/services/connection_service.dart';
import '../../../message/presentation/widgets/view/message_chat_screen.dart';
import '../../domain/services/attendee_service.dart';

class AttendeeDetailsController extends GetxController {
  final AttendeeService _attendeeService = Get.find<AttendeeService>();
  final ConnectionService _connectionService = Get.find<ConnectionService>();

  final RxBool isLoading = false.obs;
  final RxBool isRequesting = false.obs;

  final RxMap<String, dynamic> attendeeDetails = <String, dynamic>{
    'id': '',
    'accountId': '',
    'name': '',
    'company': '',
    'role': 'Attendee',
    'sessions': '0 sessions',
    'image': '',
    'email': '',
    'phone': '',
    'location': '',
    'isBookmarked': false,
  }.obs;

  Future<void> loadAttendeeDetails(String eventId, String accountId) async {
    isLoading.value = true;
    try {
      final details = await _attendeeService.getAttendeeDetails(eventId, accountId);
      if (details != null) {
        attendeeDetails.assignAll({
          'id': details.id,
          'accountId': details.accountId.isNotEmpty ? details.accountId : accountId,
          'name': details.name,
          'company': details.company,
          'role': details.role,
          'sessions': '${details.sessionsCount} sessions',
          'image': details.avatarUrl.isNotEmpty ? details.avatarUrl : '',
          'email': details.email ?? '',
          'phone': details.phone ?? '',
          'location': details.location ?? '',
          'isBookmarked': details.isBookmarked,
        });
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleBookmark() async {
    final accountId = attendeeDetails['accountId']?.toString() ?? '';
    final id = attendeeDetails['id']?.toString() ?? '';
    final bookmarkId = accountId.isNotEmpty ? accountId : id;
    if (bookmarkId.isEmpty) return;

    final prev = attendeeDetails['isBookmarked'] as bool? ?? false;
    attendeeDetails['isBookmarked'] = !prev;
    attendeeDetails.refresh();

    try {
      await _attendeeService.bookmarkAttendee(SessionController.to.eventId, bookmarkId);
    } catch (_) {
      attendeeDetails['isBookmarked'] = prev;
      attendeeDetails.refresh();
    }
  }

  void sayHi(BuildContext context) {
    final accountId = attendeeDetails['accountId']?.toString() ?? '';
    final id = attendeeDetails['id']?.toString() ?? '';
    final receiverId = accountId.isNotEmpty ? accountId : id;
    if (receiverId.isEmpty) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessageChatScreen(
          receiverId: receiverId,
          receiverName: attendeeDetails['name']?.toString() ?? 'Attendee',
          receiverImage: attendeeDetails['image']?.toString() ?? '',
        ),
      ),
    );
  }

  Future<void> sendMail() async {
    final email = attendeeDetails['email']?.toString() ?? '';
    if (email.isEmpty) {
      return;
    }
    final uri = Uri.parse('mailto:$email');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    }
  }

  Future<void> requestToConnect(String eventId, String receiverId) async {
    if (receiverId.isEmpty) {
      return;
    }
    isRequesting.value = true;
    try {
      await _connectionService.sendRequest(eventId, receiverId: receiverId);
    } catch (e) {
      if (!e.toString().contains('404')) {
      } else {
      }
    } finally {
      isRequesting.value = false;
    }
  }
}
