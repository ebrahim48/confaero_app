import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/helpers/logger_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../attendees/data/event_home_model.dart';
import '../../data/models/event_model.dart';
import '../../data/models/my_event_model.dart';

class EventsService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final LoggerHelper _logger = LoggerHelper('EventsService');

  EventsService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  // ── helpers ──────────────────────────────────────────────────────────────

  Future<void> _checkConnectivity() async {
    final isConnected = await _connectivityService.checkConnectivity();
    if (!isConnected) throw Exception('No internet connection');
  }

  // ── GET /attendee/events ─────────────────────────────────────────────────

  Future<List<EventModel>> getAllUpcomingEvents() async {
    try {
      await _checkConnectivity();
      _logger.i('Fetching all upcoming events');

      final response = await _apiService.get(ApiConstants.getAllUpcomingEvents);
      _logger.d('Status: ${response.statusCode}');

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if ((data['success'] as bool? ?? false) && data['data'] is List) {
          final events =
              (data['data'] as List)
                  .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
                  .toList();
          _logger.i('Parsed ${events.length} upcoming events');
          return events;
        }
      }
      return [];
    } catch (e) {
      _logger.e('getAllUpcomingEvents failed', error: e);
      rethrow;
    }
  }

  // ── GET /superAdmin/events ────────────────────────────────────────────────

  Future<List<EventModel>> getExploreEvents() async {
    try {
      await _checkConnectivity();
      _logger.i('Fetching explore events');

      final response = await _apiService.get(ApiConstants.getExploreEvents);
      _logger.d('Status: ${response.statusCode}');

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if ((data['success'] as bool? ?? false) && data['data'] is List) {
          final events =
              (data['data'] as List)
                  .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
                  .toList();
          _logger.i('Parsed ${events.length} explore events');
          return events;
        }
      }
      return [];
    } catch (e) {
      _logger.e('getExploreEvents failed', error: e);
      rethrow;
    }
  }

  // ── GET /attendee/my-event ────────────────────────────────────────────────
  // Response: { "data": [ { "event": {...}, "status": "VERIFIED" } ] }

  Future<List<MyEventModel>> getMyEvents() async {
    try {
      await _checkConnectivity();
      _logger.i('Fetching my events');

      final response = await _apiService.get(ApiConstants.getMyAllEvents);
      _logger.d('Status: ${response.statusCode}');

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if ((data['success'] as bool? ?? false) && data['data'] is List) {
          final myEvents =
              (data['data'] as List)
                  .map((e) => MyEventModel.fromJson(e as Map<String, dynamic>))
                  .toList();
          _logger.i('Parsed ${myEvents.length} my events');
          return myEvents;
        }
      }
      return [];
    } catch (e) {
      _logger.e('getMyEvents failed', error: e);
      rethrow;
    }
  }

  // ── GET /attendee/events/{id} ─────────────────────────────────────────────

  Future<EventModel?> getEventDetails(String eventId) async {
    try {
      await _checkConnectivity();
      _logger.i('Fetching details for event: $eventId');

      final response = await _apiService.get(
        '${ApiConstants.getEventDetails}/$eventId',
      );
      _logger.d('Status: ${response.statusCode}');

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if ((data['success'] as bool? ?? false) && data['data'] != null) {
          final event = EventModel.fromJson(
            data['data'] as Map<String, dynamic>,
          );
          _logger.i('Event details: ${event.title}');
          return event;
        }
      }
      return null;
    } catch (e) {
      _logger.e('getEventDetails failed', error: e);
      rethrow;
    }
  }

  // ── POST /attendee/events/{id}/initiate-registration ─────────────────────

  /// POST /attendee/events/{id}/initiate-registration
  Future<Map<String, dynamic>?> initiateRegistration(String eventId, {double price = 0.0}) async {
    try {
      await _checkConnectivity();
      _logger.i('Initiating registration for event: $eventId');

      final response = await _apiService.post(
        '${ApiConstants.initiateRegistration}/$eventId/initiate-registration',
        data: {'price': price},
      );
      _logger.d('Status: ${response.statusCode}');

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if ((data['success'] as bool? ?? false) && data['data'] != null) {
          _logger.i(
            'Registration initiated — status: ${(data['data'] as Map)['status']}',
          );
          return data['data'] as Map<String, dynamic>;
        } else {
          // Server returned success:false with a message
          final msg = data['message'] as String? ?? 'Registration failed';
          _logger.w('Registration failed: $msg');
          throw Exception(msg);
        }
      }
      return null;
    } on DioException catch (e) {
      // Extract the real server error message from the response body
      String errorMsg = 'Registration failed';
      try {
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic>) {
          errorMsg = responseData['message'] as String? ?? errorMsg;
        } else if (responseData is String && responseData.isNotEmpty) {
          errorMsg = responseData;
        }
      } catch (_) {}
      _logger.e('initiateRegistration failed', error: e);
      throw Exception(errorMsg);
    } catch (e) {
      _logger.e('initiateRegistration failed', error: e);
      rethrow;
    }
  }

  Future<EventHomeModel?> getEventHome(String eventId) async {
    try {
      await _checkConnectivity();
      _logger.i('Fetching home data for event: $eventId');

      final response = await _apiService.get(
        '${ApiConstants.getEventHome}/$eventId/home',
      );
      _logger.d('Status: ${response.statusCode}');

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if ((data['success'] as bool? ?? false) && data['data'] != null) {
          final model = EventHomeModel.fromJson(
            data['data'] as Map<String, dynamic>,
          );
          _logger.i('Event home data fetched: ${model.title}');
          return model;
        }
      }
      return null;
    } catch (e) {
      _logger.e('getEventHome failed', error: e);
      rethrow;
    }
  }

  // ── GET /attendee/my-events/:id ─────────────────────────────────────────
  Future<MyEventModel?> getMyEventDetails(String eventId) async {
    try {
      await _checkConnectivity();
      _logger.i('Fetching my event details for: $eventId');
      final response = await _apiService.get(
        '${ApiConstants.getMyEventDetails}/$eventId',
      );
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if ((data['success'] as bool? ?? false) && data['data'] != null) {
          return MyEventModel.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      _logger.e('getMyEventDetails failed', error: e);
      rethrow;
    }
  }

  // ── GET /attendee/events/:id/sessions ───────────────────────────────────
  Future<List<Map<String, dynamic>>> getEventSessions(String eventId) async {
    try {
      await _checkConnectivity();
      _logger.i('Fetching sessions for event: $eventId');
      final response = await _apiService.get(
        '${ApiConstants.getEventSessions}/$eventId/sessions',
      );
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if ((data['success'] as bool? ?? false) && data['data'] is List) {
          return (data['data'] as List)
              .map((e) => e as Map<String, dynamic>)
              .toList();
        }
      }
      return [];
    } catch (e) {
      _logger.e('getEventSessions failed', error: e);
      rethrow;
    }
  }
}
