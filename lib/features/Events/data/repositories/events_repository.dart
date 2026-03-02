import '../../../../core/helpers/logger_helper.dart';
import '../../../attendees/data/event_home_model.dart';
import '../../domain/services/events_service.dart';
import '../models/event_model.dart';
import '../models/my_event_model.dart';

class EventsRepository {
  final EventsService _eventsService;
  final LoggerHelper _logger = LoggerHelper('EventsRepository');

  EventsRepository({required EventsService eventsService})
      : _eventsService = eventsService;

  // ── GET /attendee/events ─────────────────────────────────────────────────

  Future<List<EventModel>> getAllUpcomingEvents() async {
    try {
      _logger.d('getAllUpcomingEvents');
      return await _eventsService.getAllUpcomingEvents();
    } catch (e) {
      _logger.e('getAllUpcomingEvents failed', error: e);
      throw Exception('Failed to fetch upcoming events: $e');
    }
  }

  // ── GET /superAdmin/events ────────────────────────────────────────────────

  Future<List<EventModel>> getExploreEvents() async {
    try {
      _logger.d('getExploreEvents');
      return await _eventsService.getExploreEvents();
    } catch (e) {
      _logger.e('getExploreEvents failed', error: e);
      throw Exception('Failed to fetch explore events: $e');
    }
  }

  // ── GET /attendee/my-event ────────────────────────────────────────────────

  Future<List<MyEventModel>> getMyEvents() async {
    try {
      _logger.d('getMyEvents');
      return await _eventsService.getMyEvents();
    } catch (e) {
      _logger.e('getMyEvents failed', error: e);
      throw Exception('Failed to fetch my events: $e');
    }
  }

  // ── GET /attendee/events/{id} ─────────────────────────────────────────────

  Future<EventModel?> getEventDetails(String eventId) async {
    try {
      _logger.d('getEventDetails: $eventId');
      return await _eventsService.getEventDetails(eventId);
    } catch (e) {
      _logger.e('getEventDetails failed', error: e);
      throw Exception('Failed to fetch event details: $e');
    }
  }

  // ── POST /attendee/events/{id}/initiate-registration ─────────────────────

  Future<Map<String, dynamic>?> initiateRegistration(String eventId) async {
    try {
      _logger.d('initiateRegistration: $eventId');
      return await _eventsService.initiateRegistration(eventId);
    } catch (e) {
      _logger.e('initiateRegistration failed', error: e);
      throw Exception('Failed to initiate registration: $e');
    }
  }

  // ── Filtered helpers ──────────────────────────────────────────────────────

  /// Active = now is between startDate and endDate (from my-events)
  Future<List<MyEventModel>> getActiveMyEvents() async {
    final all = await getMyEvents();
    final now = DateTime.now();
    return all
        .where((m) =>
    now.isAfter(m.event.startDate) && now.isBefore(m.event.endDate))
        .toList();
  }

  /// Upcoming = startDate is in the future (from my-events)
  Future<List<MyEventModel>> getUpcomingMyEvents() async {
    final all = await getMyEvents();
    final now = DateTime.now();
    return all.where((m) => m.event.startDate.isAfter(now)).toList();
  }


  Future<EventHomeModel?> getEventHome(String eventId) async {
    try {
      _logger.d('getEventHome: $eventId');
      return await _eventsService.getEventHome(eventId);
    } catch (e) {
      _logger.e('getEventHome failed', error: e);
      throw Exception('Failed to fetch event home data: $e');
    }
  }
}