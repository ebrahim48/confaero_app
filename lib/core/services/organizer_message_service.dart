import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../utils/logger_helper.dart';
import 'api_service.dart';
import 'connectivity_service.dart';

/// Handles organizer-specific messaging APIs.
class OrganizerMessageService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('OrganizerMessageService');

  OrganizerMessageService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  /// POST /messageOrganizer/send/:eventId
  Future<Map<String, dynamic>> sendMessage(
    String eventId,
    Map<String, dynamic> data,
  ) async {
    await _checkConnectivity();
    _logger.i('Sending organizer message for event: $eventId');
    final response = await _apiService.post(
      '${ApiConstants.sendOrganizerMessage}/$eventId',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /messageOrganizer/conversations/:eventId
  Future<Map<String, dynamic>> getConversations(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching organizer conversations for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getOrganizerConversations}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /messageOrganizer/messages/:convId/:eventId
  Future<Map<String, dynamic>> getMessages(
    String conversationId,
    String eventId,
  ) async {
    await _checkConnectivity();
    _logger.i('Fetching messages for conversation: $conversationId');
    final response = await _apiService.get(
      '${ApiConstants.getOrganizerMessages}/$conversationId/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /messageOrganizer/presence/:userId/:eventId
  Future<Map<String, dynamic>> getUserPresence(
    String userId,
    String eventId,
  ) async {
    await _checkConnectivity();
    _logger.i('Fetching presence for user: $userId');
    final response = await _apiService.get(
      '${ApiConstants.getOrganizerPresence}/$userId/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /messageOrganizer/seen/:msgId/:eventId
  Future<void> markAsSeen(String messageId, String eventId) async {
    await _checkConnectivity();
    _logger.i('Marking message seen: $messageId');
    await _apiService.patch(
      '${ApiConstants.markOrganizerSeen}/$messageId/$eventId',
    );
  }

  /// GET /messageOrganizer/notifications/:eventId
  Future<Map<String, dynamic>> getNotifications(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching organizer notifications for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getOrganizerNotifications}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }
}
