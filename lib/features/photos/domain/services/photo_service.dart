import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/logger_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/photo_model.dart';

class PhotoService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('PhotoService');

  PhotoService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  Future<List<PhotoModel>> getEventPhotos(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching admin event photos for: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getEventPhotos}/$eventId/photos',
    );
    return _mapResponseToPhotos(response.data);
  }

  Future<List<PhotoModel>> getPublicPhotos(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching public wall photos for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getPublicPhotos}/$eventId/photos',
    );
    return _mapResponseToPhotos(response.data);
  }

  List<PhotoModel> _mapResponseToPhotos(dynamic data) {
    if (data is Map<String, dynamic>) {
      if ((data['success'] == true) && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => PhotoModel.fromJson(e))
            .toList();
      }
    }
    return [];
  }

  Future<Map<String, dynamic>> uploadPhoto(String eventId, File f) async {
    await _checkConnectivity();
    _logger.i('Uploading new photo from user to event: $eventId');

    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(
        f.path,
        filename: f.path.split('/').last,
      ),
    });

    final response = await _apiService.post(
      '${ApiConstants.uploadPhoto}/$eventId/photos',
      data: formData,
    );

    return response.data as Map<String, dynamic>;
  }

  /// DELETE /photo/photos/:id — delete a photo
  Future<void> deletePhoto(String photoId) async {
    await _checkConnectivity();
    _logger.i('Deleting photo: $photoId');
    await _apiService.delete('${ApiConstants.deletePhoto}/$photoId');
  }
}
