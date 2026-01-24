import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/event_poster_details_controller.dart';
import '../custom_app_bar_widget.dart';
import '../event_abstract_widget.dart';
import '../event_action_button_widget.dart';
import '../event_banner_widget.dart';
import '../event_info_chip_widget.dart';
import '../event_presenter_widget.dart';


class EventPosterDetailsScreen extends StatelessWidget {
  const EventPosterDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventPosterDetailsController());

    return Scaffold(
      body: Column(
        children: [
          CustomAppBarWidget(
            title: 'Engineering of the FRB domai...',
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Banner
                  Obx(() => EventBannerWidget(
                    imageUrl: controller.eventBanner.value,
                  )),
                  SizedBox(height: 20.h),

                  // Date & Category Chips
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: [
                      Obx(() => EventInfoChipWidget(
                        icon: Icons.access_time,
                        text: controller.eventDate.value,
                        isPrimary: true,
                      )),
                      Obx(() => EventInfoChipWidget(
                        icon: Icons.access_time,
                        text: controller.eventCategory.value,
                      )),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Action Buttons - Horizontal Scrollable
                  SizedBox(
                    height: 48.h,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ActionButtonWidget(
                            icon: Icons.picture_as_pdf,
                            text: 'View PDF',
                            onTap: () => controller.viewPDF(context),
                          ),
                          SizedBox(width: 12.w),
                          ActionButtonWidget(
                            icon: Icons.image,
                            text: 'Image',
                            onTap: () => controller.viewImage(context),
                          ),
                          SizedBox(width: 12.w),
                          ActionButtonWidget(
                            icon: Icons.play_circle_outline,
                            text: 'Watch video',
                            onTap: controller.watchVideo,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Abstract Section
                  Obx(() => AbstractCardWidget(
                    text: controller.abstractText.value,
                    isExpanded: controller.isAbstractExpanded.value,
                    onToggle: controller.toggleAbstract,
                  )),
                  SizedBox(height: 24.h),

                  // Presenters Section
                  Container(
                    width: 345.w,
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
                        Obx(() => Column(
                          children: controller.presenters
                              .map((presenter) => PresenterCardWidget(
                            presenter: presenter,
                            onTap: () => controller
                                .viewPresenterDetails(presenter.id),
                          ))
                              .toList(),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}