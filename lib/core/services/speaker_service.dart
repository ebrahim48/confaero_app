import '../../core/constants/api_constants.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/services/api_service.dart';
import '../../core/services/connectivity_service.dart';

/// Service for speaker-specific features.
///
/// Handles:
/// - Speaker session invitations
/// - Accepting/rejecting speaker invitations
/// - Speaker session management
class SpeakerService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;

  SpeakerService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  /// Get speaker's session invitations for an event.
  ///
  /// Returns list of sessions where user is invited as speaker.
  Future<List<Map<String, dynamic>>> getSpeakerInvitations(
    String eventId,
  ) async {
    await _checkConnectivity();
    final response = await _apiService.get(
      '${ApiConstants.getMyInvitations}/$eventId',
    );

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if ((data['success'] as bool? ?? false) && data['data'] is List) {
        final invitations = (data['data'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        // Filter only speaker invitations
        return invitations
            .where((inv) =>
                inv['role']?.toString().toUpperCase() == 'SPEAKER' ||
                inv['invitationType']?.toString().toUpperCase() == 'SPEAKER')
            .toList();
      }
    }
    return [];
  }

  /// Accept a speaker invitation.
  Future<Map<String, dynamic>> acceptSpeakerInvitation(
    String invitationId,
    String eventId,
  ) async {
    await _checkConnectivity();
    final response = await _apiService.patch(
      '${ApiConstants.acceptInvitation}/$invitationId/accept/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// Reject a speaker invitation.
  Future<Map<String, dynamic>> rejectSpeakerInvitation(
    String invitationId,
    String eventId,
  ) async {
    await _checkConnectivity();
    final response = await _apiService.patch(
      '${ApiConstants.rejectInvitation}/$invitationId/reject/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// Get speaker's accepted sessions.
  Future<List<Map<String, dynamic>>> getMySpeakerSessions(
    String eventId,
  ) async {
    await _checkConnectivity();
    final response = await _apiService.get(
      '${ApiConstants.getMyInvitations}/$eventId',
    );

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if ((data['success'] as bool? ?? false) && data['data'] is List) {
        final invitations = (data['data'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        // Filter accepted speaker invitations
        return invitations
            .where((inv) =>
                (inv['role']?.toString().toUpperCase() == 'SPEAKER' ||
                    inv['invitationType']?.toString().toUpperCase() ==
                        'SPEAKER') &&
                inv['status']?.toString().toUpperCase() == 'ACCEPTED')
            .toList();
      }
    }
    return [];
  }

  /// Get session details for speaker.
  Future<Map<String, dynamic>> getSpeakerSessionDetails(
    String eventId,
    String sessionId,
  ) async {
    await _checkConnectivity();
    final response = await _apiService.get(
      '${ApiConstants.getSessionDetails}/$eventId/agenda/$sessionId',
    );
    return response.data as Map<String, dynamic>;
  }
}
