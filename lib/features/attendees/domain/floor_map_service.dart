import '../../../core/constants/api_constants.dart';
import '../../../core/helpers/logger_helper.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/connectivity_service.dart';
import '../data/floor_map_model.dart';

class FloorMapService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final _logger = LoggerHelper('FloorMapService');

  FloorMapService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  })  : _apiService = apiService,
        _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    final connected = await _connectivityService.checkConnectivity();
    if (!connected) throw Exception('No internet connection');
  }

  /// GET /organizer/events/{eventId}/floormaps
  Future<List<FloorMapModel>> getFloorMaps(String eventId) async {
    try {
      await _checkConnectivity();
      _logger.i('[FloorMapService] Fetching floor maps for event: $eventId');

      final response = await _apiService.get(
        '${ApiConstants.getFloorMaps}/$eventId/floormaps',
      );
      _logger.d('[FloorMapService] Status: ${response.statusCode}');

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if ((data['success'] as bool? ?? false) && data['data'] != null) {
          final list = (data['data'] as List)
              .map((e) => FloorMapModel.fromJson(e as Map<String, dynamic>))
              .toList();
          _logger.i('[FloorMapService] Parsed ${list.length} floor maps');
          return list;
        }
      }
      return [];
    } catch (e) {
      _logger.e('[FloorMapService] getFloorMaps failed', error: e);
      rethrow;
    }
  }
}