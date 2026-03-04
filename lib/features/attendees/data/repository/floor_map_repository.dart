

import '../../../../core/helpers/logger_helper.dart';
import '../../domain/floor_map_service.dart';
import '../floor_map_model.dart';

class FloorMapRepository {
  final FloorMapService _service;
  final _logger = LoggerHelper('FloorMapRepository');

  FloorMapRepository({required FloorMapService service}) : _service = service;

  Future<List<FloorMapModel>> getFloorMaps(String eventId) async {
    try {
      _logger.d('[FloorMapRepository] getFloorMaps: $eventId');
      return await _service.getFloorMaps(eventId);
    } catch (e) {
      _logger.e('[FloorMapRepository] getFloorMaps failed', error: e);
      throw Exception('Failed to fetch floor maps: $e');
    }
  }
}