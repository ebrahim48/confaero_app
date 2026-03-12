import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../photos/data/models/photo_model.dart';
import '../../../photos/domain/services/photo_service.dart';

class PhotosController extends GetxController {
  final PhotoService _service = Get.find<PhotoService>();
  // Selected filter
  final RxInt selectedFilter = 0.obs;

  // Filter categories
  final List<String> filters = [
    'All',
    'Event',
    'Floor map',
    'Campaign',
    'Booth',
  ];

  // All photos
  final RxList<PhotoModel> allPhotos = <PhotoModel>[].obs;
  final RxBool isLoading = false.obs;

  // Read event ID from global session state
  String get currentEventId => SessionController.to.eventId;

  @override
  void onInit() {
    super.onInit();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    isLoading.value = true;
    try {
      final photos = await _service.getEventPhotos(currentEventId);
      allPhotos.assignAll(photos);
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to load photos');
    } finally {
      isLoading.value = false;
    }
  }

  // Change filter
  void changeFilter(int index) {
    selectedFilter.value = index;
  }

  // Open photo
  void openPhoto(PhotoModel photo) {
    print('Opening photo: ${photo.imageUrl}');
  }
}
