import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeController extends GetxController {
  final selectedCategory = 0.obs;

  final categories = [
    {'icon': 'assets/icons/speakers.svg', 'label': 'Speakers'},
    {'icon': 'assets/icons/floormap.svg', 'label': 'Floor map'},
    {'icon': 'assets/icons/exhibitors.svg', 'label': 'Exhibitors'},
    {'icon': 'assets/icons/resources.svg', 'label': 'Resources'},
    {'icon': 'assets/icons/checkinout.svg', 'label': 'Check In/Out'},
    {'icon': 'assets/icons/sponsors.svg', 'label': 'Sponsors'},
  ];

  void selectCategory(int index) {
    selectedCategory.value = index;
  }

  void openSponsorDetails(BuildContext context) {
    // Navigate to sponsor details or external link
  }

  void navigateToCategory(BuildContext context, int index) {
    // Navigate based on category
    switch (index) {
      case 0:
      // Navigate to Speakers
        break;
      case 1:
      // Navigate to Floor map
        break;
      case 2:
      // Navigate to Exhibitors
        break;
      case 3:
      // Navigate to Resources
        break;
      case 4:
      // Navigate to Check In/Out
        break;
      case 5:
      // Navigate to Sponsors
        break;
      case 6:
      // Navigate to Photos
        break;
      case 7:
      // Navigate to Documents
        break;
      case 8:
      // Navigate to Poster
        break;
      case 9:
      // Navigate to Job
        break;
    }
  }
}