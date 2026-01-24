import 'package:get/get.dart';

class PhotosController extends GetxController {
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
  final RxList<String> allPhotos = <String>[
    'assets/images/photo1.jpg',
    'assets/images/photo2.jpg',
    'assets/images/photo1.jpg',
    'assets/images/photo2.jpg',
    'assets/images/photo1.jpg',
    'assets/images/photo2.jpg',
    'assets/images/photo1.jpg',
    'assets/images/photo2.jpg',
    'assets/images/photo1.jpg',
    'assets/images/photo2.jpg',
    'assets/images/photo1.jpg',
    'assets/images/photo2.jpg',
  ].obs;

  // Change filter
  void changeFilter(int index) {
    selectedFilter.value = index;
  }

  // Open photo
  void openPhoto(String imagePath) {
    print('Opening photo: $imagePath');
  }
}