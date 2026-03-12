import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../documents/data/models/document_model.dart';
import '../../../documents/domain/services/document_service.dart';

class DocumentsController extends GetxController {
  final DocumentService _service = Get.find<DocumentService>();
  final TextEditingController searchController = TextEditingController();

  final RxInt selectedFilter = 0.obs;

  // Observable variables
  final RxList<DocumentModel> allDocuments = <DocumentModel>[].obs;
  final RxBool isLoading = false.obs;

  // Read event ID from global session state
  String get currentEventId => SessionController.to.eventId;

  @override
  void onInit() {
    super.onInit();
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    isLoading.value = true;
    try {
      final docs = await _service.getAllDocuments(currentEventId);
      allDocuments.assignAll(docs);
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to load documents');
    } finally {
      isLoading.value = false;
    }
  }

  // Filtered documents (simplifying filter since types might not exist on API)
  RxList<DocumentModel> get filteredDocuments {
    return allDocuments; // Currently ignoring filters since dummy data filters don't map to real model yet
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
  void openDocument(DocumentModel document) {
    print('Opening: ${document.name} at ${document.fileUrl}');
    // Ideally use url_launcher to open PDF
  }
}
