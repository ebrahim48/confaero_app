import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/controllers/role_controller.dart';
import '../../../../../core/controllers/session_controller.dart';
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
  final isJoining = false.obs;
  final showInvitationInput = false.obs;

  final event = Rxn<EventModel>();
  final errorMessage = ''.obs;
  
  // Registration status passed from EventsScreen (for "My Events" tab)
  final RxString registrationStatus = ''.obs;

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

  Future<void> loadEvent(String eventId, {String status = '', String role = ''}) async {
    if (eventId.isEmpty) return;
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (status.isNotEmpty) {
        registrationStatus.value = status;
      }
      // Pre-set role from event registration (e.g., EXHIBITOR)
      if (role.trim().isNotEmpty) {
        await RoleController.to.setRole(role.trim());
      }

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
    final currentEvent = event.value;
    final eventId = currentEvent?.id;
    if (eventId == null || eventId.isEmpty) return;

    // Pre-validate paid events before hitting the API
    final paymentType = currentEvent?.paymentType?.toUpperCase() ?? '';
    final price = currentEvent?.price ?? 0.0;
    final isPaidEvent = paymentType == 'STRIPE' || paymentType == 'PAID';

    if (isPaidEvent && price <= 0) {
      const msg = 'This event has incomplete pricing setup. Please contact the organizer.';
      errorMessage.value = msg;
      ToastMessageHelper.showToastMessage(msg, title: 'Registration Failed');
      return;
    }

    if (isPaidEvent && price > 0) {
      const msg = 'This event requires payment. Online payment integration is coming soon. Please contact the organizer to register.';
      errorMessage.value = msg;
      ToastMessageHelper.showToastMessage(msg, title: 'Payment Required');
      return;
    }

    try {
      isRegistering.value = true;
      errorMessage.value = '';

      final result = await _repository.initiateRegistration(eventId, price: price);

      if (result != null) {
        final status = result['status'] as String? ?? '';
        // Update role from event registration if available
        final eventRole = (result['role'] ?? result['activeRole']) as String?;
        if (eventRole != null && eventRole.trim().isNotEmpty) {
          await RoleController.to.setRole(eventRole.trim());
        }
        ToastMessageHelper.showToastMessage(
          status == 'VERIFIED'
              ? 'Successfully registered!'
              : 'Registration submitted. Status: $status',
          title: 'Success',
        );
        // Set session and connect socket ONLY after successful registration
        await SessionController.to.setEvent(eventId, title: currentEvent?.title ?? '');
        await loadEvent(eventId);
        await Future.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          context.goNamed(AppRoutes.mainNavigationScreen);
        }
      }
    } catch (e) {
      final rawMsg = e.toString()
          .replaceAll('Exception: ', '')
          .replaceAll('Exception:', '')
          .trim();

      String userFriendlyMsg;
      if (rawMsg.toLowerCase().contains('price')) {
        userFriendlyMsg = 'This event has incomplete pricing setup. Please contact the organizer.';
      } else if (rawMsg.contains('Stripe') || rawMsg.toLowerCase().contains('payment')) {
        userFriendlyMsg = 'Payment integration is being configured. Please try again later.';
      } else if (rawMsg.toLowerCase().contains('organizer')) {
        userFriendlyMsg = 'Event organizer setup is incomplete. Please contact support.';
      } else {
        userFriendlyMsg = rawMsg;
      }

      errorMessage.value = userFriendlyMsg;
      ToastMessageHelper.showToastMessage(userFriendlyMsg, title: 'Error');
    } finally {
      isRegistering.value = false;
    }
  }

  Future<void> joinNow(BuildContext context) async {
    final currentEvent = event.value;
    final eventId = currentEvent?.id;
    if (eventId == null || eventId.isEmpty) return;

    try {
      isJoining.value = true;
      errorMessage.value = '';
      final joinData = await _repository.joinEvent(eventId);
      // Update role from event registration if available
      if (joinData != null) {
        final eventRole = (joinData['role'] ?? joinData['activeRole']) as String?;
        if (eventRole != null && eventRole.trim().isNotEmpty) {
          await RoleController.to.setRole(eventRole.trim());
        }
      }
      await SessionController.to.setEvent(eventId, title: currentEvent?.title ?? '');
      if (context.mounted) {
        context.goNamed(AppRoutes.mainNavigationScreen);
      }
    } catch (e) {
      errorMessage.value = e
          .toString()
          .replaceAll('Exception: ', '')
          .replaceAll('Exception:', '')
          .trim();
    } finally {
      isJoining.value = false;
    }
  }

  void toggleInvitationInput() {
    showInvitationInput.value = !showInvitationInput.value;
  }

  void joinWithInvitationCode() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
  }

  // True only for VERIFIED / REGISTERED — can join
  bool get isVerifiedOrRegistered {
    final status = registrationStatus.value.isNotEmpty
        ? registrationStatus.value
        : event.value?.registrationStatus ?? '';
    return status == 'VERIFIED' || status == 'REGISTERED';
  }

  // True only for PENDING — awaiting approval
  bool get isPendingRegistration {
    final status = registrationStatus.value.isNotEmpty
        ? registrationStatus.value
        : event.value?.registrationStatus ?? '';
    return status == 'PENDING';
  }

  bool get isAlreadyRegistered => isVerifiedOrRegistered || isPendingRegistration;

  String get registrationStatusLabel {
    final status = registrationStatus.value.isNotEmpty
        ? registrationStatus.value
        : event.value?.registrationStatus ?? '';
    switch (status) {
      case 'VERIFIED':
      case 'REGISTERED':
        return 'Registered';
      case 'PENDING':
        return 'Pending Approval';
      default:
        return '';
    }
  }
}