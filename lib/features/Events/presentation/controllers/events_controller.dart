import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EventsController extends GetxController {
  final searchController = TextEditingController();
  final selectedTab = 0.obs; // 0 for My Events, 1 for Explore Events

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void switchTab(int index) {
    selectedTab.value = index;
  }

  void onSearchChanged(String value) {
    // TODO: Implement search functionality
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
  void registerEvent(BuildContext context) {
    context.pushNamed(AppRoutes.eventsDetailsScreen);
    // TODO: Implement register event API
  }

  void openEventDetails() {
    // TODO: Navigate to event details screen
  }
}