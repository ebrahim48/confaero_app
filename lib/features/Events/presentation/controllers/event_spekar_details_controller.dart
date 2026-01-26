// lib/features/attendees/controllers/attendee_details_controller.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventSpekarDetailsController extends GetxController {
  // Attendee details
  final RxMap<String, dynamic> attendeeDetails = <String, dynamic>{
    'name': 'Rachid Amine',
    'company': 'Tech Corp',
    'role': 'Attendee',
    'sessions': '2 sessions',
    'image': 'assets/images/attendee1.jpg',
    'email': 'example@gmail.com',
    'phone': '65415456546541',
    'location': 'Dhaka, Bangladesh',
    'isBookmarked': false,
  }.obs;

  // Toggle bookmark
  void toggleBookmark() {
    attendeeDetails['isBookmarked'] = !attendeeDetails['isBookmarked'];
    attendeeDetails.refresh();
  }

  // Say Hi
  void sayHi() {
    print('Say Hi');
  }

  // Send Mail
  void sendMail() {
    print('Send Mail to ${attendeeDetails['email']}');
  }

  // Request to Connect
  void requestToConnect() {
    Get.snackbar(
      'Success',
      'Connection request sent!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff32A69A),
      colorText: Colors.white,
    );
  }
}