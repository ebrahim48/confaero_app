import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../presentations/widgets/custom_button.dart';
import 'controllers/volunteer_report_issue_controller.dart';

class ReportIssueScreen extends StatelessWidget {
  final String taskId;

  const ReportIssueScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ReportIssueController(taskId: taskId),
      tag: taskId,
      permanent: false,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back,
              color: AppColors.textColor252525, size: 22.sp),
        ),
        title: Text('Report Issue',
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor252525)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please describe the situation clearly so the HQ team can assist effectively.',
              style: TextStyle(
                  fontSize: 12.sp, color: AppColors.textColor7E7F7E),
            ),
            SizedBox(height: 20.h),

            _sectionLabel('Issue Category'),
            SizedBox(height: 10.h),
            Obx(() => Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: controller.categories
                      .map((cat) => _categoryChip(
                            cat,
                            controller.selectedCategory.value == cat,
                            () => controller.selectCategory(cat),
                          ))
                      .toList(),
                )),
            SizedBox(height: 20.h),

            _sectionLabel('Urgency Level'),
            SizedBox(height: 10.h),
            Obx(() => Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.borderColorD2D2D2),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedUrgency.value,
                      dropdownColor: Colors.white,
                      icon: Icon(Icons.keyboard_arrow_down,
                          color: AppColors.textColor424242),
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textColor424242),
                      items: controller.urgencyLevels
                          .map((u) => DropdownMenuItem(
                              value: u,
                              child: Text(u,
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.textColor424242))))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) controller.selectUrgency(val);
                      },
                    ),
                  ),
                )),
            SizedBox(height: 20.h),

            _sectionLabel('Description'),
            SizedBox(height: 10.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.borderColorD2D2D2),
              ),
              child: TextFormField(
                controller: controller.descriptionController,
                maxLines: 6,
                style: TextStyle(
                    fontSize: 13.sp, color: AppColors.textColor424242),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 12.h),
                  hintText: 'Describe the issue in detail...',
                  hintStyle: TextStyle(
                      fontSize: 13.sp, color: AppColors.textColor7E7F7E),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            _sectionLabel('Attachments'),
            SizedBox(height: 10.h),

            Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...controller.attachments.asMap().entries.map(
                            (entry) => Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: _attachmentThumbnail(
                                  entry.value, entry.key, controller),
                            ),
                          ),
                      _addPhotoButton(controller),
                    ],
                  ),
                )),

            SizedBox(height: 32.h),

            Obx(() => CustomButton(
                  title: 'Submit Report',
                  loading: controller.isLoading.value,
                  onpress: () => controller.submitReport(context),
                )),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(label,
        style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor252525));
  }

  Widget _categoryChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor32A69A : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
              color: selected
                  ? AppColors.primaryColor32A69A
                  : AppColors.borderColorD2D2D2),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : AppColors.textColor424242)),
      ),
    );
  }

  Widget _attachmentThumbnail(
      File file, int index, ReportIssueController controller) {
    return Stack(
      children: [
        Container(
          width: 70.w,
          height: 70.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            image: DecorationImage(
                image: FileImage(file), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: () => controller.removeAttachment(index),
            child: Container(
              width: 20.w,
              height: 20.h,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: Icon(Icons.close,
                  size: 14.sp, color: AppColors.textColor424242),
            ),
          ),
        ),
      ],
    );
  }

  Widget _addPhotoButton(ReportIssueController controller) {
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final picked = await picker.pickImage(source: ImageSource.gallery);
        if (picked != null) {
          controller.addAttachment(File(picked.path));
        }
      },
      child: Container(
        width: 70.w,
        height: 70.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.borderColorD2D2D2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined,
                size: 22.sp, color: AppColors.textColor424242),
            SizedBox(height: 4.h),
            Text('Add Photo',
                style: TextStyle(
                    fontSize: 10.sp, color: AppColors.textColor424242)),
          ],
        ),
      ),
    );
  }
}
