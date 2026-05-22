import 'package:get/get.dart';

import '../../../../core/services/invitation_service.dart';

class InvitationController extends GetxController {
  final InvitationService _service = Get.find<InvitationService>();

  final invitations = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  String currentEventId = '';

  @override
  void onInit() {
    super.onInit();
    currentEventId = Get.arguments?['eventId'] as String? ?? '';
    if (currentEventId.isNotEmpty) loadInvitations();
  }

  Future<void> loadInvitations() async {
    try {
      isLoading.value = true;
      final result = await _service.getMyInvitations(currentEventId);
      invitations.value = result;
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptInvitation(String invitationId) async {
    try {
      await _service.acceptInvitation(invitationId, currentEventId);
      loadInvitations();
    } catch (e) {
    }
  }

  Future<void> rejectInvitation(String invitationId) async {
    try {
      await _service.rejectInvitation(invitationId, currentEventId);
      loadInvitations();
    } catch (e) {
    }
  }
}
