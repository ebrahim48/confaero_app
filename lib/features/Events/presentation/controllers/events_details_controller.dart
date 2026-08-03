import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/controllers/role_controller.dart';
import '../../../../../core/controllers/session_controller.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../../../../core/services/invitation_service.dart';
import '../../data/models/event_model.dart';
import '../../data/models/event_participation.dart';
import '../../data/repositories/events_repository.dart';
import '../../domain/services/events_service.dart';

class EventDetailsController extends GetxController {
  late final EventsRepository _repository;
  late final InvitationService _invitationService;

  final isLoading = false.obs;
  final isRegistering = false.obs;
  final isJoining = false.obs;

  // Pending invitation (for registrationStatus == PENDING) accept/reject
  final RxString invitationId = ''.obs;
  final isResolvingInvite = false.obs;
  final isAcceptingInvite = false.obs;
  final isRejectingInvite = false.obs;

  final event = Rxn<EventModel>();
  final errorMessage = ''.obs;

  // Registration status passed from EventsScreen (for "My Events" tab)
  final RxString registrationStatus = ''.obs;

  /// The role the user holds *for this event* — ATTENDEE for a self
  /// registration, or the accepted `invitationRole` for every other role.
  /// This is what `PATCH …/join?role=` must be given.
  final RxString eventRole = ''.obs;

  String get joinRole =>
      eventRole.value.isNotEmpty ? eventRole.value : AppRole.attendee;

  // "See More" / "See Less" state for the event description
  final isDescriptionExpanded = false.obs;

  void toggleDescriptionExpanded() =>
      isDescriptionExpanded.value = !isDescriptionExpanded.value;

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


