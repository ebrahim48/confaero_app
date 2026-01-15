import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/approutes/app_routes.dart';

class EventDetailsController extends GetxController {
  final invitationCodeController = TextEditingController();
  final isRegistered = false.obs;
  final showInvitationInput = false.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    invitationCodeController.dispose();
    super.onClose();
  }

  void toggleInvitationInput() {
    showInvitationInput.value = !showInvitationInput.value;
  }

  void openMap() async {
    // Montreal Convention Centre coordinates
    const latitude = 23.8103;
    const longitude = 90.4125;

    // Google Maps URL with API key
    final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&key=AIzaSyDFiKLw_sSi4BAjNEBe1HYIqG-FDAs86Kk'
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to basic Google Maps URL
        final fallbackUrl = Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude'
        );
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error opening map: $e');
    }
  }

  void joinWithInvitationCode() async {
    if (invitationCodeController.text.isEmpty) {
      // Show error
      return;
    }

    isLoading.value = true;

    // TODO: API Integration for joining with invitation code
    // await eventService.joinWithCode(invitationCodeController.text);

    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    // Success - navigate or show success message
  }

  void registerNow(BuildContext context) async {
    isLoading.value = true;

    // TODO: API Integration for event registration
    // await eventService.registerEvent();

    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    context.pushNamed(AppRoutes.mainNavigationScreen);
    // Navigate to registration form or success screen
  }
}