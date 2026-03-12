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

  Future<List<AttendeeModel>> getEventAttendees(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching attendees for event: $eventId');

    final response = await _apiService.get(
      '${ApiConstants.getEventAttendees}/$eventId/attendees',
    );

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if ((data['success'] as bool? ?? false) && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => AttendeeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  Future<AttendeeModel?> getAttendeeDetails(
    String eventId,
    String attendeeId,
  ) async {
    await _checkConnectivity();
    _logger.i(
      'Fetching attendee details for event: $eventId, attendee: $attendeeId',
    );

    final response = await _apiService.get(
      '${ApiConstants.getAttendeeDetails}/$eventId/attendees/$attendeeId',
    );

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if ((data['success'] as bool? ?? false) && data['data'] != null) {
        return AttendeeModel.fromJson(data['data'] as Map<String, dynamic>);
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> bookmarkAttendee(
    String eventId,
    String attendeeId,
  ) async {
    await _checkConnectivity();
    _logger.i('Bookmarking attendee: $attendeeId for event: $eventId');

    final response = await _apiService.patch(
      '${ApiConstants.bookmarkAttendee}/$eventId/attendees/$attendeeId/bookmark',
    );
    return response.data as Map<String, dynamic>;
  }
}
