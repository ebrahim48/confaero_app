import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentsController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  final RxInt selectedFilter = 0.obs;

  // All documents
  final RxList<Map<String, dynamic>> allDocuments = <Map<String, dynamic>>[
    {
      'title': 'Venue & Floor Maps',
      'subtitle': 'Full conference schedule. Program',
      'fileSize': '23MB',
      'type': 'all',
      'showArrow': false,
    },
    {
      'title': 'Venue & Floor Maps',
      'subtitle': 'Full conference schedule. Program',
      'fileSize': '23MB',
      'type': 'all',
      'showArrow': false,
    },
    {
      'title': 'Venue & Floor Maps',
      'subtitle': 'Full conference schedule. Program',
      'fileSize': '23MB',
      'type': 'booklet',
      'showArrow': false,
    },
    {
      'title': 'Venue & Floor Maps',
      'subtitle': 'Full conference schedule. Program',
      'fileSize': '23MB',
      'type': 'floor_map',
      'showArrow': true,
    },
    {
      'title': 'Venue & Floor Maps',
      'subtitle': '',
      'fileSize': '23MB',
      'type': 'abstracts',
      'showArrow': true,
    },
    {
      'title': 'Venue & Floor Maps',
      'subtitle': 'Sample PDF: Ebook: First Steps in Event Marketing',
      'fileSize': '23MB',
      'type': 'all',
      'showArrow': true,
    },
    {
      'title': 'Venue & Floor Maps',
      'subtitle': 'Full conference schedule. Program',
      'fileSize': '23MB',
      'type': 'all',
      'showArrow': true,
    },
  ].obs;

  // Filtered documents
  RxList<Map<String, dynamic>> get filteredDocuments {
    if (selectedFilter.value == 0) {
      return allDocuments;
    } else if (selectedFilter.value == 1) {
      return allDocuments.where((doc) => doc['type'] == 'abstracts').toList().obs;
    } else if (selectedFilter.value == 2) {
      return allDocuments.where((doc) => doc['type'] == 'booklet').toList().obs;
    } else {
      return allDocuments.where((doc) => doc['type'] == 'floor_map').toList().obs;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Change filter
  void changeFilter(int index) {
    selectedFilter.value = index;
  }

  // Open document
  void openDocument(Map<String, dynamic> document) {
    print('Opening: ${document['title']}');
  }
}