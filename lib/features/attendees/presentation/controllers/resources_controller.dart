// lib/features/resources/controllers/resources_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResourcesController extends GetxController {
  // Selected tab index (0 = Q&A, 1 = Polls, 2 = Survey)
  final RxInt selectedTabIndex = 0.obs;

  // Q&A List
  final RxList<Map<String, dynamic>> qaList = <Map<String, dynamic>>[
    {
      'question': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'answer': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of thdummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'isExpanded': true,
    },
    {
      'question': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'answer': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'isExpanded': false,
    },
    {
      'question': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'answer': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'isExpanded': false,
    },
    {
      'question': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'answer': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'isExpanded': false,
    },
    {
      'question': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'answer': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'isExpanded': false,
    },
    {
      'question': 'How do I maintain my gains?',
      'answer': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'isExpanded': false,
    },
    {
      'question': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'answer': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'isExpanded': false,
    },
  ].obs;

  // Polls List
  final RxList<Map<String, dynamic>> pollsList = <Map<String, dynamic>>[
    {
      'title': 'Rate your overall event experience.',
      'creator': 'Poll create by organizer, Anthony Ciobanu',
      'responses': '10 response',
    },
    {
      'title': 'Rate your overall event experience.',
      'creator': 'Poll create by organizer, Anthony Ciobanu',
      'responses': '10 response',
    },
  ].obs;

  // Change tab
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  // Toggle Q&A expansion
  void toggleQA(int index) {
    qaList[index]['isExpanded'] = !qaList[index]['isExpanded'];
    qaList.refresh();
  }



// Survey related
  final RxInt selectedRating = 0.obs;
  final RxString selectedOption = ''.obs;
  final TextEditingController suggestionController = TextEditingController();

// Set rating
  void setRating(int rating) {
    selectedRating.value = rating;
  }

// Set option
  void setOption(String option) {
    selectedOption.value = option;
  }

// Submit survey
  void submitSurvey() {
    print('Rating: ${selectedRating.value}');
    print('Option: ${selectedOption.value}');
    print('Suggestion: ${suggestionController.text}');

    Get.snackbar(
      'Success',
      'Survey submitted successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff32A69A),
      colorText: Colors.white,
    );

    // Reset
    selectedRating.value = 0;
    selectedOption.value = '';
    suggestionController.clear();
  }

  @override
  void onClose() {
    suggestionController.dispose();
    super.onClose();
  }



}