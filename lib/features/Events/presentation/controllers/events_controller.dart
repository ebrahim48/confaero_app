import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../data/models/event_model.dart';
import '../../data/models/my_event_model.dart';
import '../../data/repositories/events_repository.dart';
import '../../domain/services/events_service.dart';

class EventsController extends GetxController {
  late final EventsRepository _repository;

  final searchController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // 0 = My Events, 1 = Explore Events
  final selectedTab = 0.obs;

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
    loadMyEvents();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ── Tab switching ─────────────────────────────────────────────────────────

  void switchTab(int index) {
    selectedTab.value = index;
    if (index == 0) {
      if (activeMyEvents.isEmpty && upcomingMyEvents.isEmpty) loadMyEvents();
    } else {
      if (exploreEvents.isEmpty) loadExploreEvents();
    }
  }

  // ── Load My Events tab data ───────────────────────────────────────────────
  // Active   = registered events (from /attendee/my-event)
  // Upcoming = all upcoming events NOT already registered (/attendee/events)

  Future<void> loadMyEvents() async {
    try {
      isMyEventsLoading.value = true;
      myEventsError.value = '';

      // Fetch both APIs in parallel
      final results = await Future.wait([
        _repository.getMyEvents(),         // registered
        _repository.getAllUpcomingEvents(), // all upcoming
      ]);

      final myEvents = results[0] as List<MyEventModel>;
      final allUpcoming = results[1] as List<EventModel>;

      // Active = all my registered events
      activeMyEvents.value = myEvents;

      // Cache registered event IDs
      _myEventIds
        ..clear()
        ..addAll(myEvents.map((m) => m.event.id));

      // Upcoming = upcoming events that are NOT already registered
      upcomingMyEvents.value = allUpcoming
          .where((e) => !_myEventIds.contains(e.id))
          .toList();
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

  // ── Search ────────────────────────────────────────────────────────────────

  void onSearchChanged(String value) {
    searchQuery.value = value.toLowerCase();
  }

  List<MyEventModel> get filteredActiveEvents {
    if (searchQuery.isEmpty) return activeMyEvents;
    return activeMyEvents
        .where((m) =>
    m.event.title.toLowerCase().contains(searchQuery.value) ||
        m.event.location.toLowerCase().contains(searchQuery.value))
        .toList();
  }

  List<EventModel> get filteredUpcomingEvents {
    if (searchQuery.isEmpty) return upcomingMyEvents;
    return upcomingMyEvents
        .where((e) =>
    e.title.toLowerCase().contains(searchQuery.value) ||
        e.location.toLowerCase().contains(searchQuery.value))
        .toList();
  }

  List<EventModel> get filteredExploreEvents {
    if (searchQuery.isEmpty) return exploreEvents;
    return exploreEvents
        .where((e) =>
    e.title.toLowerCase().contains(searchQuery.value) ||
        e.location.toLowerCase().contains(searchQuery.value))
        .toList();
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEventDetails(BuildContext context, String eventId) {
    context.pushNamed(AppRoutes.eventsDetailsScreen, extra: eventId);
  }

  void registerEvent(BuildContext context, String eventId) {
    context.pushNamed(AppRoutes.eventsDetailsScreen, extra: eventId);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _cleanError(String raw) =>
      raw.replaceAll('Exception: ', '').replaceAll('Exception:', '');
}