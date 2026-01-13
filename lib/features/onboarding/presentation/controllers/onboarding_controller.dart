import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final currentPage = 0.obs;

  final onboardingData = [
    {
      'image': 'assets/images/welcome.png',
      'title': 'Welcome to ConfAero',
      'description': 'Your conference hub for schedules, networking, documents, and live updates.',
    },
    {
      'image': 'assets/images/planconference.png',
      'title': 'Plan your conference day',
      'description': 'Browse sessions and speakers, build your personal agenda, and get reminders so you never miss of talk',
    },
    {
      'image': 'assets/images/meetconnect.png',
      'title': 'Meet and connect with peers',
      'description': 'Browse attendee profiles, message participants to grow your professional network.',
    },
    {
      'image': 'assets/images/accesshandouts.png',
      'title': 'Access handouts and maps',
      'description': 'View digital handouts and real-time maps so you can quickly find every session and navigate the venue confidence',
    },
  ];

  void nextPage() {
    if (currentPage.value < onboardingData.length - 1) {
      currentPage.value++;
    } else {
      // Navigate to next screen
      completeOnboarding();
    }
  }

  void skipIntro() {
    completeOnboarding();
  }

  void completeOnboarding() {

  }

  void goToPage(int index) {
    currentPage.value = index;
  }
}