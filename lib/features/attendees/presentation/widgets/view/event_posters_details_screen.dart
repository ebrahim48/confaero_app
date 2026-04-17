import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/event_poster_details_controller.dart';
import '../custom_app_bar_widget.dart';
import '../event_abstract_widget.dart';
import '../event_action_button_widget.dart';
import '../event_banner_widget.dart';
import '../event_info_chip_widget.dart';
import '../event_presenter_widget.dart';

class EventPosterDetailsScreen extends StatelessWidget {
  final String posterId;

  const EventPosterDetailsScreen({super.key, required this.posterId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      EventPosterDetailsController(posterId: posterId),
      tag: posterId,
    );

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return _PosterDetailsShimmer();
        }

        return Column(
          children: [
            Obx(() => CustomAppBarWidget(
                  title: controller.eventTitle.value.isNotEmpty
                      ? controller.eventTitle.value
                      : 'Poster Details',
                )),

            Expanded(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner
                    Obx(() => EventBannerWidget(
                          imageUrl: controller.eventBanner.value,
                        )),
                    SizedBox(height: 20.h),

                    // Date & Status chips
                    Obx(() => Wrap(
                          spacing: 12.w,
                          runSpacing: 12.h,
                          children: [
                            if (controller.eventDate.value.isNotEmpty)
                              EventInfoChipWidget(
                                icon: Icons.access_time,
                                text: controller.eventDate.value,
                                isPrimary: true,
                              ),
                            if (controller.eventCategory.value.isNotEmpty)
                              EventInfoChipWidget(
                                icon: Icons.flag_outlined,
                                text: controller.eventCategory.value,
                              ),
                          ],
                        )),
                    SizedBox(height: 20.h),

                    // Action Buttons — only approved attachments + video
                    Obx(() {
                      final pdfAttachments = controller.approvedAttachments
                          .where((a) => a.type == 'pdf')
                          .toList();
                      final imageAttachments = controller.approvedAttachments
                          .where((a) => a.type == 'image')
                          .toList();
                      final hasVideo =
                          controller.videoLink.value.isNotEmpty;

                      final buttons = <Widget>[
                        ...pdfAttachments.map((a) => ActionButtonWidget(
                              icon: Icons.picture_as_pdf,
                              text: 'View PDF',
                              onTap: () => controller.openUrl(a.url),
                            )),
                        ...imageAttachments.map((a) => ActionButtonWidget(
                              icon: Icons.image,
                              text: 'Image',
                              onTap: () => controller.openUrl(a.url),
                            )),
                        if (hasVideo)
                          ActionButtonWidget(
                            icon: Icons.play_circle_outline,
                            text: 'Watch video',
                            onTap: () =>
                                controller.openUrl(controller.videoLink.value),
                          ),
                      ];

                      if (buttons.isEmpty) return const SizedBox.shrink();

                      return SizedBox(
                        height: 48.h,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: buttons
                                .expand((b) => [
                                      b,
                                      SizedBox(width: 12.w),
                                    ])
                                .toList()
                              ..removeLast(),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 24.h),

                    // Abstract
                    Obx(() => AbstractCardWidget(
                          text: controller.abstractText.value,
                          isExpanded: controller.isAbstractExpanded.value,
                          onToggle: controller.toggleAbstract,
                        )),
                    SizedBox(height: 24.h),

                    // Presenters
                    Obx(() {
                      if (controller.presenters.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFD7EAE8),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x26000000),
                              blurRadius: 6,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Presenters',
                              fontsize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF252525),
                            ),
                            SizedBox(height: 20.h),
                            Column(
                              children: controller.presenters
                                  .map((presenter) => PresenterCardWidget(
                                        presenter: presenter,
                                        onTap: () => controller
                                            .viewPresenterDetails(presenter.id),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _PosterDetailsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          // AppBar shimmer
          Container(height: 56.h, color: Colors.white),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner
                  Container(
                    width: double.infinity,
                    height: 200.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Chips
                  Row(
                    children: [
                      Container(
                        width: 100.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        width: 80.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Action buttons row
                  Row(
                    children: List.generate(
                      3,
                      (_) => Container(
                        width: 100.w,
                        height: 40.h,
                        margin: EdgeInsets.only(right: 12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Abstract card
                  Container(
                    width: double.infinity,
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Presenter card
                  Container(
                    width: double.infinity,
                    height: 140.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
