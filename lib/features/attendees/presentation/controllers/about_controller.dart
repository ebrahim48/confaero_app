import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/content_service.dart';

class AboutUsController extends GetxController {
  final ContentService _contentService = Get.find<ContentService>();

  final RxString termsContent = ''.obs;
  final RxBool isLoading = false.obs;

  void onStartNewEvent(BuildContext context) {
    context.pushNamed(AppRoutes.newEventProposalScreen);
  }

  void onSupportEmailTap() {
    // TODO: Launch email client with support address
  }

  /// Load terms & conditions from API
  Future<void> loadTermsAndConditions() async {
    isLoading.value = true;
    try {
      termsContent.value = await _contentService.getTermsAndConditions();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load terms',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
