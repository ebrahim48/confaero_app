import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Connection Model
class Connection {
  final String id;
  final String name;
  final String company;
  final String role;
  final int eventsCount;
  final int sessionsCount;
  final String avatarUrl;
  bool isBookmarked;

  Connection({
    required this.id,
    required this.name,
    required this.company,
    required this.role,
    required this.eventsCount,
    required this.sessionsCount,
    required this.avatarUrl,
    this.isBookmarked = false,
  });
}

class ConnectionListController extends GetxController {
  // Search controller
  final searchController = TextEditingController();

  // Connections list
  final connections = <Connection>[].obs;
  final filteredConnections = <Connection>[].obs;

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
  void loadConnections() {
    isLoading.value = true;

    // Static connection data - 3 connections
    connections.value = [
      Connection(
        id: '1',
        name: 'Rachid Amine',
        company: 'Tech Corp',
        role: 'Organizer',
        eventsCount: 2,
        sessionsCount: 2,
        avatarUrl: 'assets/images/profile.png',
        isBookmarked: true,
      ),
      Connection(
        id: '2',
        name: 'Rachid Amine',
        company: 'Tech Corp',
        role: 'Speakers',
        eventsCount: 2,
        sessionsCount: 2,
        avatarUrl: 'assets/images/profile.png',
        isBookmarked: true,
      ),
      Connection(
        id: '3',
        name: 'Rachid Amine',
        company: 'Tech Corp',
        role: 'Attendee',
        eventsCount: 2,
        sessionsCount: 2,
        avatarUrl: 'assets/images/profile.png',
        isBookmarked: true,
      ),
    ];

    filteredConnections.value = connections;
    updateStats();
    isLoading.value = false;
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
      filteredConnections.value = connections
          .where((connection) =>
      connection.name.toLowerCase().contains(query.toLowerCase()) ||
          connection.company.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Toggle bookmark
  void toggleBookmark(String id) {
    final index = connections.indexWhere((c) => c.id == id);
    if (index != -1) {
      connections[index].isBookmarked = !connections[index].isBookmarked;
      connections.refresh();
      filteredConnections.refresh();
      updateStats();
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