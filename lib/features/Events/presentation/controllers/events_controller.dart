import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/controllers/session_controller.dart';
import '../../../../../core/controllers/role_controller.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../../../../core/services/invitation_service.dart';
import '../../data/models/event_model.dart';
import '../../data/models/event_participation.dart';
import '../../data/models/invitation_model.dart';
import '../../data/models/invited_event_model.dart';
import '../../data/models/my_event_model.dart';
import '../../data/repositories/events_repository.dart';
import '../../domain/services/events_service.dart';

class EventsController extends GetxController {
  late final EventsRepository _repository;
  late final InvitationService _invitationService;

  final searchController = TextEditingController();

  // Tab configuration based on role
  // 0 = My Events, 1 = Explore Events, 2 = Invited Events, 3 = All Events
  final selectedTab = 0.obs;
  final RxList<String> tabLabels = <String>[].obs;

  // My Events tab
  // activeMyEvents  = registered events from /attendee/my-events
  // upcomingMyEvents = all upcoming events from /attendee/events (not registered)
  // myInvitations   = pending invitations from /invitation/my-invitations
  final activeMyEvents = <MyEventModel>[].obs;
  final upcomingMyEvents = <EventModel>[].obs;
  final myInvitations = <InvitationModel>[].obs;
  final isMyEventsLoading = false.obs;
  final myEventsError = ''.obs;

  // Explore Events tab
  final exploreEvents = <EventModel>[].obs;
  final isExploreLoading = false.obs;
  final exploreError = ''.obs;

  // Invited Events tab (for speakers, volunteers, reviewers, etc.)
  final invitedEvents = <EventModel>[].obs;
  final invitedEventModels = <InvitedEventModel>[].obs;
  final invitedCardLoadingId = ''.obs; // invitationId currently being actioned
  final isInvitedLoading = false.obs;
  final invitedError = ''.obs;

  // All Events tab (for exhibitors_sponsors_booth, sponsors, etc.)
  final allEvents = <EventModel>[].obs;
  final isAllEventsLoading = false.obs;
  final allEventsError = ''.obs;

  // Search
  final searchQuery = ''.obs;

  // Cache of my event IDs so we can exclude them from upcoming list
  final _myEventIds = <String>{};

