import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../utils/logger_helper.dart';
import 'api_service.dart';
import 'connectivity_service.dart';

/// Handles poster/abstract submission APIs for authors.
class PosterService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('PosterService');

  PosterService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  /// POST /poster/upload-file — upload banner image
  Future<Map<String, dynamic>> uploadPosterFile(String filePath) async {
    await _checkConnectivity();
    _logger.i('Uploading poster file');
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _apiService.post(
      ApiConstants.uploadPosterFile,
      data: formData,
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /poster/upload-files — upload attachments
  Future<Map<String, dynamic>> uploadPosterFiles(List<String> filePaths) async {
    await _checkConnectivity();
    _logger.i('Uploading ${filePaths.length} poster files');
    final files = await Future.wait(
      filePaths.map((p) => MultipartFile.fromFile(p)),
    );
    final formData = FormData.fromMap({'files': files});
    final response = await _apiService.post(
      ApiConstants.uploadPosterFiles,
      data: formData,
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /poster/create/:eventId
  Future<Map<String, dynamic>> createPoster(
    String eventId,
    Map<String, dynamic> data,
  ) async {
    await _checkConnectivity();
    _logger.i('Creating poster for event: $eventId');
    final response = await _apiService.post(
      '${ApiConstants.createPoster}/$eventId',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /poster/accepted
  Future<Map<String, dynamic>> getAcceptedPosters() async {
    await _checkConnectivity();
    _logger.i('Fetching accepted posters');
    final response = await _apiService.get(ApiConstants.getAcceptedPosters);
    return response.data as Map<String, dynamic>;
  }

  /// GET /poster/revised
  Future<Map<String, dynamic>> getRevisedPosters() async {
    await _checkConnectivity();
    _logger.i('Fetching revised posters');
    final response = await _apiService.get(ApiConstants.getRevisedPosters);
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /poster/author/attachments/:id
  Future<Map<String, dynamic>> updatePosterAttachment(
    String attachmentId,
    Map<String, dynamic> data,
  ) async {
    await _checkConnectivity();
    _logger.i('Updating poster attachment: $attachmentId');
    final response = await _apiService.patch(
      '${ApiConstants.updatePosterAttachment}/$attachmentId',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /poster/accepted/:id
  Future<Map<String, dynamic>> getSinglePoster(String posterId) async {
    await _checkConnectivity();
    _logger.i('Fetching poster: $posterId');
    final response = await _apiService.get(
      '${ApiConstants.getSinglePoster}/$posterId',
    );
    return response.data as Map<String, dynamic>;
  }
}
