import '../../core/constants/api_constants.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/services/api_service.dart';
import '../../core/services/connectivity_service.dart';

class QrService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;

  QrService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  /// Generate QR code for event check-in
  Future<Map<String, dynamic>> generateQR(String eventId) async {
    await _checkConnectivity();
    final response = await _apiService.get(
      '${ApiConstants.generateQR}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// Scan QR token — POST /qr/scan/:eventId with { qrToken }
  Future<Map<String, dynamic>> scanQR(String qrToken, String eventId) async {
    await _checkConnectivity();
    final response = await _apiService.post(
      '${ApiConstants.scanQR}/$eventId',
      data: {'qrToken': qrToken},
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /qr/exhibitor/:boothId/leads
  Future<List<Map<String, dynamic>>> getExhibitorLeads(String boothId) async {
    await _checkConnectivity();
    final response = await _apiService.get(
      '${ApiConstants.getExhibitorLeads}/$boothId/leads',
    );
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) {
        final inner = data['data'];
        if (inner is Map<String, dynamic> && inner['leads'] is List) {
          return (inner['leads'] as List)
              .map((e) => e as Map<String, dynamic>)
              .toList();
        } else if (inner is List) {
          return (inner as List)
              .map((e) => e as Map<String, dynamic>)
              .toList();
        }
      }
    }
    return [];
  }

  /// PATCH /qr/exhibitor/leads/:leadId/note
  Future<Map<String, dynamic>> addLeadNote(String leadId, String note) async {
    await _checkConnectivity();
    final response = await _apiService.patch(
      '${ApiConstants.addLeadNote}/$leadId/note',
      data: {'note': note},
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /qr/exhibitor/leads/:leadId/tags
  Future<Map<String, dynamic>> tagLead(String leadId, List<String> tags) async {
    await _checkConnectivity();
    final response = await _apiService.patch(
      '${ApiConstants.tagLead}/$leadId/tags',
      data: {'tags': tags},
    );
    return response.data as Map<String, dynamic>;
  }
}
