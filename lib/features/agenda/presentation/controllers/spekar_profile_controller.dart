import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../domain/services/agenda_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class SpeakerProfileController extends GetxController {
  final AgendaService _agendaService = Get.find<AgendaService>();

  // Speaker data
  final RxMap<String, dynamic> speaker = <String, dynamic>{}.obs;

  // Bio expanded state
  final RxBool isBioExpanded = false.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Favorite session IDs
  final RxList<String> favoriteSessions = <String>[].obs;

  // Event ID from global session state
  String get currentEventId => SessionController.to.eventId;

  @override
  void onInit() {
    super.onInit();
    loadSpeakerData();
  }

  // Load speaker data from API or arguments
  Future<void> loadSpeakerData() async {
    isLoading(true);

    // Get speaker data from navigation arguments
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      // If full data passed via arguments, use it
      speaker.value = args;

      // If only speakerId passed, fetch from API
      final speakerId =
          args['speakerId']?.toString() ??
          args['_id']?.toString() ??
          args['id']?.toString();
      if (speakerId != null && speakerId.isNotEmpty && args.keys.length <= 2) {
        try {
          final data = await _agendaService.getSpeakerDetails(
            currentEventId,
            speakerId,
          );
          if (data != null) {
            speaker.value = data;
          }
        } catch (e) {
          ToastMessageHelper.showToastMessage('Failed to load speaker details', title: 'Error');
        }
      }
    }

    isLoading(false);
  }

  // Toggle bio expansion
  void toggleBioExpansion() {
    isBioExpanded.value = !isBioExpanded.value;
  }

  // Toggle session favorite via API
  Future<void> toggleSessionFavorite(String sessionId) async {
    if (favoriteSessions.contains(sessionId)) {
      favoriteSessions.remove(sessionId);
      try {
        await _agendaService.removeBookmarkSession(currentEventId, sessionId);
      } catch (e) {
        favoriteSessions.add(sessionId); // revert
      }
    } else {
      favoriteSessions.add(sessionId);
      try {
        await _agendaService.bookmarkSession(currentEventId, sessionId);
      } catch (e) {
        favoriteSessions.remove(sessionId); // revert
      }
    }

    // Update session favorites count in speaker data
    final sessions = speaker['sessions'] as List?;
    if (sessions != null) {
      final sessionIndex = sessions.indexWhere(
        (s) => s['id'] == sessionId || s['_id'] == sessionId,
      );
      if (sessionIndex != -1) {
        final session = sessions[sessionIndex];
        session['favorites'] = favoriteSessions.contains(sessionId) ? 1 : 0;
        speaker.refresh();
      }
    }
  }

  // Check if session is favorited
  bool isSessionFavorited(String sessionId) {
    return favoriteSessions.contains(sessionId);
  }

  // Open link
  void openLink(String url) {
    // TODO: use url_launcher
  }

  // Open LinkedIn profile
  void openLinkedIn() {
    final linkedin = speaker['linkedin'];
    if (linkedin != null && linkedin.toString().isNotEmpty) {
      openLink(linkedin.toString());
    } else {
      ToastMessageHelper.showToastMessage('LinkedIn profile not available', title: 'Not Available');
    }
  }

  // Open website
  void openWebsite() {
    final website = speaker['website'];
    if (website != null && website.toString().isNotEmpty) {
      openLink(website.toString());
    } else {
      ToastMessageHelper.showToastMessage('Website not available', title: 'Not Available');
    }
  }

  // Contact speaker
  void contractSpeaker() {
    final email = speaker['email'];
    if (email != null && email.toString().isNotEmpty) {
      // TODO: use url_launcher to open mailto
    } else {
      ToastMessageHelper.showToastMessage('Email not available', title: 'Not Available');
    }
  }

  // Navigate to session details
  void goToSessionDetails(Map<String, dynamic> session) {
    // TODO: navigate to session details screen
  }

  // Get bio text (truncated or full)
  String getBioText() {
    final bio = speaker['bio']?.toString() ?? '';
    if (isBioExpanded.value || bio.length <= 200) {
      return bio;
    }
    return '${bio.substring(0, 200)}...';
  }

  // Get session count
  int getSessionCount() {
    final sessions = speaker['sessions'];
    if (sessions != null && sessions is List) {
      return sessions.length;
    }
    return 0;
  }
}
