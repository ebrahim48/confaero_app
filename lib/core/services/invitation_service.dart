import '../../core/constants/api_constants.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/services/api_service.dart';
import '../../core/services/connectivity_service.dart';

class InvitationService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;

  InvitationService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  /// Get my invitations for an event
  /// If eventId is empty, fetches all invitations across all events
  Future<List<Map<String, dynamic>>> getMyInvitations([String eventId = '']) async {
    await _checkConnectivity();
    
    final endpoint = eventId.isEmpty
        ? ApiConstants.getMyInvitations
        : '${ApiConstants.getMyInvitations}/$eventId';
    
    final response = await _apiService.get(endpoint);

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if ((data['success'] as bool? ?? false) && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }
    }
    return [];
  }

  /// Accept an invitation
  Future<Map<String, dynamic>> acceptInvitation(
    String invitationId,
    String eventId,
  ) async {
    await _checkConnectivity();
    final response = await _apiService.patch(
      '${ApiConstants.acceptInvitation}/$invitationId/accept/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// Reject an invitation
  Future<Map<String, dynamic>> rejectInvitation(
    String invitationId,
    String eventId,
  ) async {
    await _checkConnectivity();
    final response = await _apiService.patch(
      '${ApiConstants.rejectInvitation}/$invitationId/reject/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }
}
