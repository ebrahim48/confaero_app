import 'package:get/get.dart';

class SpeakerProfileController extends GetxController {
  // Speaker data
  final RxMap<String, dynamic> speaker = <String, dynamic>{}.obs;

  // Bio expanded state
  final RxBool isBioExpanded = false.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Favorite session IDs
  final RxList<String> favoriteSessions = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSpeakerData();
  }

  // Load speaker data (from API or arguments)
  void loadSpeakerData() {
    isLoading(true);

    // Get speaker data from navigation arguments
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      speaker.value = args;
    } else {
      // Sample data for testing
      speaker.value = {
        'id': '1',
        'name': 'Dr. Jane Doe',
        'role': 'Chif AI Scientist @ TechCorp',
        'location': 'San Francisco, CA',
        'image': 'assets/images/speakers.jpg',
        'email': 'jane.doe@techcorp.com',
        'website': 'https://janedoe.com',
        'linkedin': 'https://linkedin.com/in/janedoe',
        'bio':
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        'sessions': [
          {
            'id': 'session_1',
            'type': 'KEYNOTE',
            'title': 'Unlocking higher energy density in LFP cells',
            'time': '08:30 - 09:00, 15 June 2026',
            'attendees': 125,
            'favorites': 0,
          },
          {
            'id': 'session_2',
            'type': 'KEYNOTE',
            'title': 'Unlocking higher energy density in LFP cells',
            'time': '08:30 - 09:00, 15 June 2026',
            'attendees': 98,
            'favorites': 0,
          },
        ],
      };
    }

    isLoading(false);
  }

  // Toggle bio expansion
  void toggleBioExpansion() {
    isBioExpanded.value = !isBioExpanded.value;
  }

  // Toggle session favorite
  void toggleSessionFavorite(String sessionId) {
    if (favoriteSessions.contains(sessionId)) {
      favoriteSessions.remove(sessionId);
    } else {
      favoriteSessions.add(sessionId);
    }

    // Update session favorites count in speaker data
    final sessions = speaker['sessions'] as List;
    final sessionIndex = sessions.indexWhere((s) => s['id'] == sessionId);

    if (sessionIndex != -1) {
      final session = sessions[sessionIndex];
      session['favorites'] = favoriteSessions.contains(sessionId) ? 1 : 0;
      speaker.refresh();
    }
  }

  // Check if session is favorited
  bool isSessionFavorited(String sessionId) {
    return favoriteSessions.contains(sessionId);
  }

  // Open link (website, LinkedIn, etc.)
  void openLink(String url) {
    print('Opening link: $url');
    // Implement URL launcher here
    // await launchUrl(Uri.parse(url));
  }

  // Open LinkedIn profile
  void openLinkedIn() {
    final linkedin = speaker['linkedin'];
    if (linkedin != null && linkedin.toString().isNotEmpty) {
      openLink(linkedin.toString());
    } else {
      Get.snackbar(
        'Not Available',
        'LinkedIn profile not available',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Open website
  void openWebsite() {
    final website = speaker['website'];
    if (website != null && website.toString().isNotEmpty) {
      openLink(website.toString());
    } else {
      Get.snackbar(
        'Not Available',
        'Website not available',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Contract speaker (open email)
  void contractSpeaker() {
    final email = speaker['email'];
    if (email != null && email.toString().isNotEmpty) {
      print('Opening email to: $email');
      // Implement email launcher here
      // final emailUri = Uri(
      //   scheme: 'mailto',
      //   path: email.toString(),
      //   queryParameters: {'subject': 'Speaking Opportunity'},
      // );
      // await launchUrl(emailUri);
    } else {
      Get.snackbar(
        'Not Available',
        'Email not available',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Navigate to session details
  void goToSessionDetails(Map<String, dynamic> session) {
    print('Navigate to session: ${session['title']}');
    // Get.toNamed(AppRoutes.sessionDetailsScreen, arguments: session);
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