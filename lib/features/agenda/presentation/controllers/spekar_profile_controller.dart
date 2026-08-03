import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/config/approutes/app_routes.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/toast_message_helper.dart';
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

  String get _speakerEmail =>
      _info['email']?.toString() ??
      speaker['email']?.toString() ??
      '';

  Future<void> openLinkedIn() async {
    final url = _getSocialUrl('LinkedIn');
    if (url == null || url.isEmpty) {
      ToastMessageHelper.showToastMessage(
        '$speakerName has not shared a LinkedIn profile.',
        title: 'Info',
      );
      return;
    }
    await _launch(url, failureMessage: 'Could not open the LinkedIn profile.');
  }

  Future<void> openWebsite() async {
    final websites = _info['personalWebsites'] as List?;
    final url = (websites != null && websites.isNotEmpty)
        ? websites.first?.toString()
        : null;
    if (url == null || url.isEmpty) {
      ToastMessageHelper.showToastMessage(
        '$speakerName has not shared a website.',
        title: 'Info',
      );
      return;
    }
    await _launch(url, failureMessage: 'Could not open the website.');
  }

  /// Opens the device mail composer addressed to the speaker.
  Future<void> contractSpeaker() async {
    final email = _speakerEmail.trim();
    if (email.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'No contact email is available for this speaker.',
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

  /// The agenda details route is keyed by the session's index (same value the
  /// agenda list passes), falling back to its id when the index is absent.
  void goToSessionDetails(BuildContext context, Map<String, dynamic> session) {
    final idx = session['sessionIndex']?.toString() ?? '';
    final sessionRef = idx.isNotEmpty ? idx : (session['_id']?.toString() ?? '');
    if (sessionRef.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'Session details are not available.',
        title: 'Info',
      );
      return;
    }
    context.pushNamed(AppRoutes.agendaDetailsScreen, extra: sessionRef);
  }

  /// Launches [raw] externally, prefixing https:// when the scheme is missing.
  Future<void> _launch(String raw, {required String failureMessage}) async {
    final trimmed = raw.trim();
    final uri = Uri.tryParse(
      trimmed.startsWith('http://') || trimmed.startsWith('https://')
          ? trimmed
          : 'https://$trimmed',
    );
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ToastMessageHelper.showToastMessage(failureMessage, title: 'Error');
    }
  }
}
