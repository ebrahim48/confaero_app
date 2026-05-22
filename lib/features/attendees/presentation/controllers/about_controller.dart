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

  /// Load terms & conditions — endpoint removed from backend API
  Future<void> loadTermsAndConditions() async {
    // REMOVED: appContent/TERMS_CONDITION endpoint no longer available
    termsContent.value = 'Terms and conditions will be available soon.';
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
