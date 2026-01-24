// lib/features/attendees/controllers/attendees_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendeesController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  // Total stats
  final RxInt totalAttendees = 5.obs;
  final RxInt bookmarked = 3.obs;

  // Attendees list
  final RxList<Map<String, dynamic>> attendees = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'Rachid Amine',
      'company': 'Tech Corp',
      'role': 'Organizer',
      'sessions': '2 sessions',
      'image': 'assets/images/attendee1.jpg',
      'isBookmarked': false,
    },
    {
      'id': '2',
      'name': 'Rachid Amine',
      'company': 'Tech Corp',
      'role': 'Speakers',
      'sessions': '2 sessions',
      'image': 'assets/images/attendee2.jpg',
      'isBookmarked': true,
    },
    {
      'id': '3',
      'name': 'Rachid Amine',
      'company': 'Tech Corp',
      'role': 'Speakers',
      'sessions': '2 sessions',
      'image': 'assets/images/attendee3.jpg',
      'isBookmarked': false,
    },
    {
      'id': '4',
      'name': 'Rachid Amine',
      'company': 'Tech Corp',
      'role': 'Attendee',
      'sessions': '2 sessions',
      'image': 'assets/images/attendee4.jpg',
      'isBookmarked': true,
    },
  ].obs;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Toggle bookmark
  void toggleBookmark(String id) {
    final index = attendees.indexWhere((a) => a['id'] == id);
    if (index != -1) {
      attendees[index]['isBookmarked'] = !attendees[index]['isBookmarked'];
      attendees.refresh();

      // Update bookmarked count
      bookmarked.value = attendees.where((a) => a['isBookmarked'] == true).length;
    }
  }

  // Say Hi
  void sayHi(String name) {
    print('Say Hi to $name');
  }

  // Send Mail
  void sendMail(String name) {
    print('Send mail to $name');
  }
}