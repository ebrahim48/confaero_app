import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../documents/data/models/document_model.dart';
import '../../../documents/domain/services/document_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class DocumentsController extends GetxController {
  final DocumentService _service = Get.find<DocumentService>();
  final TextEditingController searchController = TextEditingController();

  final RxInt selectedFilter = 0.obs; // 0 = All, 1 = My Documents

  final RxList<DocumentModel> allDocuments = <DocumentModel>[].obs;
  final RxList<DocumentModel> myDocuments = <DocumentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;

  final Rx<DocumentDetailsModel?> documentDetails =
      Rx<DocumentDetailsModel?>(null);
  final RxBool isLoadingDetails = false.obs;


  String get currentEventId => SessionController.to.eventId;

  @override
  void onInit() {
    super.onInit();
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    isLoading.value = true;
    try {
      final docs = await _service.getPublicDocuments(currentEventId);
      allDocuments.assignAll(docs);
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load documents', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDocumentDetails(String documentId) async {
    isLoadingDetails.value = true;
    documentDetails.value = null;
    try {
      final details =
          await _service.getDocumentDetails(currentEventId, documentId);
      documentDetails.value = details;
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load document details', title: 'Error');
    } finally {
      isLoadingDetails.value = false;
    }
  }

  // Filter by documentType based on selected chip index
  RxList<DocumentModel> get filteredDocuments {
    if (selectedFilter.value == 0) return allDocuments;
    final typeMap = {1: 'Abstracts', 2: 'Booklet', 3: 'Panels'};
    final type = typeMap[selectedFilter.value];
    if (type == null) return allDocuments;
    return allDocuments
        .where((d) => d.documentType.toLowerCase() == type.toLowerCase())
        .toList()
        .obs;
  }

  void changeFilter(int index) {
    selectedFilter.value = index;
  }

  Future<void> openDocumentUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ToastMessageHelper.showToastMessage('Could not open the document', title: 'Error');
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
