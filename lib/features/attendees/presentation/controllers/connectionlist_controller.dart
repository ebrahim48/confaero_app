import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../connection/data/models/connection_model.dart';
import '../../../connection/domain/services/connection_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class ConnectionListController extends GetxController {
  final ConnectionService _connectionService = Get.find<ConnectionService>();
  // Search controller
  final searchController = TextEditingController();

  // Connections list
  final connections = <ConnectionModel>[].obs;
  final filteredConnections = <ConnectionModel>[].obs;

  // Pending requests
  final pendingRequests = <dynamic>[].obs;

  // Stats
  final totalConnections = 0.obs;
  final bookmarkedCount = 0.obs;
  final pendingCount = 0.obs;

  // Loading state
  final isLoading = false.obs;

  // Tab: 0 = My Connections, 1 = Pending Requests
  final selectedTab = 0.obs;

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
      ToastMessageHelper.showToastMessage('Failed to load connections', title: 'Error');
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
      ToastMessageHelper.showToastMessage('Could not update bookmark', title: 'Error');
    }
  }

  /// Load pending connection requests
  Future<void> loadPendingRequests() async {
    isLoading.value = true;
    try {
      final data = await _connectionService.getPendingRequests();
      pendingRequests.assignAll(data);
      pendingCount.value = data.length;
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load pending requests', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  /// Accept a connection request
  Future<void> acceptRequest(String requestId) async {
    try {
      await _connectionService.acceptRequest(requestId);
      pendingRequests.removeWhere((r) => r.id == requestId);
      pendingCount.value = pendingRequests.length;
      ToastMessageHelper.showToastMessage('Connection accepted!', title: 'Success');
      // Refresh connections to show the new one
      loadConnections();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to accept request', title: 'Error');
    }
  }

  /// Get connection details
  Future<ConnectionModel?> getConnectionDetails(String id) async {
    try {
      return await _connectionService.getConnectionDetails(id);
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load connection details', title: 'Error');
      return null;
    }
  }

  /// Switch tab
  void switchTab(int index) {
    selectedTab.value = index;
    if (index == 1 && pendingRequests.isEmpty) {
      loadPendingRequests();
    }
  }

  // Say Hi action
  void sayHi(String id) {
    ToastMessageHelper.showToastMessage('Say Hi to connection', title: 'Message');
  }

  // Send Mail action
  void sendMail(String id) {
    ToastMessageHelper.showToastMessage('Opening email...', title: 'Email');
  }

  // Refresh connections
  Future<void> refreshConnections() async {
    await loadConnections();
    if (selectedTab.value == 1) {
      await loadPendingRequests();
    }
  }
}
