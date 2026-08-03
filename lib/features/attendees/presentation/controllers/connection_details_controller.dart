import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/toast_message_helper.dart';
import '../../../connection/data/models/connection_model.dart';
import '../../../connection/domain/services/connection_service.dart';
import '../../../message/presentation/widgets/view/message_chat_screen.dart';

class ConnectionDetailsController extends GetxController {
  final ConnectionService _connectionService = Get.find<ConnectionService>();

  final isLoading = false.obs;
  final isBookmarking = false.obs;
  final Rxn<ConnectionModel> connection = Rxn<ConnectionModel>();

  Future<void> loadDetails(String connectionId) async {
    try {
      isLoading.value = true;
      final model = await _connectionService.getConnectionDetails(connectionId);
      connection.value = model;
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleBookmark() async {
    final c = connection.value;
    if (c == null) return;
    isBookmarking.value = true;
    final prev = c.isBookmarked;
    c.isBookmarked = !prev;
    connection.refresh();
    try {
      await _connectionService.bookmarkConnection(c.id);
    } catch (_) {
      c.isBookmarked = prev;
      connection.refresh();
    } finally {
      isBookmarking.value = false;
    }
  }

  void sayHi(BuildContext context) {
    final c = connection.value;
    if (c == null) {
      ToastMessageHelper.showToastMessage(
        'This connection cannot be messaged right now.',
        title: 'Info',
      );
      return;
    }
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

  Future<void> sendMail() async {
    final email = connection.value?.email?.trim() ?? '';
    if (email.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'No email address is available for this connection.',
        title: 'Info',
      );
      return;
    }
    final uri = Uri.parse('mailto:$email');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ToastMessageHelper.showToastMessage(
        'No email app found on this device.',
        title: 'Error',
      );
    }
  }
}
