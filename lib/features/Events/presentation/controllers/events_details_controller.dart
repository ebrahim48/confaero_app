import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/events_repository.dart';
import '../../domain/services/events_service.dart';

class EventDetailsController extends GetxController {
  late final EventsRepository _repository;

  final invitationCodeController = TextEditingController();

  final isLoading = false.obs;
  final isRegistering = false.obs;
  final showInvitationInput = false.obs;

  final event = Rxn<EventModel>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Build dependency chain internally — no Get.find<EventsRepository> needed
    _repository = EventsRepository(
      eventsService: EventsService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
    );
  }

  @override
  void onClose() {
    invitationCodeController.dispose();
    super.onClose();
  }

  Future<void> loadEvent(String eventId) async {
    if (eventId.isEmpty) return;
    try {
      isLoading.value = true;
      errorMessage.value = '';
      event.value = await _repository.getEventDetails(eventId);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void openMap() async {
    final mapLink = event.value?.googleMapLink;
    Uri url;
    if (mapLink != null && mapLink.isNotEmpty) {
      url = Uri.parse(mapLink);
    } else {
      final location = Uri.encodeComponent(event.value?.location ?? '');
      url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$location');
    }
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Map launch error: $e');
    }
  }

  void registerNow(BuildContext context) async {
    final eventId = event.value?.id;
    if (eventId == null || eventId.isEmpty) return;

    try {
      isRegistering.value = true;
      errorMessage.value = '';

      final result = await _repository.initiateRegistration(eventId);

      if (result != null) {
        final status = result['status'] as String? ?? '';
        ToastMessageHelper.showToastMessage(
          status == 'VERIFIED'
              ? 'Successfully registered!'
              : 'Registration submitted. Status: $status',
          title: 'Success',
        );
        await loadEvent(eventId);
        await Future.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          context.goNamed(AppRoutes.mainNavigationScreen);
        }
      }
    } catch (e) {
      // Cleans "Exception: " prefix and shows the real server message
      final msg = e.toString()
          .replaceAll('Exception: ', '')
          .replaceAll('Exception:', '')
          .trim();
      errorMessage.value = msg;
      ToastMessageHelper.showToastMessage(msg, title: 'Error');
    } finally {
      isRegistering.value = false;
    }
  }

  void toggleInvitationInput() {
    showInvitationInput.value = !showInvitationInput.value;
  }

  void joinWithInvitationCode() async {
    if (invitationCodeController.text.trim().isEmpty) {
      ToastMessageHelper.showToastMessage(
        'Please enter an invitation code',
        title: 'Error',
      );
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
  }

  bool get isAlreadyRegistered =>
      event.value?.registrationStatus == 'VERIFIED' ||
          event.value?.registrationStatus == 'PENDING';

  String get registrationStatusLabel {
    switch (event.value?.registrationStatus) {
      case 'VERIFIED':
        return 'Registered';
      case 'PENDING':
        return 'Pending';
      default:
        return '';
    }
  }
}