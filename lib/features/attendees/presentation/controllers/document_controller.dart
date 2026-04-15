import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../documents/data/models/document_model.dart';
import '../../../documents/domain/services/document_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class DocumentsController extends GetxController {
  final DocumentService _service = Get.find<DocumentService>();
  final TextEditingController searchController = TextEditingController();

  final RxInt selectedFilter = 0.obs; // 0 = All, 1 = My Documents

  // Observable variables
  final RxList<DocumentModel> allDocuments = <DocumentModel>[].obs;
  final RxList<DocumentModel> myDocuments = <DocumentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;

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
      ToastMessageHelper.showToastMessage('Failed to load documents', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch only the current user's uploaded documents
  Future<void> fetchMyDocuments() async {
    isLoading.value = true;
    try {
      final docs = await _service.getMyDocuments(currentEventId);
      myDocuments.assignAll(docs);
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load your documents', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  /// Upload a document via file picker
  Future<void> uploadDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'],
      );

      if (result != null && result.files.single.path != null) {
        isUploading.value = true;
        final file = File(result.files.single.path!);
        final name = result.files.single.name;

        await _service.uploadDocument(currentEventId, file, name);
        ToastMessageHelper.showToastMessage('Document uploaded successfully', title: 'Success');

        // Refresh list
        await fetchDocuments();
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to upload document', title: 'Error');
    } finally {
      isUploading.value = false;
    }
  }

  /// Delete a user's own document
  Future<void> deleteDocument(String documentId) async {
    try {
      await _service.deleteMyDocument(documentId);
      allDocuments.removeWhere((d) => d.id == documentId);
      myDocuments.removeWhere((d) => d.id == documentId);
      ToastMessageHelper.showToastMessage('Document deleted', title: 'Success');
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to delete document', title: 'Error');
    }
  }

  // Get documents based on selected filter
  List<DocumentModel> get filteredDocuments {
    if (selectedFilter.value == 1) return myDocuments;
    return allDocuments;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Change filter
  void changeFilter(int index) {
    selectedFilter.value = index;
    if (index == 1 && myDocuments.isEmpty) {
      fetchMyDocuments();
    }
  }

  // Open document
  void openDocument(DocumentModel document) {
    // TODO: use url_launcher to open document URL
  }
}
