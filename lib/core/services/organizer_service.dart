import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../utils/logger_helper.dart';
import 'api_service.dart';
import 'connectivity_service.dart';

/// Handles organizer-specific session/speaker management APIs.
class OrganizerService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('OrganizerService');

  OrganizerService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  // REMOVED: createSession, updateSession, deleteSession — endpoints no longer in backend API

  /// POST /organizer-sessions/events/:eventId/speakers
  Future<Map<String, dynamic>> addSpeaker(
    String eventId,
    Map<String, dynamic> speakerData,
  ) async {
    await _checkConnectivity();
    _logger.i('Adding speaker to event: $eventId');
    final response = await _apiService.post(
      '${ApiConstants.addSpeaker}/$eventId/speakers',
      data: speakerData,
    );
    return response.data as Map<String, dynamic>;
  }

  // REMOVED: getAttendeeDetail, removeAttendee, getAllRegistrations — endpoints no longer in backend API

  /// GET /organizer-sessions/event/:eventId/speakers/search?q=query
  Future<List<Map<String, dynamic>>> searchSpeakers(
    String eventId,
    String query,
  ) async {
    await _checkConnectivity();
    _logger.i('Searching speakers for event: $eventId, query: $query');
    final response = await _apiService.get(
      '/organizer-sessions/event/$eventId/speakers/search',
      queryParameters: {'q': query},
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

  /// POST /organizer/organizers/:organizerId/stripe/connect
  Future<Map<String, dynamic>> connectStripe(String organizerId) async {
    await _checkConnectivity();
    _logger.i('Initiating Stripe connect for organizer: $organizerId');
    final response = await _apiService.post(
      '/organizer/organizers/$organizerId/stripe/connect',
    );
    return response.data as Map<String, dynamic>;
  }
}
