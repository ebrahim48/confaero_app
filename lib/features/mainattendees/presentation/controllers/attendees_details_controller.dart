// lib/features/attendees/controllers/attendee_details_controller.dart
import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../connection/domain/services/connection_service.dart';
import '../../domain/services/attendee_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class AttendeeDetailsController extends GetxController {
  final AttendeeService _attendeeService = Get.find<AttendeeService>();

  final RxBool isLoading = false.obs;

  // Attendee details
  final RxMap<String, dynamic> attendeeDetails =
      <String, dynamic>{
        'name': '',
        'company': '',
        'role': 'Attendee',
        'sessions': '0 sessions',
        'image': 'assets/images/sampleprofile.png',
        'email': '',
        'phone': '',
        'location': '',
        'isBookmarked': false,
      }.obs;

  /// Call this from the screen, passing eventId and attendeeId from route args
  Future<void> loadAttendeeDetails(String eventId, String attendeeId) async {
    isLoading.value = true;
    try {
      final details = await _attendeeService.getAttendeeDetails(
        eventId,
        attendeeId,
      );
      if (details != null) {
        attendeeDetails.assignAll({
          'id': details.id,
          'name': details.name,
          'company': details.company,
          'role': details.role,
          'sessions': '${details.sessionsCount} sessions',
          'image':
              details.avatarUrl.isNotEmpty
                  ? details.avatarUrl
                  : 'assets/images/sampleprofile.png',
          'email': details.email ?? '',
          'phone': details.phone ?? '',
          'location': details.location ?? '',
          'isBookmarked': details.isBookmarked,
          'canMessage': details.role != 'ATTENDEE' ? false : true,
          'canEmail': details.email?.isNotEmpty ?? false,
        });
      } else {
        ToastMessageHelper.showToastMessage(
          'Unable to load attendee details',
          title: 'Error',
        );
      }
    } catch (e) {
      print('Error loading attendee details: $e');
      final errorStr = e.toString();
      
      // Don't show error for 404 or 500 - backend routes might not exist yet
      if (errorStr.contains('404') || errorStr.contains('500') || errorStr.contains('ServerException')) {
        // Silently fail - show empty/default data instead
        print('Backend route not available, showing default data');
      } else {
        ToastMessageHelper.showToastMessage(
          'Failed to load attendee details',
          title: 'Error',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle bookmark
  Future<void> toggleBookmark() async {
    final attendeeId = attendeeDetails['id']?.toString() ?? '';
    if (attendeeId.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'Unable to bookmark: Attendee ID not available',
        title: 'Error',
      );
      return;
    }

    final wasBookmarked = attendeeDetails['isBookmarked'] ?? false;

    try {
      final newStatus = await _attendeeService.bookmarkAttendee(
        SessionController.to.eventId,
        attendeeId,
      );

      attendeeDetails['isBookmarked'] = newStatus;
      attendeeDetails.refresh();

      ToastMessageHelper.showToastMessage(
        newStatus ? 'Added to bookmarks' : 'Removed from bookmarks',
        title: 'Bookmark',
      );
    } catch (e) {
      attendeeDetails['isBookmarked'] = wasBookmarked;
      attendeeDetails.refresh();
      ToastMessageHelper.showToastMessage(
        'Failed to update bookmark: $e',
        title: 'Error',
      );
    }
  }

  // Say Hi
  void sayHi() {
    print('Say Hi');
  }

  // Send Mail
  void sendMail() {
    print('Send Mail to ${attendeeDetails['email']}');
  }

  final ConnectionService _connectionService = Get.find<ConnectionService>();
  final RxBool isRequesting = false.obs;

  // Request to Connect
  Future<void> requestToConnect(String eventId, String receiverId) async {
    if (receiverId.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'Unable to send request: Attendee ID not available',
        title: 'Error',
      );
      return;
    }

    isRequesting.value = true;
    try {
      await _connectionService.sendRequest(eventId, receiverId: receiverId);
      ToastMessageHelper.showToastMessage('Connection request sent!', title: 'Success');
    } catch (e) {
      print('Error sending connection request: $e');
      // Don't show error for 404 - backend route might not exist yet
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
