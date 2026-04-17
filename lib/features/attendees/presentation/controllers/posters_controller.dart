import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/poster_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class PostersController extends GetxController {
  final PosterService _posterService = Get.find<PosterService>();

  final searchController = TextEditingController();

  final RxList<PosterModel> posters = <PosterModel>[].obs;
  final RxList<PosterModel> filteredPosters = <PosterModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPosters();
    searchController.addListener(() => filterPosters(searchController.text));
  }

  Future<void> loadPosters() async {
    try {
      isLoading.value = true;
      final response = await _posterService.getAcceptedPosters();

      final success = response['success'] as bool? ?? false;
      if (success) {
        final outer = response['data'];
        List<dynamic> list = [];
        if (outer is Map<String, dynamic> && outer['data'] is List) {
          list = outer['data'] as List;
        } else if (outer is List) {
          list = outer;
        }
        posters.value =
            list.map((e) => PosterModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      filteredPosters.value = posters;
    } catch (e) {
      ToastMessageHelper.showToastMessage('Posters information coming soon. Check back later!', title: 'Info');
    } finally {
      isLoading.value = false;
    }
  }

  void filterPosters(String query) {
    if (query.isEmpty) {
      filteredPosters.value = posters;
    } else {
      filteredPosters.value = posters
          .where((p) =>
              p.title.toLowerCase().contains(query.toLowerCase()) ||
              p.authorName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void viewPoster(BuildContext context, String posterId) {
    context.pushNamed(AppRoutes.eventPostersDetailsScreen, extra: posterId);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

class PosterModel {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String title;
  final String description;
  final String dueDate;
  final String banner;

  PosterModel({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.banner,
  });

  factory PosterModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>? ?? {};
    return PosterModel(
      id: json['_id']?.toString() ?? '',
      authorName: author['name']?.toString() ?? '',
      authorAvatar: author['avatar']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['abstract']?.toString() ?? '',
      dueDate: json['dueDate']?.toString() ?? json['createdAt']?.toString() ?? '',
      banner: json['banner']?.toString() ?? '',
    );
  }
}
