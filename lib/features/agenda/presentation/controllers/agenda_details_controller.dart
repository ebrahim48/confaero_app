import 'package:get/get.dart';

class AgendaDetailsController extends GetxController {
  // Session details
  final RxMap<String, dynamic> sessionDetails = <String, dynamic>{
    'title': 'Sample session 1: ConfAero for Virtual Events',
    'date': 'Monday, 15 June 2026, from 10:00 am to 11:00 am',
    'location': 'Location',
    'overview': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,',
    'howToAttend': [
      {'icon': 'desktop', 'text': 'Watch on desktop (recommended)'},
      {'icon': 'video', 'text': 'Recorded video available after session'},
      {'icon': 'location', 'text': 'On-site seating: Plenary Room'},
    ],
    'speakers': [
      {
        'name': 'Devid Smith',
        'role': 'Speaker',
        'company': 'Sample Inc, Speaker',
        'image': 'assets/images/speaker1.jpg',
      },
      {
        'name': 'Devid Smith',
        'role': 'Director',
        'company': 'Sample Inc, Speaker',
        'image': 'assets/images/speaker2.jpg',
      },
      {
        'name': 'Devid Smith',
        'role': 'Director',
        'company': 'Sample Inc, Speaker',
        'image': 'assets/images/speaker3.jpg',
      },
    ],
  }.obs;

  // Is liked
  final RxBool isLiked = false.obs;

  // Toggle like
  void toggleLike() {
    isLiked.value = !isLiked.value;
  }

  // Open Q&A
  void openQA() {
    print('Open Q&A');
  }

  // Open Poll
  void openPoll() {
    print('Open Poll');
  }

  // Open Note
  void openNote() {
    print('Open Note');
  }

  // View map
  void viewMap() {
    print('View Map');
  }

  // Speaker details
  void openSpeakerDetails(Map<String, dynamic> speaker) {
    print('Open speaker: ${speaker['name']}');
  }
}