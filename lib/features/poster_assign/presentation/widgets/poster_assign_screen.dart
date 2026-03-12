import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/poster_assign_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';

class PosterAssignScreen extends StatelessWidget {
  const PosterAssignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PosterAssignController());
    final tabs = ['Unassigned', 'Assigned', 'Reported'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Poster Assignments'),

          // Tab bar
          Obx(
            () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: List.generate(
                  tabs.length,
                  (i) => Expanded(
                    child: GestureDetector(
                      onTap: () => controller.switchTab(i),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color:
                              controller.currentTab.value == i
                                  ? const Color(0xff32A69A)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            tabs[i],
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color:
                                  controller.currentTab.value == i
                                      ? Colors.white
                                      : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final list =
                  controller.currentTab.value == 0
                      ? controller.unassigned
                      : controller.currentTab.value == 1
                      ? controller.assigned
                      : controller.reported;
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    'No posters',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadAll,
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final poster = list[index];
                    return _PosterCard(poster: poster, controller: controller);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _PosterCard extends StatelessWidget {
  final Map<String, dynamic> poster;
  final PosterAssignController controller;

  const _PosterCard({required this.poster, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFD7EAE8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D000000),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            poster['title'] as String? ?? 'Untitled Poster',
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6.h),
          Text(
            poster['abstract'] as String? ?? '',
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF7E7F7E)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              if (poster['status'] == null || poster['status'] == 'unassigned')
                _actionButton('Assign', const Color(0xff32A69A), () {
                  controller.assignPoster({
                    'posterId': poster['_id'],
                    'reviewerId': '',
                  });
                }),
              if (poster['assignmentId'] != null)
                _actionButton('Send Reminder', Colors.orange, () {
                  controller.sendReminder(
                    poster['assignmentId'] as String? ?? '',
                  );
                }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12.sp),
        ),
      ),
    );
  }
}
