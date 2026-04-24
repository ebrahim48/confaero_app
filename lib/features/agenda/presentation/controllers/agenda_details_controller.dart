import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../domain/services/agenda_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class AgendaDetailsController extends GetxController {
  final AgendaService _agendaService = Get.find<AgendaService>();
  final String sessionIdx;

  AgendaDetailsController(this.sessionIdx);

  final RxMap<String, dynamic> sessionDetails = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> speakerProfiles = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLiked = false.obs;

  String get currentEventId => SessionController.to.eventId;

  String get sessionTitle =>
      (sessionDetails['session'] as Map<String, dynamic>?)?['title']?.toString() ??
      'Session Details';

  @override
  void onInit() {
    super.onInit();
    if (sessionIdx.isNotEmpty) loadSessionDetails();
  }

  Future<void> loadSessionDetails() async {
    isLoading.value = true;
    try {
      final data = await _agendaService.getSessionDetails(currentEventId, sessionIdx);
      if (data != null) {
        sessionDetails.value = data;
        isLiked.value =
            (data['session'] as Map<String, dynamic>?)?['isLiked'] as bool? ?? false;
        await _loadSpeakerProfiles(data['speakers'] as List? ?? []);
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load session details', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadSpeakerProfiles(List speakers) async {
    speakerProfiles.clear();
    for (final item in speakers) {
      final s = item as Map<String, dynamic>;
      final accountId = s['accountId']?.toString() ?? '';
      final sessionRole = s['role']?.toString() ?? '';
      if (accountId.isEmpty) continue;
      try {
        final data = await _agendaService.getSpeakerDetails(currentEventId, accountId);
        if (data != null) {
          final profile = Map<String, dynamic>.from(
            (data['speaker'] as Map<String, dynamic>?) ?? {},
          );
          profile['sessionRole'] = sessionRole;
          speakerProfiles.add(profile);
        }
      } catch (_) {
        speakerProfiles.add({
          'accountId': accountId,
          'sessionRole': sessionRole,
          'name': 'Speaker',
        });
      }
    }
  }

  Future<void> toggleLike() async {
    if (sessionIdx.isEmpty) return;
    isLiked.value = !isLiked.value;
    try {
      await _agendaService.toggleSessionLike(currentEventId, sessionIdx);
    } catch (e) {
      isLiked.value = !isLiked.value;
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

  void openSpeakerDetails(BuildContext context, String speakerId) {
    context.pushNamed(AppRoutes.speakarProfileScreen, extra: speakerId);
  }
}
