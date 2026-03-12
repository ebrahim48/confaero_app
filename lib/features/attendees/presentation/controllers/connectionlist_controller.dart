import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../connection/data/models/connection_model.dart';
import '../../../connection/domain/services/connection_service.dart';

class ConnectionListController extends GetxController {
  final ConnectionService _connectionService = Get.find<ConnectionService>();
  // Search controller
  final searchController = TextEditingController();

  // Connections list
  final connections = <ConnectionModel>[].obs;
  final filteredConnections = <ConnectionModel>[].obs;

  // Stats
  final totalConnections = 0.obs;
  final bookmarkedCount = 0.obs;

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadConnections();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Load connections (static data)
  Future<void> loadConnections() async {
    isLoading.value = true;
    try {
      final data = await _connectionService.getMyConnections();
      connections.value = data;
      filteredConnections.value = connections;
      updateStats();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load connections',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update stats
  void updateStats() {
    totalConnections.value = connections.length;
    bookmarkedCount.value = connections.where((c) => c.isBookmarked).length;
  }

  // Search connections
  void searchConnections(String query) {
    if (query.isEmpty) {
      filteredConnections.value = connections;
    } else {
      filteredConnections.value =
          connections
              .where(
                (connection) =>
                    connection.name.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    connection.company.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
    }
  }

  // Toggle bookmark
  Future<void> toggleBookmark(String id) async {
    try {
      final index = connections.indexWhere((c) => c.id == id);
      if (index != -1) {
        // Optimistic update
        connections[index].isBookmarked = !connections[index].isBookmarked;
        connections.refresh();
        filteredConnections.refresh();
        updateStats();

        await _connectionService.bookmarkConnection(id);
      }
    } catch (e) {
      // Revert if error
      final index = connections.indexWhere((c) => c.id == id);
      if (index != -1) {
        connections[index].isBookmarked = !connections[index].isBookmarked;
        connections.refresh();
        filteredConnections.refresh();
        updateStats();
      }
      Get.snackbar(
        'Error',
        'Could not update bookmark',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Say Hi action
  void sayHi(String id) {
    Get.snackbar(
      'Message',
      'Say Hi to connection',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  // Send Mail action
  void sendMail(String id) {
    Get.snackbar(
      'Email',
      'Opening email...',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  // Refresh connections
  Future<void> refreshConnections() async {
    await Future.delayed(const Duration(seconds: 1));
    loadConnections();
  }
}
