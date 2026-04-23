import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/controllers/session_controller.dart';
import '../../../../../core/controllers/role_controller.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../../../../core/services/invitation_service.dart';
import '../../data/models/event_model.dart';
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
  // activeMyEvents  = registered events from /attendee/my-event
  // upcomingMyEvents = all upcoming events from /attendee/events (not registered)
  final activeMyEvents = <MyEventModel>[].obs;
  final upcomingMyEvents = <EventModel>[].obs;
  final isMyEventsLoading = false.obs;
  final myEventsError = ''.obs;

  // Explore Events tab
  final exploreEvents = <EventModel>[].obs;
  final isExploreLoading = false.obs;
  final exploreError = ''.obs;

  // Invited Events tab (for speakers, volunteers, reviewers, etc.)
  final invitedEvents = <EventModel>[].obs;
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

      // Only fetch registered events from /attendee/my-event
      final myEvents = await _repository.getMyEvents();

      // Active = all my registered events
      activeMyEvents.value = myEvents;

      // Cache registered event IDs
      _myEventIds
        ..clear()
        ..addAll(myEvents.map((m) => m.event.id));

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
      exploreEvents.value = await _repository.getExploreEvents();
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

      // Get all invitations across all events
      final invitations = await _invitationService.getMyInvitations('');

      // Extract unique event IDs from invitations
      final eventIds = <String>{};
      for (final invitation in invitations) {
        final eventId = invitation['event']?['id'] as String?;
        if (eventId != null && eventId.isNotEmpty) {
          eventIds.add(eventId);
        }
      }

      // Fetch event details for each invited event
      final events = <EventModel>[];
      for (final eventId in eventIds) {
        try {
          final event = await _repository.getEventDetails(eventId);
          if (event != null) {
            events.add(event);
          }
        } catch (e) {
          // Skip events that fail to load
        }
      }

      invitedEvents.value = events;
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

  void openEventDetails(BuildContext context, String eventId, {String title = '', String registrationStatus = ''}) {
    // Do NOT set the session here — session is set only after the user
    // clicks "Join Now" (calls PATCH /attendee/event/{id}/join).
    context.pushNamed(AppRoutes.eventsDetailsScreen, extra: {
      'eventId': eventId,
      'registrationStatus': registrationStatus,
    });
  }

  void registerEvent(BuildContext context, String eventId, {String title = ''}) {
    // Do NOT call setEvent here — session is set only after successful registration
    // inside EventDetailsController.registerNow.
    context.pushNamed(AppRoutes.eventsDetailsScreen, extra: {
      'eventId': eventId,
      'registrationStatus': '', // Not registered yet
    });
  }

  void selectEventAndNavigate(BuildContext context, String eventId, {String title = ''}) {
    // Set the event and navigate directly to main navigation
    SessionController.to.setEvent(eventId, title: title);
    context.goNamed(AppRoutes.mainNavigationScreen);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _cleanError(String raw) =>
      raw.replaceAll('Exception: ', '').replaceAll('Exception:', '');
}
