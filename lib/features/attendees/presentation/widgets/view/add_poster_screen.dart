import 'package:confaero_app/presentations/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../presentations/widgets/custom_text_field.dart';
import '../../controllers/add_poster_controller.dart';
import '../add_attachment_tem_widget.dart';
import '../add_banner_button_widget.dart';
import '../add_button_widget.dart';
import '../add_tag_chip_widgets.dart';
import '../character_limit_text.dart';
import '../custom_app_bar_widget.dart';
import '../form_label_text.dart';
import '../multiline_text_field_widget.dart';

Widget _shimmerBox(double height) => Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

class AddPosterScreen extends StatelessWidget {
  const AddPosterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final AddPosterController controller = Get.put(AddPosterController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App Bar
          const CustomAppBarWidget(
            title: 'Add Poster',
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner
                  const FormLabel(text: 'Banner', isRequired: true),
                  SizedBox(height: 8.h),
                  Obx(() {
                    if (controller.isBannerUploading.value) {
                      return _shimmerBox(44.h);
                    }
                    if (controller.bannerUrl.value.isNotEmpty) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          controller.bannerUrl.value,
                          height: 120.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                    return AddBannerButton(onTap: () => controller.addBanner());
                  }),
                  SizedBox(height: 16.h),

                  // Poster Title
                  const FormLabel(text: 'Poster title', isRequired: true),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: controller.titleController,
                    hintText: '',
                  ),
                  const CharacterLimitText(limit: 25),
                  SizedBox(height: 16.h),

                  // Abstract
                  const FormLabel(text: 'Abstract', isRequired: true),
                  SizedBox(height: 8.h),
                  MultiLineTextField(
                    controller: controller.abstractController,
                    maxLength: 200,
                  ),
                  const CharacterLimitText(limit: 200),
                  SizedBox(height: 16.h),

                  // Add Tag
                  const FormLabel(text: 'Add Tag'),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: controller.tagController,
                          hintText: 'tag',
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 4.h),
                  Align(
                    alignment: Alignment.topRight,
                    child: AddButton(
                      onTap: () => controller.addTag(),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Display Tags
                  Obx(() {
                    if (controller.tags.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Wrap(
                      children: controller.tags.map((tag) {
                        return TagChip(
                          tag: tag,
                          onRemove: () => controller.removeTag(tag),
                        );
                      }).toList(),
                    );
                  }),
                  SizedBox(height: 16.h),

                  // Presenters
                  const FormLabel(text: 'Presenters'),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: controller.presentersController,
                    hintText: 'Enter presenters',
                  ),
                  SizedBox(height: 16.h),

                  // Video Link
                  const FormLabel(text: 'Video Link'),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: controller.videoLinkController,
                    hintText: 'http://',
                  ),
                  SizedBox(height: 16.h),

                  // Attachment
                  const FormLabel(text: 'Attachment'),
                  SizedBox(height: 8.h),

                  // Attachment List
                  Obx(() {
                    return Column(
                      children: controller.attachments.map((attachment) {
                        return AttachmentItem(
                          fileName: attachment['name'],
                          fileSize: attachment['size'],
                          fileIcon: attachment['icon'],
                          onDelete: () =>
                              controller.removeAttachment(attachment),
                        );
                      }).toList(),
                    );
                  }),

                  SizedBox(height: 8.h),

                  // Add Attachment
                  Obx(() => controller.isAttachmentUploading.value
                      ? _shimmerBox(44.h)
                      : AddBannerButton(
                          onTap: () => controller.addAttachment(),
                          text: 'Add Attachment',
                        )),
                  SizedBox(height: 24.h),

                Obx(() => CustomButton(
                      title: controller.isSubmitting.value
                          ? 'Submitting...'
                          : 'Submit',
                      onpress: controller.isSubmitting.value
                          ? () {}
                          : () => controller.submitForm(),
                    )),
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