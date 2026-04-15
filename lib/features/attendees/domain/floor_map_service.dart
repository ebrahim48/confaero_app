import '../../../../core/constants/api_constants.dart';
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

  /// GET /organizer/events/{eventId}/floormaps
  Future<List<FloorMapModel>> getFloorMaps(String eventId) async {
    try {
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final endpoint = '/organizer/events/$eventId/floormaps';
      
      final response = await _apiService.get(endpoint);
      
      final success = response.data['success'] as bool? ?? false;
      if (success && response.data['data'] is List) {
        final data = response.data['data'] as List;
        final maps = data
            .map((e) => FloorMapModel.fromJson(e as Map<String, dynamic>))
            .toList();
        
        _logger.i('[FloorMapService] Loaded ${maps.length} floor maps');
        return maps;
      } else {
        _logger.w('[FloorMapService] No floor maps found');
        return [];
      }
    } catch (e) {
      _logger.e('[FloorMapService] Failed to load floor maps', error: e);
      throw Exception('Failed to load floor maps: $e');
    }
  }
}