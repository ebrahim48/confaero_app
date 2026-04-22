import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../utils/logger_helper.dart';
import 'api_service.dart';
import 'connectivity_service.dart';

class VideoConferenceService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('VideoConferenceService');

  VideoConferenceService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  })  : _apiService = apiService,
        _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  /// GET /eventLive/live/:eventId
  /// Returns { data: { role, sessions: [...] } }
  Future<Map<String, dynamic>> getLiveSession(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching live session for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getLiveSession}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /eventLive/start/:eventId   body: { sessionIndex }
  Future<Map<String, dynamic>> startSession(
      String eventId, int sessionIndex) async {
    await _checkConnectivity();
    _logger.i('Starting session $sessionIndex for event: $eventId');
    final response = await _apiService.post(
      '${ApiConstants.startLiveSession}/$eventId',
      data: {'sessionIndex': sessionIndex},
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /eventLive/join/:eventId   body: { sessionIndex }
  Future<Map<String, dynamic>> joinSession(
      String eventId, int sessionIndex) async {
    await _checkConnectivity();
    _logger.i('Joining session $sessionIndex for event: $eventId');
    final response = await _apiService.post(
      '${ApiConstants.joinLiveSession}/$eventId',
      data: {'sessionIndex': sessionIndex},
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /eventLive/end/:eventId   body: { sessionIndex }
  Future<Map<String, dynamic>> endSession(
      String eventId, int sessionIndex) async {
    await _checkConnectivity();
    _logger.i('Ending session $sessionIndex for event: $eventId');
    final response = await _apiService.post(
      '${ApiConstants.endLiveSession}/$eventId',
      data: {'sessionIndex': sessionIndex},
    );
    return response.data as Map<String, dynamic>;
  }
}
