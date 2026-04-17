import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/logger_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/document_model.dart';

class DocumentService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('DocumentService');

  DocumentService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  Future<List<DocumentModel>> getAllDocuments(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching all public documents for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getAllDocuments}/$eventId/all',
    );
    return _mapResponseToDocuments(response.data);
  }

  Future<List<DocumentModel>> getMyDocuments(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching my uploaded documents for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getMyDocuments}/$eventId/my',
    );
    return _mapResponseToDocuments(response.data);
  }

  List<DocumentModel> _mapResponseToDocuments(dynamic data) {
    if (data is Map<String, dynamic>) {
      if ((data['success'] == true) && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => DocumentModel.fromJson(e))
            .toList();
      }
    }
    return [];
  }

  Future<Map<String, dynamic>> uploadDocument(
    String eventId,
    File f,
    String name,
  ) async {
    await _checkConnectivity();
    _logger.i('Uploading new document to event: $eventId');

    final formData = FormData.fromMap({
      'name': name,
      'document': await MultipartFile.fromFile(
        f.path,
        filename: f.path.split('/').last,
      ),
    });

    final response = await _apiService.post(
      '${ApiConstants.uploadDocument}/$eventId',
      data: formData,
    );

    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteMyDocument(String documentId) async {
    await _checkConnectivity();
    _logger.i('Deleting my document: $documentId');
    await _apiService.delete('${ApiConstants.deleteMyDocument}/$documentId');
  }

  // ======================== Organizer Document Management ========================

  /// GET /document/:eventId/all — get all public documents
  Future<List<DocumentModel>> getPublicDocuments(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching all public documents for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getAllPublicDocuments}/$eventId/all',
    );
    final body = response.data;
    if (body is Map<String, dynamic> &&
        body['success'] == true &&
        body['data'] is Map<String, dynamic>) {
      final inner = body['data']['data'];
      if (inner is List) {
        return inner
            .map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  /// GET /document/:eventId/details/:id — get document details
  Future<DocumentDetailsModel> getDocumentDetails(
    String eventId,
    String documentId,
  ) async {
    await _checkConnectivity();
    _logger.i('Fetching document details: $documentId');
    final response = await _apiService.get(
      '${ApiConstants.getDocumentDetails}/$eventId/details/$documentId',
    );
    final body = response.data;
    if (body is Map<String, dynamic> && body['success'] == true) {
      return DocumentDetailsModel.fromJson(
          body['data'] as Map<String, dynamic>);
    }
    throw Exception('Failed to parse document details');
  }



}
