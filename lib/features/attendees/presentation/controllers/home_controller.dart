import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../../Events/data/repositories/events_repository.dart';
import '../../../Events/domain/services/events_service.dart';
import '../../data/event_home_model.dart';
import 'floormap_controller.dart';


class HomeController extends GetxController {
  late final EventsRepository _repository;

  final selectedCategory = 0.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Home API data
  final eventHome = Rxn<EventHomeModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // The event ID for this home screen — passed via constructor or GoRouter extra
  final String eventId;

  HomeController({required this.eventId});

  final categories = [
    {'icon': 'assets/icons/speakers.svg', 'label': 'Speakers'},
    {'icon': 'assets/icons/floormap.svg', 'label': 'Floor map'},
    {'icon': 'assets/icons/exhibitors.svg', 'label': 'Exhibitors'},
    {'icon': 'assets/icons/resources.svg', 'label': 'Resources'},
    {'icon': 'assets/icons/checkinout.svg', 'label': 'Check In/Out'},
    {'icon': 'assets/icons/sponsors.svg', 'label': 'Sponsors'},
  ];

  @override
  void onInit() {
    super.onInit();
    _repository = EventsRepository(
      eventsService: EventsService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
    );
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      eventHome.value = await _repository.getEventHome(eventId);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  // Current date formatted
  String get currentDate {
    return DateFormat('EEE, d MMM, yyyy').format(DateTime.now());
  }

  void selectCategory(int index) {
    selectedCategory.value = index;
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openSponsorDetails(BuildContext context) {}

  void navigateToCategory(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.pushNamed(AppRoutes.eventSpekarScreen);
        break;
      case 1:

        if (Get.isRegistered<FloorMapController>()) {
          Get.delete<FloorMapController>(force: true);
        }
        Get.put(FloorMapController(eventId: eventId));
        context.pushNamed(AppRoutes.floorMapScreen);
        break;
      case 2:
        context.pushNamed(AppRoutes.exHabitorsScreen);
        break;
      case 3:
        context.pushNamed(AppRoutes.resourcesScreen);
        break;
      case 4:
        context.pushNamed(AppRoutes.eventCheckInCheckOutScreen);
        break;
      case 5:
        context.pushNamed(AppRoutes.sponsorsScreen);
        break;
    }
  }
}