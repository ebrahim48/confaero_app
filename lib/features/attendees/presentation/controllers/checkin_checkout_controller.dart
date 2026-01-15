
import 'package:get/get.dart';

class CheckInOutController extends GetxController {
  final isLoading = false.obs;
  final checkInTime = ''.obs;
  final checkOutTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Load check in/out times if available
    checkInTime.value = '10:01 am, June 10, 2025';
    checkOutTime.value = '1:01 pm, June 10, 2025';
  }

  void checkInViaQRCode() async {
    isLoading.value = true;

    // TODO: Open QR scanner
    // TODO: API call to check in

    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    // Update check in time
    checkInTime.value = DateTime.now().toString();
  }

  void checkInVirtual() async {
    isLoading.value = true;

    // TODO: API call to check in virtually

    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    // Update check in time
    checkInTime.value = DateTime.now().toString();
  }

  void contactUs() {
    // Navigate to contact/support screen
  }
}