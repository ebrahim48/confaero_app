import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/toast_message_helper.dart';
import '../../../connection/data/models/connection_model.dart';
import '../../../connection/domain/services/connection_service.dart';
import '../../../message/presentation/widgets/view/message_chat_screen.dart';

class ConnectionListController extends GetxController {
  final ConnectionService _connectionService = Get.find<ConnectionService>();
  final searchController = TextEditingController();

  final connections = <ConnectionModel>[].obs;
  final filteredConnections = <ConnectionModel>[].obs;

  final totalConnections = 0.obs;
  final bookmarkedCount = 0.obs;

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

  Future<void> loadConnections() async {
    isLoading.value = true;
    try {
      final result = await _connectionService.getMyConnections();
      final list = result['connections'] as List? ?? [];
      connections.value = list
          .map((e) => ConnectionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      totalConnections.value = result['total'] as int? ?? connections.length;
      bookmarkedCount.value = result['bookmarked'] as int? ?? 0;
      filteredConnections.value = connections;
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void searchConnections(String query) {
    if (query.isEmpty) {
      filteredConnections.value = connections;
    } else {
      filteredConnections.value = connections
          .where((c) =>
              c.name.toLowerCase().contains(query.toLowerCase()) ||
              c.company.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<void> toggleBookmark(String id) async {
    final index = connections.indexWhere((c) => c.id == id);
    if (index == -1) return;
    connections[index].isBookmarked = !connections[index].isBookmarked;
    connections.refresh();
    filteredConnections.refresh();
    bookmarkedCount.value = connections.where((c) => c.isBookmarked).length;
    try {
      await _connectionService.bookmarkConnection(id);
    } catch (_) {
      connections[index].isBookmarked = !connections[index].isBookmarked;
      connections.refresh();
      filteredConnections.refresh();
      bookmarkedCount.value = connections.where((c) => c.isBookmarked).length;
    }
  }

  void sayHi(BuildContext context, ConnectionModel c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessageChatScreen(
          receiverId: c.accountId.isNotEmpty ? c.accountId : c.id,
          receiverName: c.name,
          receiverImage: c.avatarUrl,
        ),
      ),
    );
  }

  Future<void> sendMail(String? email) async {
    if (email == null || email.trim().isEmpty) {
      ToastMessageHelper.showToastMessage(
        'No email address is available for this connection.',
        title: 'Info',
      );
      return;
    }
    final uri = Uri.parse('mailto:${email.trim()}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ToastMessageHelper.showToastMessage(
        'No email app found on this device.',
        title: 'Error',
      );
    }
  }

  Future<void> refreshConnections() async => loadConnections();
}
