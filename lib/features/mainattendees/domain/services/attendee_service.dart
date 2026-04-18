import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/logger_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/attendee_model.dart';

class AttendeeService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final _logger = LoggerHelper('AttendeeService');

  AttendeeService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  /// Get all attendees for an event
  /// API: GET /eventAttendee/events/:eventId/attendees
  /// Response: { success, message, data: { total, bookmarked, attendees: [] } }
  Future<AttendeesResponse> getEventAttendees(
    String eventId, {
    bool bookmarkedOnly = false,
    String? filter, // e.g. 'ATTENDEE' or 'SPEAKER'
  }) async {
    await _checkConnectivity();
    _logger.i('Fetching attendees for event: $eventId filter=$filter');

    String endpoint = '${ApiConstants.getEventAttendees}/$eventId/attendees';
    final params = <String>[];
    if (bookmarkedOnly) params.add('bookmarked=true');
    if (filter != null && filter.isNotEmpty) params.add('filter=$filter');
    if (params.isNotEmpty) endpoint += '?${params.join('&')}';


    final response = await _apiService.get(endpoint);

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if ((data['success'] as bool? ?? false) && data['data'] is Map) {
        final dataMap = data['data'] as Map<String, dynamic>;
        final total = dataMap['total'] as int? ?? 0;
        final bookmarkedCount = dataMap['bookmarked'] as int? ?? 0;
        final attendeesList = dataMap['attendees'] as List? ?? [];
        
        final attendees = attendeesList
            .map((e) => AttendeeModel.fromJson(e as Map<String, dynamic>))
            .toList();
        
        return AttendeesResponse(
          total: total,
          bookmarkedCount: bookmarkedCount,
          attendees: attendees,
        );
      }
    }
    return AttendeesResponse(total: 0, bookmarkedCount: 0, attendees: []);
  }

  /// Get attendee details — accountId is the account id (not eventAttendee id)
  /// API: GET /eventAttendee/events/:eventId/attendees/:accountId
  Future<AttendeeModel?> getAttendeeDetails(
    String eventId,
    String accountId,
  ) async {
    await _checkConnectivity();
    _logger.i('Fetching attendee details for event: $eventId, account: $accountId');

    try {
      final response = await _apiService.get(
        '${ApiConstants.getAttendeeDetails}/$eventId/attendees/$accountId',
      );

      _logger.i('Attendee details response: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        _logger.i('Attendee details success: ${data['success']}, data type: ${data['data'].runtimeType}');
        
        if ((data['success'] as bool? ?? false) && data['data'] != null) {
          return AttendeeModel.fromJson(data['data'] as Map<String, dynamic>);
        } else if (data['success'] != true) {
          _logger.e('Attendee details API returned success=false. Response: $data');
        }
      } else {
        _logger.w('Attendee details response is not a Map. Type: ${response.data.runtimeType}');
      }
    } catch (e) {
      _logger.e('Error fetching attendee details: $e');
      rethrow;
    }
    return null;
  }

  /// Toggle bookmark for attendee
  Future<bool> bookmarkAttendee(
    String eventId,
    String attendeeId,
  ) async {
    await _checkConnectivity();
    
    if (attendeeId.isEmpty) {
      _logger.e('Bookmark attempt with empty attendee ID for event: $eventId');
      throw Exception('Invalid attendee ID');
    }
    
    _logger.i('Toggling bookmark for attendee: $attendeeId in event: $eventId');

    final response = await _apiService.patch(
      '${ApiConstants.bookmarkAttendee}/$eventId/attendees/$attendeeId/bookmark',
    );

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if ((data['success'] as bool? ?? false) && data['data'] != null) {
        final dataMap = data['data'] as Map<String, dynamic>;
        return dataMap['isBookmarked'] as bool? ?? false;
      }
    }
    return false;
  }
}

/// Response model for attendees list API
class AttendeesResponse {
  final int total;
  final int bookmarkedCount;
  final List<AttendeeModel> attendees;

  AttendeesResponse({
    required this.total,
    required this.bookmarkedCount,
    required this.attendees,
  });
}
