import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/qr_service.dart';
import '../../../../core/services/volunteer_service.dart';
import '../../data/models/volunteer_models.dart';

class CheckInHistoryController extends GetxController {
  final VolunteerService _service = Get.find<VolunteerService>();
  final QrService _qrService = Get.find<QrService>();

  final totalCheckedIn = 0.obs;
  final lastScans = <LastScanModel>[].obs;
  final isLoading = false.obs;
  final isCheckingIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final eventId = SessionController.to.eventId;
    if (eventId.isEmpty) return;
    try {
      isLoading.value = true;
      final result = await _service.getVolunteerAttendance(eventId);
      final data = result['data'] as Map<String, dynamic>? ?? {};
      final model = CheckInHistoryModel.fromJson(data);
      totalCheckedIn.value = model.totalCheckedIn;
      lastScans.value = model.lastScans;
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkIn(String qrToken) async {
    final eventId = SessionController.to.eventId;
    if (eventId.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'Select an event before scanning.',
        title: 'Info',
      );
      return;
    }
    try {
      isCheckingIn.value = true;
      await _qrService.scanQR(qrToken, eventId);
      await loadHistory();
      ToastMessageHelper.showToastMessage('Attendee checked in');
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').trim();
      ToastMessageHelper.showToastMessage(
        msg.isEmpty ? 'Check-in failed. Please try again.' : msg,
        title: 'Error',
      );
    } finally {
      isCheckingIn.value = false;
    }
  }
}
