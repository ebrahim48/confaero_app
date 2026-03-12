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

  /// Update User Profile using FormData for multipart requests
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

      // Build formData
      final Map<String, dynamic> formMap = {};
      if (firstName != null) formMap['firstName'] = firstName;
      if (lastName != null) formMap['lastName'] = lastName;
      if (title != null) formMap['title'] = title;
      if (bio != null) formMap['bio'] = bio;
      if (company != null) formMap['company'] = company;

      if (avatarFile != null) {
        formMap['avatar'] = await MultipartFile.fromFile(avatarFile.path);
      }

      if (resumeFile != null) {
        formMap['resume'] = await MultipartFile.fromFile(resumeFile.path);
      }

      final formData = FormData.fromMap(formMap);

      final response = await _apiService.patch(
        ApiConstants.updateProfile,
        data: formData,
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
