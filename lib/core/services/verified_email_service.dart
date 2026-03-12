import 'dart:io';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';
import 'api_service.dart';
import 'connectivity_service.dart';

/// Handles organizer verified-email / invite management APIs.
class VerifiedEmailService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;

  VerifiedEmailService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  /// GET /verifyEmail/events/:eventId
  Future<List<Map<String, dynamic>>> getVerifiedEmails(String eventId) async {
    await _checkConnectivity();
    final response = await _apiService.get(
      '${ApiConstants.getVerifiedEmails}/$eventId',
    );
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }
    }
    return [];
  }

  /// POST /verifyEmail/events/:eventId/add-emails
  Future<Map<String, dynamic>> addEmails(
    String eventId,
    List<String> emails,
  ) async {
    await _checkConnectivity();
    final response = await _apiService.post(
      '${ApiConstants.addVerifiedEmails}/$eventId/add-emails',
      data: {'emails': emails},
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /verifyEmail/events/:eventId/upload-csv
  Future<Map<String, dynamic>> uploadCsv(String eventId, File csvFile) async {
    await _checkConnectivity();
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        csvFile.path,
        filename: 'emails.csv',
      ),
    });
    final response = await _apiService.post(
      '${ApiConstants.uploadEmailsCsv}/$eventId/upload-csv',
      data: formData,
    );
    return response.data as Map<String, dynamic>;
  }

  /// DELETE /verifyEmail/events/:eventId/:emailId
  Future<void> deleteEmail(String eventId, String emailId) async {
    await _checkConnectivity();
    await _apiService.delete(
      '${ApiConstants.deleteVerifiedEmail}/$eventId/$emailId',
    );
  }
}
