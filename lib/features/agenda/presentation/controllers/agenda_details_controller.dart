import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../domain/services/agenda_service.dart';

class AgendaDetailsController extends GetxController {
  final AgendaService _agendaService = Get.find<AgendaService>();

  // Session details
  final RxMap<String, dynamic> sessionDetails = <String, dynamic>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLiked = false.obs;

  // Event ID from global session state
  String get currentEventId => SessionController.to.eventId;

  @override
  void onInit() {
    super.onInit();
    // Get session ID from route arguments
    final args = Get.arguments;
    if (args != null &&
        args is Map<String, dynamic> &&
        args['sessionId'] != null) {
      loadSessionDetails(args['sessionId'] as String);
    }
  }

  /// Load session details from API
  Future<void> loadSessionDetails(String sessionId) async {
    isLoading.value = true;
    try {
      final data = await _agendaService.getSessionDetails(
        currentEventId,
        sessionId,
      );
      if (data != null) {
        sessionDetails.value = data;
        isLiked.value = data['isLiked'] as bool? ?? false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load session details',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle like via API
  Future<void> toggleLike() async {
    final sessionId = sessionDetails['_id']?.toString() ?? '';
    if (sessionId.isEmpty) return;

    isLiked.value = !isLiked.value;
    try {
      await _agendaService.toggleSessionLike(currentEventId, sessionId);
    } catch (e) {
      isLiked.value = !isLiked.value; // revert on failure
    }
  }

  void openQA(BuildContext context) {
    context.pushNamed(AppRoutes.resourcesScreen);
  }

  void openPoll(BuildContext context) {
    context.pushNamed(AppRoutes.pollScreen);
  }

  void openNote(BuildContext context) {
    context.pushNamed(AppRoutes.quickNotesScreen);
  }

  void viewMap(BuildContext context) {
    context.pushNamed(AppRoutes.floorMapScreen);
  }

  void openSpeakerDetails(BuildContext context) {
    context.pushNamed(AppRoutes.speakarProfileScreen);
  }
}
