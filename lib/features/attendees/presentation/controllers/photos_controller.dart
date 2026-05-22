import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../photos/data/models/photo_model.dart';
import '../../../photos/domain/services/photo_service.dart';

class PhotosController extends GetxController {
  final PhotoService _service = Get.find<PhotoService>();
  final ImagePicker _picker = ImagePicker();

  // Selected filter
  final RxInt selectedFilter = 0.obs;

  // Filter categories
  final List<String> filters = [
    'All',
    'Event',
    'Public Wall',
  ];

  // All photos
  final RxList<PhotoModel> allPhotos = <PhotoModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;

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
      List<PhotoModel> photos;
      if (selectedFilter.value == 2) {
        photos = await _service.getPublicPhotos(currentEventId);
      } else {
        photos = await _service.getEventPhotos(currentEventId);
      }
      allPhotos.assignAll(photos);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  /// Upload a photo from gallery
  Future<void> uploadPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        isUploading.value = true;
        final file = File(image.path);
        await _service.uploadPhoto(currentEventId, file);
        await fetchPhotos();
      }
    } catch (e) {
    } finally {
      isUploading.value = false;
    }
  }

  /// Delete a photo
  Future<void> deletePhoto(String photoId) async {
    try {
      await _service.deletePhoto(photoId);
      allPhotos.removeWhere((p) => p.id == photoId);
    } catch (e) {
    }
  }

  // Change filter
  void changeFilter(int index) {
    selectedFilter.value = index;
    fetchPhotos();
  }

  // Open photo
  void openPhoto(PhotoModel photo) {
    // TODO: open full screen photo viewer
  }
}
