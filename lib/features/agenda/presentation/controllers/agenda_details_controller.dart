import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/controllers/role_controller.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../domain/services/agenda_service.dart';

class AgendaDetailsController extends GetxController {
  final AgendaService _agendaService = Get.find<AgendaService>();
  final String sessionIdx;

  AgendaDetailsController(this.sessionIdx);

  final RxMap<String, dynamic> sessionDetails = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> speakerProfiles = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLiked = false.obs;
  final RxBool isAddingSpeaker = false.obs;
  final RxBool isRemovingSpeaker = false.obs;
  final RxBool isSearchingSpeaker = false.obs;
  final Rxn<Map<String, dynamic>> speakerSearchResult = Rxn();
  final RxString speakerSearchError = ''.obs;

  String get currentEventId => SessionController.to.eventId;

  String get sessionTitle =>
      (sessionDetails['session'] as Map<String, dynamic>?)?['title']?.toString() ??
      'Session Details';

  bool get isTrackChair =>
      RoleController.to.activeRole.value.toUpperCase() == 'TRACK_CHAIR';

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
    context.pushNamed(
      AppRoutes.speakarProfileScreen,
      extra: speakerId,
      queryParameters: {'sessionIdx': sessionIdx},
    );
  }

  Future<void> searchSpeaker(String email) async {
    if (email.trim().isEmpty) {
      speakerSearchResult.value = null;
      speakerSearchError.value = '';
      return;
    }
    isSearchingSpeaker.value = true;
    speakerSearchError.value = '';
    speakerSearchResult.value = null;
    try {
      final result = await _agendaService.searchSpeakerByEmail(
        currentEventId,
        email.trim(),
      );
      speakerSearchResult.value = result;
      if (result == null) speakerSearchError.value = 'No speaker found';
    } catch (e) {
      speakerSearchError.value = 'No speaker found';
    } finally {
      isSearchingSpeaker.value = false;
    }
  }

  void clearSpeakerSearch() {
    speakerSearchResult.value = null;
    speakerSearchError.value = '';
    isSearchingSpeaker.value = false;
  }

  Future<void> addSpeaker(String speakerId) async {
    if (speakerId.isEmpty) return;
    isAddingSpeaker.value = true;
    try {
      await _agendaService.addSpeaker(currentEventId, sessionIdx, speakerId);
      await loadSessionDetails(); // refresh
      ToastMessageHelper.showToastMessage('Speaker added to session');
    } catch (e) {
      _showError(e, 'Could not add the speaker.');
    } finally {
      isAddingSpeaker.value = false;
    }
  }

  Future<void> removeSpeaker(String speakerId) async {
    if (speakerId.isEmpty) return;
    isRemovingSpeaker.value = true;
    try {
      await _agendaService.removeSpeaker(currentEventId, sessionIdx, speakerId);
      await loadSessionDetails(); // refresh
      ToastMessageHelper.showToastMessage('Speaker removed from session');
    } catch (e) {
      _showError(e, 'Could not remove the speaker.');
    } finally {
      isRemovingSpeaker.value = false;
    }
  }

  void _showError(Object e, String fallback) {
    final msg = e.toString().replaceAll('Exception: ', '').trim();
    ToastMessageHelper.showToastMessage(
      msg.isEmpty ? fallback : msg,
      title: 'Error',
    );
  }
}
