import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../connection/domain/services/connection_service.dart';
import '../../../message/presentation/widgets/view/message_chat_screen.dart';
import '../../domain/services/attendee_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

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
      final err = e.toString();
      if (!err.contains('404') && !err.contains('500')) {
        ToastMessageHelper.showToastMessage('Failed to load attendee details', title: 'Error');
      }
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
      ToastMessageHelper.showToastMessage(
        (!prev) ? 'Added to bookmarks' : 'Removed from bookmarks',
        title: 'Bookmark',
      );
    } catch (_) {
      attendeeDetails['isBookmarked'] = prev;
      attendeeDetails.refresh();
      ToastMessageHelper.showToastMessage('Could not update bookmark', title: 'Error');
    }
  }

  void sayHi() {
    final accountId = attendeeDetails['accountId']?.toString() ?? '';
    final id = attendeeDetails['id']?.toString() ?? '';
    final receiverId = accountId.isNotEmpty ? accountId : id;
    if (receiverId.isEmpty) {
      ToastMessageHelper.showToastMessage('Unable to message: ID not available', title: 'Error');
      return;
    }
    Get.to(
      () => MessageChatScreen(
        receiverId: receiverId,
        receiverName: attendeeDetails['name']?.toString() ?? 'Attendee',
        receiverImage: attendeeDetails['image']?.toString() ?? '',
      ),
      preventDuplicates: false,
    );
  }

  Future<void> sendMail() async {
    final email = attendeeDetails['email']?.toString() ?? '';
    if (email.isEmpty) {
      ToastMessageHelper.showToastMessage('Email not available', title: 'Info');
      return;
    }
    await launchUrl(Uri.parse('mailto:$email'));
  }

  Future<void> requestToConnect(String eventId, String receiverId) async {
    if (receiverId.isEmpty) {
      ToastMessageHelper.showToastMessage('Unable to send request: ID not available', title: 'Error');
      return;
    }
    isRequesting.value = true;
    try {
      await _connectionService.sendRequest(eventId, receiverId: receiverId);
      ToastMessageHelper.showToastMessage('Connection request sent!', title: 'Success');
    } catch (e) {
      if (!e.toString().contains('404')) {
        ToastMessageHelper.showToastMessage('Failed to send request', title: 'Error');
      } else {
        ToastMessageHelper.showToastMessage('Connection feature coming soon!', title: 'Info');
      }
    } finally {
      isRequesting.value = false;
    }
  }
}
