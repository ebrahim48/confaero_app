import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../utils/logger_helper.dart';
import 'api_service.dart';
import 'connectivity_service.dart';

/// Handles reviewer-specific APIs for reviewing posters/abstracts.
class ReviewerService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('ReviewerService');

  ReviewerService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  /// GET /reviewer/dashboard/:eventId
  Future<Map<String, dynamic>> getDashboard(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching reviewer dashboard for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getReviewerDashboard}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /reviewer/authors/:eventId
  Future<Map<String, dynamic>> getAuthors(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching authors for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getReviewerAuthors}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /reviewer/authors/:id/submissions
  Future<Map<String, dynamic>> getAuthorSubmissions(String authorId) async {
    await _checkConnectivity();
    _logger.i('Fetching submissions for author: $authorId');
    final response = await _apiService.get(
      '${ApiConstants.getAuthorSubmissions}/$authorId/submissions',
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /reviewer/attachments/:id
  Future<Map<String, dynamic>> getAttachmentDetails(String attachmentId) async {
    await _checkConnectivity();
    _logger.i('Fetching attachment details: $attachmentId');
    final response = await _apiService.get(
      '${ApiConstants.getAttachmentDetails}/$attachmentId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /reviewer/attachments/:id/approve
  Future<Map<String, dynamic>> approveAttachment(String attachmentId) async {
    await _checkConnectivity();
    _logger.i('Approving attachment: $attachmentId');
    final response = await _apiService.patch(
      '${ApiConstants.approveAttachment}/$attachmentId/approve',
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /reviewer/attachments/:id/reject
  Future<Map<String, dynamic>> rejectAttachment(String attachmentId) async {
    await _checkConnectivity();
    _logger.i('Rejecting attachment: $attachmentId');
    final response = await _apiService.patch(
      '${ApiConstants.rejectAttachment}/$attachmentId/reject',
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /reviewer/attachments/:id/revise
  Future<Map<String, dynamic>> reviseAttachment(String attachmentId) async {
    await _checkConnectivity();
    _logger.i('Requesting revision for attachment: $attachmentId');
    final response = await _apiService.patch(
      '${ApiConstants.reviseAttachment}/$attachmentId/revise',
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /reviewer/attachments/:id/flag-admin
  Future<Map<String, dynamic>> flagToAdmin(String attachmentId) async {
    await _checkConnectivity();
    _logger.i('Flagging attachment to admin: $attachmentId');
    final response = await _apiService.patch(
      '${ApiConstants.flagAttachmentAdmin}/$attachmentId/flag-admin',
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /reviewer/attachments/:id/image-review
  Future<Map<String, dynamic>> reviewPosterImage(
    String attachmentId,
    Map<String, dynamic> data,
  ) async {
    await _checkConnectivity();
    _logger.i('Reviewing poster image: $attachmentId');
    final response = await _apiService.post(
      '${ApiConstants.reviewPosterImage}/$attachmentId/image-review',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }
}
