import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/logger_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/announcement_model.dart';

class AnnouncementService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('AnnouncementService');

  AnnouncementService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  Future<List<AnnouncementModel>> getAnnouncements(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching announcements for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getAnnouncements}/$eventId',
    );

    if (response.data is Map<String, dynamic>) {
      final resData = response.data as Map<String, dynamic>;
      if ((resData['success'] == true) && resData['data'] is List) {
        return (resData['data'] as List)
            .map((e) => AnnouncementModel.fromJson(e))
            .toList();
      }
    }
    return [];
  }

  Future<Map<String, dynamic>> createAnnouncement(
    String eventId, {
    required String title,
    required String content,
  }) async {
    await _checkConnectivity();
    _logger.i('Creating announcement for event: $eventId');
    final response = await _apiService.post(
      '${ApiConstants.createAnnouncement}/$eventId',
      data: {'title': title, 'content': content},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateAnnouncement(
    String id,
    String eventId, {
    required String title,
    required String content,
  }) async {
    await _checkConnectivity();
    _logger.i('Updating announcement $id for event: $eventId');
    final response = await _apiService.patch(
      '${ApiConstants.updateAnnouncement}/$id/$eventId',
      data: {'title': title, 'content': content},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteAnnouncement(String id, String eventId) async {
    await _checkConnectivity();
    _logger.i('Deleting announcement $id from event: $eventId');
    await _apiService.delete('${ApiConstants.deleteAnnouncement}/$id/$eventId');
  }
}
