import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../domain/services/agenda_service.dart';

class SpeakerProfileController extends GetxController {
  final AgendaService _agendaService = Get.find<AgendaService>();
  final String speakerId;

  SpeakerProfileController(this.speakerId);

  final RxMap<String, dynamic> speaker = <String, dynamic>{}.obs;
  final RxBool isBioExpanded = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<String> favoriteSessions = <String>[].obs;

  String get currentEventId => SessionController.to.eventId;

  Map<String, dynamic> get _info =>
      (speaker['speaker'] as Map<String, dynamic>?) ?? {};

  // ── Computed fields ──────────────────────────────────────────────
  String get speakerName => _info['name']?.toString() ?? '';

  String get speakerAvatar => _info['avatar']?.toString() ?? '';

  String get speakerLocation =>
      (_info['location'] as Map<String, dynamic>?)?['address']?.toString() ?? '';

  String get speakerRole {
    final affiliations = _info['affiliations'] as List?;
    if (affiliations == null || affiliations.isEmpty) return '';
    final aff = affiliations.firstWhere(
          (a) => (a as Map<String, dynamic>)['isCurrent'] == true,
      orElse: () => affiliations.first,
    ) as Map<String, dynamic>;
    final position = aff['position']?.toString() ?? '';
    final company = aff['company']?.toString() ?? '';
    if (position.isEmpty) return company;
    if (company.isEmpty) return position;
    return '$position at $company';
  }

  List<Map<String, dynamic>> get speakingAtSessions {
    final list = (speaker['speakingAt'] as List?) ?? [];
    return list.cast<Map<String, dynamic>>();
  }

  // ── Data loading ─────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadSpeakerData();
  }

  Future<void> loadSpeakerData() async {
    if (speakerId.isEmpty) return;
    isLoading(true);
    try {
      final data = await _agendaService.getSpeakerDetails(currentEventId, speakerId);
      if (data != null) {
        speaker.value = data;
      }
    } catch (e) {
    } finally {
      isLoading(false);
    }
  }

  // ── Bio ──────────────────────────────────────────────────────────
  void toggleBioExpansion() => isBioExpanded.value = !isBioExpanded.value;

  String getBioText() {
    final bio = _info['about']?.toString() ?? '';
    if (isBioExpanded.value || bio.length <= 200) return bio;
    return '${bio.substring(0, 200)}...';
  }

  // ── Session bookmark toggle ───────────────────────────────────────
  Future<void> toggleSessionFavorite(String sessionId) async {
    if (favoriteSessions.contains(sessionId)) {
      favoriteSessions.remove(sessionId);
      try {
        await _agendaService.removeBookmarkSession(currentEventId, sessionId);
      } catch (e) {
        favoriteSessions.add(sessionId);
      }
    } else {
      favoriteSessions.add(sessionId);
      try {
        await _agendaService.bookmarkSession(currentEventId, sessionId);
      } catch (e) {
        favoriteSessions.remove(sessionId);
      }
    }
  }

  bool isSessionFavorited(String sessionId) => favoriteSessions.contains(sessionId);

  int getSessionCount() => speakingAtSessions.length;

  // ── External links ───────────────────────────────────────────────
  String? _getSocialUrl(String platform) {
    final links = _info['socialLinks'] as List?;
    if (links == null) return null;
    for (final link in links) {
      final m = link as Map<String, dynamic>;
      if (m['platform'] == platform) return m['url']?.toString();
    }
    return null;
  }

  void openLinkedIn() {
    final url = _getSocialUrl('LinkedIn');
    if (url != null && url.isNotEmpty) {
      // TODO: url_launcher
    } else {
    }
  }

  void openWebsite() {
    final websites = _info['personalWebsites'] as List?;
    final url = (websites != null && websites.isNotEmpty) ? websites.first?.toString() : null;
    if (url != null && url.isNotEmpty) {
      // TODO: url_launcher
    } else {
    }
  }

  void contractSpeaker() {
  }

  void goToSessionDetails(Map<String, dynamic> session) {
    // TODO: navigate to session details
  }
}
