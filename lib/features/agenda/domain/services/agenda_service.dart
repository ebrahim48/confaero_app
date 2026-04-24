import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/logger_helper.dart'; // Corrected path
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/session_model.dart';

class AgendaService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('AgendaService');

  AgendaService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  Future<List<SessionModel>> getEventAgenda(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching agenda for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getEventAgenda}/$eventId/agenda',
    );

    if (response.data is Map<String, dynamic>) {
      final resData = response.data as Map<String, dynamic>;
      if ((resData['success'] == true) && resData['data'] is List) {
        final list = resData['data'] as List;
        return list
            .asMap()
            .entries
            .map((e) => SessionModel.fromJson(e.value as Map<String, dynamic>, idx: e.key))
            .toList();
      }
    }
    return [];
  }

  Future<List<SessionModel>> getMyAgenda(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching my bookmarked agenda for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getMyAgenda}/$eventId/my-agenda',
    );

    if (response.data is Map<String, dynamic>) {
      final resData = response.data as Map<String, dynamic>;
      if ((resData['success'] == true) && resData['data'] is List) {
        final list = resData['data'] as List;
        return list
            .asMap()
            .entries
            .map((e) => SessionModel.fromJson(e.value as Map<String, dynamic>, idx: e.key))
            .toList();
      }
    }
    return [];
  }

  Future<void> bookmarkSession(String eventId, String sessionId) async {
    await _checkConnectivity();
    _logger.i('Bookmarking session: $sessionId for event: $eventId');
    await _apiService.post(
      '${ApiConstants.bookmarkSession}/$eventId/my-agenda/$sessionId',
    );
  }

  Future<void> removeBookmarkSession(String eventId, String sessionId) async {
    await _checkConnectivity();
    _logger.i('Removing bookmark for session: $sessionId in event: $eventId');
    await _apiService.delete(
      '${ApiConstants.removeBookmarkSession}/$eventId/my-agenda/$sessionId',
    );
  }

  Future<void> toggleSessionLike(String eventId, String sessionId) async {
    await _checkConnectivity();
    _logger.i('Toggling like on session: $sessionId');
    await _apiService.patch(
      '${ApiConstants.toggleSessionLike}/$eventId/$sessionId/toggle-like',
    );
  }

  /// GET /organizer-sessions/events/:eventId/agenda/:sessionId
  Future<Map<String, dynamic>?> getSessionDetails(
    String eventId,
    String sessionId,
  ) async {
    await _checkConnectivity();
    _logger.i('Fetching session details: $sessionId for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getSessionDetails}/$eventId/agenda/$sessionId',
    );

    if (response.data is Map<String, dynamic>) {
      final resData = response.data as Map<String, dynamic>;
      if (resData['success'] == true && resData['data'] != null) {
        return resData['data'] as Map<String, dynamic>;
      }
    }
    return null;
  }

  /// GET /organizer-sessions/events/:eventId/speakers/:speakerId
  Future<Map<String, dynamic>?> getSpeakerDetails(
    String eventId,
    String speakerId,
  ) async {
    await _checkConnectivity();
    _logger.i('Fetching speaker details: $speakerId for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getSpeakerDetails}/$eventId/speakers/$speakerId',
    );

    if (response.data is Map<String, dynamic>) {
      final resData = response.data as Map<String, dynamic>;
      if (resData['success'] == true && resData['data'] != null) {
        return resData['data'] as Map<String, dynamic>;
      }
    }
    return null;
  }
}
