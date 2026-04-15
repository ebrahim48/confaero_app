import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/profile_model.dart';

class ProfileService {
  final ConnectivityService _connectivityService;
  final ApiService _apiService;
  final Logger _logger = Logger();

  ProfileService({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  }) : _connectivityService = connectivityService,
       _apiService = apiService;

  /// Get Current User Full Profile
  Future<ProfileModel?> getMyProfile() async {
    try {
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final response = await _apiService.get(ApiConstants.getMyProfile);

      if (response.data != null && response.data['data'] != null) {
        return ProfileModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      _logger.e('Get My Profile Error: $e');
      rethrow;
    }
  }

  /// Update User Profile.
  ///
  /// Sends JSON when only text fields are changed, and multipart FormData
  /// when a file (avatar / resume) is included. This avoids the backend
  /// receiving "undefined" for missing multipart fields.
  Future<ProfileModel?> updateProfile({
    String? firstName,
    String? lastName,
    String? title,
    String? bio,
    String? company,
    File? avatarFile,
    File? resumeFile,
  }) async {
    try {
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final bool hasFile = avatarFile != null || resumeFile != null;

      // Collect only non-null, non-empty text fields
      final Map<String, dynamic> fields = {};
      if (firstName != null && firstName.isNotEmpty) {
        fields['firstName'] = firstName;
      }
      if (lastName != null && lastName.isNotEmpty) {
        fields['lastName'] = lastName;
      }
      if (title != null && title.isNotEmpty) fields['title'] = title;
      if (bio != null && bio.isNotEmpty) fields['bio'] = bio;
      if (company != null && company.isNotEmpty) fields['company'] = company;

      dynamic data;

      if (hasFile) {
        // Use multipart FormData when uploading files
        final Map<String, dynamic> formMap = Map.from(fields);
        if (avatarFile != null) {
          formMap['avatar'] = await MultipartFile.fromFile(avatarFile.path);
        }
        if (resumeFile != null) {
          formMap['resume'] = await MultipartFile.fromFile(resumeFile.path);
        }
        data = FormData.fromMap(formMap);
      } else {
        // Use plain JSON when only updating text fields
        data = fields;
      }

      final response = await _apiService.patch(
        ApiConstants.updateProfile,
        data: data,
      );

      if (response.data != null && response.data['data'] != null) {
        return ProfileModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      _logger.e('Update Profile Error: $e');
      rethrow;
    }
  }

  /// Delete Resume from Profile
  Future<Map<String, dynamic>> deleteResume() async {
    try {
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final response = await _apiService.delete(ApiConstants.deleteResume);
      return response.data as Map<String, dynamic>? ?? {};
    } catch (e) {
      _logger.e('Delete Resume Error: $e');
      rethrow;
    }
  }
}
