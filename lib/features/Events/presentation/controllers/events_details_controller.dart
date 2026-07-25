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
import '../../../../../core/services/invitation_service.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/events_repository.dart';
import '../../domain/services/events_service.dart';

class EventDetailsController extends GetxController {
  late final EventsRepository _repository;
  late final InvitationService _invitationService;

  final invitationCodeController = TextEditingController();

  final isLoading = false.obs;
  final isRegistering = false.obs;
  final isJoining = false.obs;
  final showInvitationInput = false.obs;

  // Pending invitation (for registrationStatus == PENDING) accept/reject
  final RxString invitationId = ''.obs;
  final isResolvingInvite = false.obs;
  final isAcceptingInvite = false.obs;
  final isRejectingInvite = false.obs;

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
    _invitationService = InvitationService(
      apiService: Get.find<ApiService>(),
      connectivityService: Get.find<ConnectivityService>(),
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

      debugPrint('[EVENT_DETAILS] eventId=$eventId '
          'passedStatus="$status" '
          'detailsRegStatus="${event.value?.registrationStatus}"');

      // The /attendee/events/{id} response does not always include the current
      // user's registrationStatus (e.g. when opened from Explore / New Events).
      // If we still don't know it, look it up from the user's registered events
      // and invitations so a registered user correctly sees "Join Now".
      final known = registrationStatus.value.isNotEmpty
          ? registrationStatus.value
          : event.value?.registrationStatus ?? '';
      if (known.isEmpty) {
        await _resolveRegistrationStatus(eventId);
      }

      debugPrint('[EVENT_DETAILS] resolved registrationStatus.value='
          '"${registrationStatus.value}" '
          'isVerifiedOrRegistered=$isVerifiedOrRegistered '
          'isPending=$isPendingRegistration');

      // If the registration is PENDING, it's an unanswered invitation —
      // resolve its id so we can offer Accept / Reject.
      if (isPendingRegistration) {
        await _resolvePendingInvitation(eventId);
      } else {
        invitationId.value = '';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  /// Resolves the current user's registration status for [eventId] by checking
  /// their registered events (`/attendee/my-events`) and, failing that, their
  /// invitations (`/invitation/my-invitations`). Sets [registrationStatus] so
  /// the UI shows Join Now (registered) or Accept/Reject (pending invitation).
  Future<void> _resolveRegistrationStatus(String eventId) async {
    try {
      // 1) Registered events — status is VERIFIED / PENDING.
      final myEvents = await _repository.getMyEvents();
      debugPrint('[EVENT_DETAILS] myEvents=${myEvents.map((m) => '${m.event.id}:${m.status}').toList()}');
      for (final m in myEvents) {
        if (m.event.id == eventId && m.status.isNotEmpty) {
          registrationStatus.value = m.status;
          if (m.role.trim().isNotEmpty) {
            await RoleController.to.setRole(m.role.trim());
          }
          return;
        }
      }

      // 2) Invitations — an unanswered one means PENDING (accept/reject).
      final invitations = await _invitationService.getMyInvitations();
      debugPrint('[EVENT_DETAILS] invitations=${invitations.map((i) {
        final ev = i['eventId'];
        final id = ev is Map ? ev['_id'] : ev;
        return '$id:${i['status']}';
      }).toList()}');
      for (final inv in invitations) {
        final ev = inv['eventId'];
        final evId = ev is Map ? ev['_id'] as String? : ev as String?;
        if (evId != eventId) continue;

        final s = (inv['status'] as String? ?? '').toUpperCase();
        if (s == 'PENDING' || s == 'INVITED' || s.isEmpty) {
          registrationStatus.value = 'PENDING';
          invitationId.value = inv['_id'] as String? ?? '';
        } else if (s == 'ACCEPTED') {
          registrationStatus.value = 'VERIFIED';
        }
        break;
      }
    } catch (_) {
      // Non-fatal — falls back to the "Not Registered" state.
    }
  }