  @override
  void onInit() {
    super.onInit();
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
    _configureTabsForRole();
    _loadDataForCurrentTab();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ── Role-based tab configuration ──────────────────────────────────────────

  void _configureTabsForRole() {
    final activeRole = RoleController.to.activeRole.value.toUpperCase();

    switch (activeRole) {
      case 'ATTENDEE':
      case 'SPEAKER':
        // My Events, Explore Events
        tabLabels.value = ['My Events', 'Explore Events'];
        break;

      case 'VOLUNTEER':
      case 'REVIEWER':
      case 'ABSTRACT_REVIEWER':
      case 'TRACK_CHAIR':
        // My Events, Invited Events
        tabLabels.value = ['My Events', 'Invited Events'];
        break;

      case 'EXHIBITOR':
      case 'BOOTH_STAFF':
      case 'STAFF':
      case 'SPONSOR':
        // My Events, All Events
        tabLabels.value = ['My Events', 'All Events'];
        break;

      case 'ORGANIZER':
        // Only My Events (events they created)
        tabLabels.value = ['My Events'];
        break;

      default:
        // Default: My Events, Explore Events
        tabLabels.value = ['My Events', 'Explore Events'];
        break;
    }
  }

  void _loadDataForCurrentTab() {
    final activeRole = RoleController.to.activeRole.value.toUpperCase();
    final tabIndex = selectedTab.value;

    // Load data based on role and tab
    if (tabIndex == 0) {
      // My Events tab - always load
      if (activeMyEvents.isEmpty && upcomingMyEvents.isEmpty) {
        loadMyEvents();
      }
    } else if (activeRole == 'ATTENDEE' || activeRole == 'SPEAKER') {
      // Explore Events tab
      if (exploreEvents.isEmpty) {
        loadExploreEvents();
      }
    } else if (activeRole == 'VOLUNTEER' ||
        activeRole == 'REVIEWER' ||
        activeRole == 'ABSTRACT_REVIEWER' ||
        activeRole == 'TRACK_CHAIR') {
      // Invited Events tab
      if (invitedEvents.isEmpty) {
        loadInvitedEvents();
      }
    } else if (activeRole == 'EXHIBITOR' ||
        activeRole == 'BOOTH_STAFF' ||
        activeRole == 'STAFF' ||
        activeRole == 'SPONSOR') {
      // All Events tab
      if (allEvents.isEmpty) {
        loadAllEvents();
      }
    }
  }

  // ── Tab switching ─────────────────────────────────────────────────────────

  void switchTab(int index) {
    selectedTab.value = index;
    _loadDataForCurrentTab();
  }

  // ── Load My Events tab data ───────────────────────────────────────────────
  // Active   = registered events (from /attendee/my-event)
  // Upcoming = all upcoming events NOT already registered (/attendee/events)

  Future<void> loadMyEvents() async {
    try {
      isMyEventsLoading.value = true;
      myEventsError.value = '';

      // Fetch registered events (/attendee/my-events) and invitations
      // (/invitation/my-invitations) in parallel.
      final results = await Future.wait([
        _repository.getMyEvents(),
        _invitationService.getMyInvitations(),
      ]);

      final myEvents = results[0] as List<MyEventModel>;
      final invitationsRaw = results[1] as List<Map<String, dynamic>>;

      // `my-events` never returns invitationId, so index the invitations by
      // event and merge them in — Accept / Reject need that id.
      final invitationsByEvent = <String, Map<String, dynamic>>{};
      for (final inv in invitationsRaw) {
        final rawEvent = inv['eventId'];
        final evId = rawEvent is Map
            ? (rawEvent['_id'] as String? ?? '')
            : (rawEvent as String? ?? '');
        if (evId.isEmpty) continue;
        // Keep the first non-rejected invitation per event.
        final status = (inv['status'] as String? ?? '').toUpperCase();
        if (status == InvitationStatus.rejected) continue;
        invitationsByEvent.putIfAbsent(evId, () => inv);
      }

      activeMyEvents.value = myEvents.map((m) {
        final inv = invitationsByEvent[m.event.id];
        if (inv == null) return m;
        return m.copyWith(
          invitationId: inv['_id'] as String? ?? '',
          invitationStatus: (inv['status'] as String? ?? '').toUpperCase(),
          invitationRole: m.invitationRole.isNotEmpty
              ? m.invitationRole
              : (inv['role'] as String? ?? '').toUpperCase(),
        );
      }).toList();

      // Cache event IDs already present in My Events
      _myEventIds
        ..clear()
        ..addAll(myEvents.map((m) => m.event.id));

      // Standalone invitation cards: only for events my-events did not return.
      myInvitations.value = invitationsRaw
          .map((e) => InvitationModel.fromJson(e))
          .where((inv) =>
              inv.isPending &&
              inv.eventId.isNotEmpty &&
              !_myEventIds.contains(inv.eventId))
          .toList();

      // Clear upcoming events (not shown in My Events tab anymore)
      upcomingMyEvents.clear();
    } catch (e) {
      myEventsError.value = _cleanError(e.toString());
    } finally {
      isMyEventsLoading.value = false;
    }
  }

  // ── Load Explore Events ───────────────────────────────────────────────────

  Future<void> loadExploreEvents() async {
    try {
      isExploreLoading.value = true;
      exploreError.value = '';

      // Explore should only offer events the user hasn't already joined or
      // been invited to — make sure that set is populated before filtering,
      // otherwise an already-registered event can show up here and its
      // details screen (which reads the real per-user status from the
      // backend) offers "Join Now" instead of "Register", looking like the
      // user can enter an event they never registered for.
      if (_myEventIds.isEmpty && activeMyEvents.isEmpty) {
        await loadMyEvents();
      }

      final excludedIds = <String>{
        ..._myEventIds,
        ...myInvitations.map((inv) => inv.eventId),
      };

      final events = await _repository.getExploreEvents();
      exploreEvents.value =
          events.where((e) => !excludedIds.contains(e.id)).toList();
    } catch (e) {
      exploreError.value = _cleanError(e.toString());
    } finally {
      isExploreLoading.value = false;
    }
  }

  // ── Load Invited Events ───────────────────────────────────────────────────

  Future<void> loadInvitedEvents() async {
    try {
      isInvitedLoading.value = true;
      invitedError.value = '';

      // Fetch all invitations — response has shape:
      // { "_id": "invId", "eventId": { "_id": "evId", ... },
      //   "role": "SPONSOR", "status": "PENDING" | "ACCEPTED" | ... }
      final invitations = await _invitationService.getMyInvitations('');

      // Build InvitedEventModel list by fetching event details per invitation
      invitedEventModels.value =
          await _repository.getInvitedEvents(invitations);

      // Keep legacy invitedEvents in sync for any existing consumers
      invitedEvents.value =
          invitedEventModels.map((m) => EventModel(
            id: m.id,
            title: m.title,
            location: m.location,
            startDate: m.startDate,
            endDate: m.endDate,
            bannerImageUrl: m.bannerImageUrl,
          )).toList();
    } catch (e) {
      invitedError.value = _cleanError(e.toString());
    } finally {
      isInvitedLoading.value = false;
    }
  }

  // ── Load All Events ───────────────────────────────────────────────────────

  Future<void> loadAllEvents() async {
    try {
      isAllEventsLoading.value = true;
      allEventsError.value = '';
      // Use the same endpoint as explore events
      allEvents.value = await _repository.getExploreEvents();
    } catch (e) {
      allEventsError.value = _cleanError(e.toString());
    } finally {
      isAllEventsLoading.value = false;
    }
  }

  // ── Search ────────────────────────────────────────────────────────────────

  void onSearchChanged(String value) {
    searchQuery.value = value.toLowerCase();
  }

  List<MyEventModel> get filteredActiveEvents {
    if (searchQuery.isEmpty) return activeMyEvents;
    return activeMyEvents
        .where(
          (m) =>
              m.event.title.toLowerCase().contains(searchQuery.value) ||
              m.event.location.toLowerCase().contains(searchQuery.value),
        )
        .toList();
  }

  List<InvitationModel> get filteredMyInvitations {
    if (searchQuery.isEmpty) return myInvitations;
    return myInvitations.where((inv) {
      final e = inv.event;
      if (e == null) return false;
      return e.title.toLowerCase().contains(searchQuery.value) ||
          e.location.toLowerCase().contains(searchQuery.value);
    }).toList();
  }

  List<EventModel> get filteredUpcomingEvents {
    if (searchQuery.isEmpty) return upcomingMyEvents;
    return upcomingMyEvents
        .where(
          (e) =>
              e.title.toLowerCase().contains(searchQuery.value) ||
              e.location.toLowerCase().contains(searchQuery.value),
        )
        .toList();
  }

  List<EventModel> get filteredExploreEvents {
    if (searchQuery.isEmpty) return exploreEvents;
    return exploreEvents
        .where(
          (e) =>
              e.title.toLowerCase().contains(searchQuery.value) ||
              e.location.toLowerCase().contains(searchQuery.value),
        )
        .toList();
  }

  List<EventModel> get filteredInvitedEvents {
    if (searchQuery.isEmpty) return invitedEvents;
    return invitedEvents
        .where(
          (e) =>
              e.title.toLowerCase().contains(searchQuery.value) ||
              e.location.toLowerCase().contains(searchQuery.value),
        )
        .toList();
  }

  List<InvitedEventModel> get filteredInvitedEventModels {
    if (searchQuery.isEmpty) return invitedEventModels;
    return invitedEventModels
        .where(
          (m) =>
              m.title.toLowerCase().contains(searchQuery.value) ||
              m.location.toLowerCase().contains(searchQuery.value),
        )
        .toList();
  }

  List<EventModel> get filteredAllEvents {
    if (searchQuery.isEmpty) return allEvents;
    return allEvents
        .where(
          (e) =>
              e.title.toLowerCase().contains(searchQuery.value) ||
              e.location.toLowerCase().contains(searchQuery.value),
        )
        .toList();
  }

  // ── Navigation ────────────────────────────────────────────────────────────
  Future<void> openEventDetails(BuildContext context, String eventId, {String title = '', String registrationStatus = '', String role = ''}) {
    return context.pushNamed(AppRoutes.eventsDetailsScreen, extra: {
      'eventId': eventId,
      'registrationStatus': registrationStatus,
      'role': role,
    });
  }

  void registerEvent(BuildContext context, String eventId, {String title = ''}) {
    // Self-registration is the ATTENDEE path only — invite-only roles must
    // reach an event by accepting an invitation.
    if (!AppRole.canSelfRegister(RoleController.to.activeRole.value)) {
      ToastMessageHelper.showToastMessage(
        'Events are joined by invitation for your role. Ask the organizer to '
        'invite you, then accept it from My Events.',
        title: 'Info',
      );
      return;
    }
    // Do NOT call setEvent here — session is set only after successful registration
    // inside EventDetailsController.registerNow.
    context.pushNamed(AppRoutes.eventsDetailsScreen, extra: {
      'eventId': eventId,
      'registrationStatus': '', // Not registered yet
    });
  }

  void selectEventAndNavigate(BuildContext context, String eventId, {String title = '', String role = ''}) {
    if (role.trim().isNotEmpty) {
      RoleController.to.setRole(role.trim());
    }
    SessionController.to.setEvent(eventId, title: title);
    context.goNamed(AppRoutes.mainNavigationScreen);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _cleanError(String raw) =>
      raw.replaceAll('Exception: ', '').replaceAll('Exception:', '');
}
