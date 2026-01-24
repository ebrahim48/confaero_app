import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class PostersController extends GetxController {
  // Search controller
  final searchController = TextEditingController();

  // Poster list
  final RxList<PosterModel> posters = <PosterModel>[].obs;
  final RxList<PosterModel> filteredPosters = <PosterModel>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPosters();

    // Listen to search
    searchController.addListener(() {
      filterPosters(searchController.text);
    });
  }

  void loadPosters() {
    // Dummy data - Replace with API call
    posters.value = List.generate(
      10,
          (index) => PosterModel(
        id: index.toString(),
        authorName: 'Dr. L. Chen - University Lab',
        authorImage: 'assets/images/profile.png',
        title: 'Engineering of the FRB domain of the...',
        description: 'Lorem Ipsum is simply dummy text of the printing and...',
        uploadDate: '12 Feb, 2026',
        posterImage: 'assets/images/cardbanner.png',
      ),
    );
    filteredPosters.value = posters;
  }

  void filterPosters(String query) {
    if (query.isEmpty) {
      filteredPosters.value = posters;
    } else {
      filteredPosters.value = posters
          .where((poster) =>
      poster.title.toLowerCase().contains(query.toLowerCase()) ||
          poster.authorName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void downloadPoster(String posterId) {
    print('Downloading poster: $posterId');
    Get.snackbar('Download', 'Poster download started');
  }

  void viewPoster(BuildContext context) {
    context.pushNamed(AppRoutes.eventPostersDetailsScreen);

  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

// Poster Model
class PosterModel {
  final String id;
  final String authorName;
  final String authorImage;
  final String title;
  final String description;
  final String uploadDate;
  final String posterImage;

  PosterModel({
    required this.id,
    required this.authorName,
    required this.authorImage,
    required this.title,
    required this.description,
    required this.uploadDate,
    required this.posterImage,
  });
}