  /// Looks up the current user's pending invitation for [eventId] so the
  /// Accept / Reject buttons have an invitation id to act on.
  Future<void> _resolvePendingInvitation(String eventId) async {
    try {
      isResolvingInvite.value = true;
      invitationId.value = '';

      final invitations = await _invitationService.getMyInvitations();
      for (final inv in invitations) {
        final ev = inv['eventId'];
        final evId = ev is Map ? ev['_id'] as String? : ev as String?;
        if (evId == eventId) {
          final status = (inv['status'] as String? ?? '').toUpperCase();
          // Only unanswered invitations are actionable.
          if (status == 'PENDING' || status == 'INVITED' || status.isEmpty) {
            invitationId.value = inv['_id'] as String? ?? '';
            break;
          }
        }
      }
    } catch (e) {
      // Non-fatal — buttons will simply be disabled if we can't resolve it.
      invitationId.value = '';
    } finally {
      isResolvingInvite.value = false;
    }
  }

  Future<void> acceptInvitation(BuildContext context) async {
    final eventId = event.value?.id ?? '';
    final invId = invitationId.value;
    if (eventId.isEmpty || invId.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'Could not find your invitation for this event.',
        title: 'Error',
      );
      return;
    }

    try {
      isAcceptingInvite.value = true;
      final result =
          await _invitationService.acceptInvitation(invId, eventId);
      final success = result['success'] as bool? ?? true;
      if (success) {
        ToastMessageHelper.showToastMessage('Invitation accepted');
        // Reflect the new status immediately, then refresh from server.
        registrationStatus.value = 'VERIFIED';
        await loadEvent(eventId);
      } else {
        ToastMessageHelper.showToastMessage(
          result['message'] as String? ?? 'Failed to accept invitation',
          title: 'Error',
        );
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage(
        e.toString().replaceAll('Exception: ', '').trim(),
        title: 'Error',
      );
    } finally {
      isAcceptingInvite.value = false;
    }
  }

  Future<void> rejectInvitation(BuildContext context) async {
    final eventId = event.value?.id ?? '';
    final invId = invitationId.value;
    if (eventId.isEmpty || invId.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'Could not find your invitation for this event.',
        title: 'Error',
      );
      return;
    }

    try {
      isRejectingInvite.value = true;
      final result =
          await _invitationService.rejectInvitation(invId, eventId);
      final success = result['success'] as bool? ?? true;
      if (success) {
        ToastMessageHelper.showToastMessage('Invitation rejected');
        registrationStatus.value = 'REJECTED';
        invitationId.value = '';
        if (context.mounted) Navigator.of(context).pop();
      } else {
        ToastMessageHelper.showToastMessage(
          result['message'] as String? ?? 'Failed to reject invitation',
          title: 'Error',
        );
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage(
        e.toString().replaceAll('Exception: ', '').trim(),
        title: 'Error',
      );
    } finally {
      isRejectingInvite.value = false;
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
      return;
    }

    if (isPaidEvent && price > 0) {
      const msg = 'This event requires payment. Online payment integration is coming soon. Please contact the organizer to register.';
      errorMessage.value = msg;
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

      // "Already registered" means they're in the event — treat as success
      if (rawMsg.toLowerCase().contains('already registered') ||
          rawMsg.toLowerCase().contains('already register')) {
        registrationStatus.value = 'VERIFIED';
        await SessionController.to.setEvent(eventId, title: currentEvent?.title ?? '');
        await loadEvent(eventId);
        // Don't auto-navigate — let the user click "Join Now"
        return;
      }

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

      // Ensure session is set before navigating
      await SessionController.to.setEvent(
        eventId,
        title: currentEvent?.title ?? '',
      );

      try {
        final joinData = await _repository.joinEvent(eventId);
        if (joinData != null) {
          final eventRole =
              (joinData['role'] ?? joinData['activeRole']) as String?;
          if (eventRole != null && eventRole.trim().isNotEmpty) {
            await RoleController.to.setRole(eventRole.trim());
          }
        }
      } catch (_) {
        // joinEvent API may fail if already joined — session is already set,
        // so we can safely navigate regardless
      }

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

  // True for VERIFIED / REGISTERED / ACCEPTED — can join
  bool get isVerifiedOrRegistered {
    final status = registrationStatus.value.isNotEmpty
        ? registrationStatus.value
        : event.value?.registrationStatus ?? '';
    return status == 'VERIFIED' ||
        status == 'REGISTERED' ||
        status == 'ACCEPTED';
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