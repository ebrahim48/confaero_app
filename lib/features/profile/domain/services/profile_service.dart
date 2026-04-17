import 'dart:convert';
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


  /// Save full profile in one PATCH call.
  /// When avatar or resume file is included → multipart FormData.
  /// When no files → plain JSON.
  Future<ProfileModel?> updateFullProfile({
    String? about,
    List<AffiliationModel>? affiliations,
    List<EducationModel>? education,
    LocationModel? location,
    ContactModel? contact,
    List<SocialLink>? socialLinks,
    List<String>? personalWebsites,
    File? avatarFile,
    File? resumeFile,
  }) async {
    try {
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) throw Exception('No internet connection');

      final bool hasFile = avatarFile != null || resumeFile != null;
      dynamic data;

      if (hasFile) {
        // Multipart: backend expects files as 'image'/'resume' and ALL text
        // profile fields bundled as a single JSON string in 'data' field.
        final formMap = <String, dynamic>{};
        if (avatarFile != null) {
          formMap['image'] = await MultipartFile.fromFile(
            avatarFile.path,
            filename: avatarFile.path.split('/').last,
          );
        }
        if (resumeFile != null) {
          formMap['resume'] = await MultipartFile.fromFile(
            resumeFile.path,
            filename: resumeFile.path.split('/').last,
          );
        }
        // All text fields go inside one 'data' JSON string — matches Postman
        formMap['data'] = jsonEncode({
          'about':            about ?? '',
          'affiliations':     affiliations?.map((a) => a.toJson()).toList() ?? [],
          'education':        education?.map((e) => e.toJson()).toList() ?? [],
          'location':         location?.toJson() ?? {},
          'contact':          contact?.toJson() ?? {},
          'socialLinks':      socialLinks?.map((s) => s.toJson()).toList() ?? [],
          'personalWebsites': personalWebsites ?? [],
        });
        data = FormData.fromMap(formMap);
      } else {
        // Plain JSON — always include every field so backend JSON.parse() never
        // receives undefined (even if the value is an empty list/object).
        data = {
          'about':            about ?? '',
          'affiliations':     affiliations?.map((a) => a.toJson()).toList() ?? [],
          'education':        education?.map((e) => e.toJson()).toList() ?? [],
          'location':         location?.toJson() ?? {},
          'contact':          contact?.toJson() ?? {},
          'socialLinks':      socialLinks?.map((s) => s.toJson()).toList() ?? [],
          'personalWebsites': personalWebsites ?? [],
        };
      }

      final response = await _apiService.patch(ApiConstants.updateProfile, data: data);
      if (response.data != null && response.data['data'] != null) {
        return ProfileModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      _logger.e('Update Full Profile Error: $e');
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
