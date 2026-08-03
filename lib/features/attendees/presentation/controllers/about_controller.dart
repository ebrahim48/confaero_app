import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/content_service.dart';

class AboutUsController extends GetxController {
  final ContentService _contentService = Get.find<ContentService>();

  final RxString termsContent = ''.obs;
  final RxBool isLoading = false.obs;

  void onStartNewEvent(BuildContext context) {
    context.pushNamed(AppRoutes.newEventProposalScreen);
  }

  Future<void> onSupportEmailTap() async {
    final uri = Uri.parse('mailto:${AppConstants.supportEmail}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ToastMessageHelper.showToastMessage(
        'No email app found. Write to us at ${AppConstants.supportEmail}',
        title: 'Info',
      );
    }
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
