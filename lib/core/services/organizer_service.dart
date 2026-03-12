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

  /// POST /organizer-sessions/events/:eventId/agenda
  Future<Map<String, dynamic>> createSession(
    String eventId,
    Map<String, dynamic> sessionData,
  ) async {
    await _checkConnectivity();
    _logger.i('Creating session for event: $eventId');
    final response = await _apiService.post(
      '${ApiConstants.createSession}/$eventId/agenda',
      data: sessionData,
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /organizer-sessions/events/:eventId/agenda/:sessionId
  Future<Map<String, dynamic>> updateSession(
    String eventId,
    String sessionId,
    Map<String, dynamic> data,
  ) async {
    await _checkConnectivity();
    _logger.i('Updating session $sessionId for event: $eventId');
    final response = await _apiService.patch(
      '${ApiConstants.updateSession}/$eventId/agenda/$sessionId',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// DELETE /organizer-sessions/events/:eventId/agenda/:sessionId
  Future<void> deleteSession(String eventId, String sessionId) async {
    await _checkConnectivity();
    _logger.i('Deleting session $sessionId from event: $eventId');
    await _apiService.delete(
      '${ApiConstants.deleteSession}/$eventId/agenda/$sessionId',
    );
  }

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

  // -------- Organizer Attendee Management --------

  /// GET /organizer/attendee/:eventId/:attendeeId
  Future<Map<String, dynamic>> getAttendeeDetail(
    String eventId,
    String attendeeId,
  ) async {
    await _checkConnectivity();
    _logger.i('Getting organizer attendee $attendeeId for event $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getOrganizerAttendeeDetail}/$eventId/$attendeeId',
    );
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    return {};
  }

  /// DELETE /organizer/attendee/:eventId/:attendeeId
  Future<void> removeAttendee(String eventId, String attendeeId) async {
    await _checkConnectivity();
    _logger.i('Removing attendee $attendeeId from event $eventId');
    await _apiService.delete(
      '${ApiConstants.removeOrganizerAttendee}/$eventId/$attendeeId',
    );
  }

  /// GET /organizer/all-register/:eventId
  Future<List<Map<String, dynamic>>> getAllRegistrations(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching all registrations for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getAllRegistrations}/$eventId',
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