  Future<void> loadEvent(String eventId, {String status = '', String role = ''}) async {
    if (eventId.isEmpty) return;
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // This controller is a GetX singleton reused across every event this
      // screen is opened for (Get.put() returns the existing instance rather
      // than a fresh one). Reset all per-event state unconditionally so a
      // previous event's registrationStatus/eventRole/invitation never leaks
      // into this one (e.g. showing "Registered" for an event never joined,
      // or sending the wrong role to the join API).
      registrationStatus.value = status;
      eventRole.value = '';
      invitationId.value = '';

      // Pre-set role from event registration (e.g., EXHIBITOR)
      if (role.trim().isNotEmpty) {
        eventRole.value = role.trim().toUpperCase();
        await RoleController.to.setRole(role.trim());
      }

      event.value = await _repository.getEventDetails(eventId);

      debugPrint('[EVENT_DETAILS] eventId=$eventId '
          'passedStatus="$status" '
          'detailsRegStatus="${event.value?.registrationStatus}"');

      // The /attendee/events/{id} response's registrationStatus field is not
      // reliably the *current user's* registration state — it has been
      // observed as VERIFIED for events the user never registered for (e.g.
      // when opened from Explore). Never trust it. If the caller didn't pass
      // a known status (from My Events / Invited Events, which are already
      // scoped to the user), always resolve the real status from
      // /attendee/my-events + /invitation/my-invitations.
      if (registrationStatus.value.isEmpty) {
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
      // 1) My Events — REGISTERED (attendee) or INVITED (every other role).
      final myEvents = await _repository.getMyEvents();
      debugPrint('[EVENT_DETAILS] myEvents=${myEvents.map((m) => '${m.event.id}:${m.status}:${m.invitationRole}').toList()}');
      for (final m in myEvents) {
        if (m.event.id != eventId || m.status.isEmpty) continue;

        if (m.invitationRole.isNotEmpty) {
          eventRole.value = m.invitationRole;
          await RoleController.to.setRole(m.invitationRole);
        }

        if (m.isRegistered) {
          registrationStatus.value = RegistrationStatus.verified;
          eventRole.value =
              eventRole.value.isEmpty ? AppRole.attendee : eventRole.value;
          return;
        }
        // INVITED — whether it is actionable depends on the invitation's own
        // status, resolved from /invitation/my-invitations below.
        break;
      }

      // 2) Invitations — an unanswered one means the user must accept/reject.
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

        final invRole = (inv['role'] as String? ?? '').toUpperCase();
        if (invRole.isNotEmpty) eventRole.value = invRole;

        final s = (inv['status'] as String? ?? '').toUpperCase();
        if (s == InvitationStatus.pending || s == 'INVITED' || s.isEmpty) {
          registrationStatus.value = RegistrationStatus.pending;
          invitationId.value = inv['_id'] as String? ?? '';
        } else if (s == InvitationStatus.accepted) {
          // Accepted invitation — the user may enter with the invited role.
          registrationStatus.value = RegistrationStatus.verified;
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

        // The server added the invited role to the account and made it active.
        final acceptedRole =
            ((result['data'] as Map<String, dynamic>?)?['role'] as String? ?? '')
                .toUpperCase();
        if (acceptedRole.isNotEmpty) eventRole.value = acceptedRole;

        // Reflect the new status immediately, then refresh from server.
        registrationStatus.value = RegistrationStatus.verified;
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

    // Self-registration is the ATTENDEE path only. Invite-only roles reach an
    // event by accepting an invitation, never through initiate-registration.
    if (!AppRole.canSelfRegister(RoleController.to.activeRole.value)) {
      const msg = 'Events are joined by invitation for your role. Ask the '
          'organizer to invite you, then accept it from My Events.';
      errorMessage.value = msg;
      ToastMessageHelper.showToastMessage(msg, title: 'Info');
      return;
    }

    // Pre-validate paid events before hitting the API
    final paymentType = currentEvent?.paymentType?.toUpperCase() ?? '';
    final price = currentEvent?.price ?? 0.0;
    final isPaidEvent = paymentType == 'STRIPE' || paymentType == 'PAID';

    if (isPaidEvent && price <= 0) {
      const msg = 'This event has incomplete pricing setup. Please contact the organizer.';
      errorMessage.value = msg;
      ToastMessageHelper.showToastMessage(msg, title: 'Error');
      return;
    }

    try {
      isRegistering.value = true;
      errorMessage.value = '';

      final result = await _repository.initiateRegistration(eventId);

      if (result == null) {
        // The API accepted the call but returned nothing actionable — tell the
        // user instead of leaving the button looking dead.
        const msg = 'Registration could not be completed. Please try again.';
        errorMessage.value = msg;
        ToastMessageHelper.showToastMessage(msg, title: 'Error');
        return;
      }

      // The response is one of three shapes — branch on which key is present.
      final redirectUrl = (result['redirectUrl'] as String? ?? '').trim();
      final clientSecret = (result['clientSecret'] as String? ?? '').trim();
      final status = (result['status'] as String? ?? '').toUpperCase();

      if (redirectUrl.isNotEmpty) {
        await _openExternalCheckout(redirectUrl, eventId);
        return;
      }

      if (clientSecret.isNotEmpty) {
        // STRIPE: completing this needs the Stripe Payment Sheet, which is not
        // bundled in this app yet. Say so rather than silently doing nothing.
        const msg = 'This event is paid via card. Card payment is not available '
            'in the app yet — please contact the organizer to complete your '
            'registration.';
        errorMessage.value = msg;
        ToastMessageHelper.showToastMessage(msg, title: 'Info');
        registrationStatus.value = RegistrationStatus.pending;
        return;
      }

      if (status == RegistrationStatus.pending) {
        registrationStatus.value = RegistrationStatus.pending;
        ToastMessageHelper.showToastMessage(
          'Your registration is pending verification.',
          title: 'Info',
        );
        await loadEvent(eventId);
        return;
      }

      // VERIFIED (organizer pre-verified the email) — enter the event.
      registrationStatus.value = RegistrationStatus.verified;
      ToastMessageHelper.showToastMessage('You are registered for this event');
      await _enterEvent(context, eventId, currentEvent?.title ?? '',
          role: AppRole.attendee);
    } catch (e) {
      final rawMsg = _rawErrorMessage(e);

      // "Already registered" means a record exists — but not necessarily a
      // VERIFIED one (it could be a PENDING registration from an abandoned
      // Stripe/external checkout). Re-resolve the real status from
      // /attendee/my-events + /invitation/my-invitations instead of assuming
      // VERIFIED, otherwise this screen shows "Registered" forever while the
      // My Events list — which always reflects the true backend record —
      // correctly shows nothing.
      if (rawMsg.toLowerCase().contains('already registered') ||
          rawMsg.toLowerCase().contains('already register')) {
        registrationStatus.value = ''; // force loadEvent to re-resolve
        await loadEvent(eventId);

        if (isVerifiedOrRegistered) {
          await SessionController.to.setEvent(eventId, title: currentEvent?.title ?? '');
          ToastMessageHelper.showToastMessage(
            "You're already registered for this event. Tap Join Now to enter.",
            title: 'Info',
          );
        } else if (isPendingRegistration) {
          ToastMessageHelper.showToastMessage(
            'Your registration for this event is still pending '
            '(e.g. payment not completed). Please contact the organizer if '
            "this doesn't resolve.",
            title: 'Info',
          );
        } else {
          // Backend says a record exists but my-events doesn't surface it —
          // don't claim success we can't verify.
          ToastMessageHelper.showToastMessage(
            'A registration attempt already exists for this event, but it '
            "could not be confirmed. Please contact the organizer if you're "
            'not able to enter.',
            title: 'Info',
          );
        }
        return;
      }

      String userFriendlyMsg;
      if (rawMsg.toLowerCase().contains('price')) {
        userFriendlyMsg = 'This event has incomplete pricing setup. Please contact the organizer.';
      } else if (rawMsg.contains('Stripe') || rawMsg.toLowerCase().contains('payment')) {
        userFriendlyMsg = 'Payment integration is not complete from admin. Please wait and contact admin for registration.';
      } else if (rawMsg.toLowerCase().contains('organizer')) {
        userFriendlyMsg = 'Event organizer setup is incomplete. Please contact support.';
      } else {
        userFriendlyMsg = rawMsg.isEmpty
            ? 'Registration failed. Please try again.'
            : rawMsg;
      }

      errorMessage.value = userFriendlyMsg;
      // The details screen only renders errorMessage when no event is loaded,
      // so surface it as a toast too — otherwise the tap looks like a no-op.
      ToastMessageHelper.showToastMessage(userFriendlyMsg, title: 'Error');
    } finally {
      isRegistering.value = false;
    }
  }

  /// Opens the organizer's external checkout page. The registration stays
  /// PENDING until the payment provider confirms it server-side.
  Future<void> _openExternalCheckout(String url, String eventId) async {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      const msg = 'Could not open the payment page. Please try again.';
      errorMessage.value = msg;
      ToastMessageHelper.showToastMessage(msg, title: 'Error');
      return;
    }
    registrationStatus.value = RegistrationStatus.pending;
    ToastMessageHelper.showToastMessage(
      'Complete the payment in your browser, then return here.',
      title: 'Info',
    );
    await loadEvent(eventId);
  }

  /// `PATCH /attendee/event/:id/join?role=` then navigate into the event.
  /// This is the only supported way to open event-scoped screens.
  Future<void> _enterEvent(
    BuildContext context,
    String eventId,
    String title, {
    required String role,
  }) async {
    // Set the local session first so event-scoped controllers have an eventId
    // even if the join call is a no-op (e.g. already joined).
    await SessionController.to.setEvent(eventId, title: title);

    try {
      final joinData = await _repository.joinEvent(eventId, role: role);
      // Trust the server's activeRole over our local guess.
      final serverRole =
          (joinData?['activeRole'] ?? joinData?['role']) as String?;
      await RoleController.to
          .setRole((serverRole?.trim().isNotEmpty ?? false) ? serverRole!.trim() : role);

      final roles = joinData?['role'];
      if (roles is List) {
        RoleController.to.setUserRoles(roles.map((r) => r.toString()).toList());
      }
    } on ServerException catch (e) {
      if (e.statusCode == 403) {
        // Genuine "no access" — don't let the user into an event they were
        // just refused. Undo the optimistic session set above and surface it.
        await SessionController.to.clearEvent();
        rethrow;
      }
      // Non-403 server error (e.g. "already joined") — the session is set,
      // so still let the user in with the role we know about.
      await RoleController.to.setRole(role);
    } catch (_) {
      // Transient/non-server failure — the session is set, so still let the
      // user in with the role we know about.
      await RoleController.to.setRole(role);
    }

    if (context.mounted) {
      context.goNamed(AppRoutes.mainNavigationScreen);
    }
  }

  Future<void> joinNow(BuildContext context) async {
    final currentEvent = event.value;
    final eventId = currentEvent?.id;
    if (eventId == null || eventId.isEmpty) return;

    try {
      isJoining.value = true;
      errorMessage.value = '';

      await _enterEvent(
        context,
        eventId,
        currentEvent?.title ?? '',
        role: joinRole,
      );
    } catch (e) {
      final msg = _rawErrorMessage(e);
      errorMessage.value = msg;
      ToastMessageHelper.showToastMessage(
        msg.isEmpty ? 'Could not join this event. Please try again.' : msg,
        title: 'Error',
      );
    } finally {
      isJoining.value = false;
    }
  }

  /// Strips the technical `ServerException (403): ... - This exception was
  /// thrown because ...` noise down to the actual server/user-facing message.
  String _rawErrorMessage(Object e) {
    if (e is AppException) return e.message;
    return e.toString().replaceAll('Exception: ', '').replaceAll('Exception:', '').trim();
  }

  /// The effective status for this event: whatever was passed in by the
  /// caller (My Events / Invited Events) or resolved from my-events /
  /// my-invitations in [loadEvent]. Deliberately does NOT fall back to
  /// `event.value?.registrationStatus` — that field from
  /// `/attendee/events/:id` is not a reliable per-user signal (observed
  /// VERIFIED for events the current user never registered for), and
  /// trusting it let unregistered users hit "Join Now" instead of
  /// "Register" — including skipping payment validation entirely.
  String get _effectiveStatus => registrationStatus.value;

  /// True when the user may enter the event — a VERIFIED registration or an
  /// ACCEPTED invitation. (`REGISTERED` / `ACCEPTED` are tolerated because
  /// different endpoints spell the same state differently.)
  bool get isVerifiedOrRegistered {
    final status = _effectiveStatus;
    return status == RegistrationStatus.verified ||
        status == MyEventStatus.registered ||
        status == InvitationStatus.accepted;
  }

  /// True while awaiting payment/verification, or an unanswered invitation.
  bool get isPendingRegistration =>
      _effectiveStatus == RegistrationStatus.pending;

  /// True when this event is an unanswered invitation — the CTA is
  /// Accept / Reject, never Register.
  bool get isInvitationPending =>
      isPendingRegistration && invitationId.value.isNotEmpty;

  /// Self-registration is only offered to attendees on an event they have not
  /// joined yet. Invite-only roles never see a Register CTA.
  bool get canSelfRegister =>
      !isAlreadyRegistered &&
      invitationId.value.isEmpty &&
      AppRole.canSelfRegister(RoleController.to.activeRole.value);

  bool get isAlreadyRegistered => isVerifiedOrRegistered || isPendingRegistration;

  String get registrationStatusLabel {
    switch (_effectiveStatus) {
      case RegistrationStatus.verified:
      case MyEventStatus.registered:
      case InvitationStatus.accepted:
        // An accepted invitation reads better as the role than as "Registered".
        return eventRole.value.isNotEmpty &&
                eventRole.value != AppRole.attendee
            ? 'Joining as ${RoleController.formatRoleName(eventRole.value)}'
            : 'Registered';
      case RegistrationStatus.pending:
        return isInvitationPending ? 'Invitation Pending' : 'Pending Approval';
      default:
        return '';
    }
  }
}