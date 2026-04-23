import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/services/job_service.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/helpers/logger_helper.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../../../attendees/presentation/widgets/custom_app_bar_widget.dart';

/// Job Posting Form Screen for Exhibitors/Sponsors
///
/// Allows exhibitors_sponsors_booth and sponsors to create new job postings
class JobPostingFormScreen extends StatelessWidget {
  const JobPostingFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobPostingFormController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: const CustomAppBarWidget(title: 'Post a Job'),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: EdgeInsets.all(24.w),
          children: [
            // Banner Upload
            CustomText(
              text: 'Job Banner',
              fontsize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor252525,
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: controller.pickBanner,
              child: Container(
                height: 150.h,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.borderColorD2D2D2,
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Obx(() => controller.bannerPath.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.file(
                          controller.bannerPath.value!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 48.w,
                            color: AppColors.iconColorAEAEAE,
                          ),
                          SizedBox(height: 8.h),
                          CustomText(
                            text: 'Tap to upload banner',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor7E7F7E,
                          ),
                        ],
                      )),
              ),
            ),
            SizedBox(height: 24.h),

            // Company Name
            _buildTextField(
              controller: controller.companyController,
              label: 'Company Name *',
              hint: 'Enter company name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter company name';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Job Title
            _buildTextField(
              controller: controller.jobTitleController,
              label: 'Job Title *',
              hint: 'e.g., Senior Software Engineer',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter job title';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Job Description
            _buildTextField(
              controller: controller.descriptionController,
              label: 'Job Description *',
              hint: 'Describe the role and responsibilities',
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter job description';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Requirements
            _buildTextField(
              controller: controller.requirementsController,
              label: 'Requirements *',
              hint: 'List required qualifications and skills',
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter requirements';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Row: Position & Job Type
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Position *',
                    hint: 'Select position',
                    items: ['Junior', 'Mid-Level', 'Senior', 'Lead', 'Manager'],
                    value: controller.position.value,
                    onChanged: (value) => controller.position.value = value ?? '',
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Job Type *',
                    hint: 'Select type',
                    items: ['Full-time', 'Part-time', 'Contract', 'Internship'],
                    value: controller.jobType.value,
                    onChanged: (value) => controller.jobType.value = value ?? '',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Row: Experience & Salary
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: controller.experienceController,
                    label: 'Experience',
                    hint: 'e.g., 3+ years',
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildTextField(
                    controller: controller.salaryController,
                    label: 'Salary',
                    hint: 'e.g., \$50k-\$80k',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Location
            _buildTextField(
              controller: controller.locationController,
              label: 'Location *',
              hint: 'e.g., New York, USA or Remote',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter location';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Job Expire Date
            CustomText(
              text: 'Job Expire Date *',
              fontsize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor252525,
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: controller.selectExpireDate,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.borderColorD2D2D2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => CustomText(
                          text: controller.expireDate.value != null
                              ? DateFormat('MMM dd, yyyy').format(controller.expireDate.value!)
                              : 'Select date',
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: controller.expireDate.value != null
                              ? AppColors.textColor252525
                              : AppColors.textColor7E7F7E,
                        )),
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.primaryColor32A69A,
                      size: 20.w,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Submit Button
            Obx(() => GestureDetector(
                  onTap: controller.isSubmitting.value
                      ? null
                      : () => controller.submitJob(),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor32A69A,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: controller.isSubmitting.value
                        ? SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : CustomText(
                            text: 'Post Job',
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                  ),
                )),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontsize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor252525,
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textColor7E7F7E,
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.borderColorD2D2D2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.borderColorD2D2D2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: AppColors.primaryColor32A69A),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: maxLines == 1 ? 14.h : 12.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required List<String> items,
    required String value,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontsize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor252525,
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.borderColorD2D2D2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : null,
              hint: CustomText(
                text: hint,
                fontsize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor7E7F7E,
              ),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primaryColor32A69A),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: CustomText(
                    text: item,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor252525,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

/// Controller for Job Posting Form
class JobPostingFormController extends GetxController {
  final JobService _jobService = Get.find<JobService>();
  final _logger = LoggerHelper('JobPostingFormController');

  final formKey = GlobalKey<FormState>();

  // Text controllers
  final companyController = TextEditingController();
  final jobTitleController = TextEditingController();
  final descriptionController = TextEditingController();
  final requirementsController = TextEditingController();
  final experienceController = TextEditingController();
  final salaryController = TextEditingController();
  final locationController = TextEditingController();

  // Dropdown values
  final position = ''.obs;
  final jobType = ''.obs;
  final expireDate = Rx<DateTime?>(null);

  // Banner image
  final bannerPath = Rx<File?>(null);

  // Submitting state
  final isSubmitting = false.obs;

  @override
  void onClose() {
    companyController.dispose();
    jobTitleController.dispose();
    descriptionController.dispose();
    requirementsController.dispose();
    experienceController.dispose();
    salaryController.dispose();
    locationController.dispose();
    super.onClose();
  }

  /// Pick banner image
  Future<void> pickBanner() async {
    try {
      final picker = Get.find<ImagePicker>();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked != null) {
        bannerPath.value = File(picked.path);
      }
    } catch (_) {
      // Image picker might not be initialized
      ToastMessageHelper.showToastMessage(
        'Image picker not available',
        title: 'Info',
      );
    }
  }

  /// Select expire date
  Future<void> selectExpireDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      expireDate.value = picked;
    }
  }

  /// Submit job posting
  Future<void> submitJob() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (expireDate.value == null) {
      ToastMessageHelper.showToastMessage(
        'Please select expire date',
        title: 'Info',
      );
      return;
    }

    isSubmitting.value = true;

    try {
      final eventData = SessionController.to.eventId;
      
      final jobData = {
        'companyId': eventData, // Use event ID as company ID for now
        'title': jobTitleController.text.trim(),
        'description': descriptionController.text.trim(),
        'requirements': requirementsController.text.trim(),
        'position': position.value,
        'jobType': jobType.value,
        'experience': experienceController.text.trim(),
        'salary': salaryController.text.trim(),
        'location': locationController.text.trim(),
        'expireDate': expireDate.value!.toIso8601String(),
        'status': 'pending', // Jobs need approval
      };

      final response = await _jobService.createJob(jobData);

      if (response['success'] == true) {
        ToastMessageHelper.showToastMessage(
          'Job posted successfully! Pending approval.',
          title: 'Success',
        );
        Get.back();
      } else {
        final message = response['message'] as String? ?? 'Failed to post job';
        ToastMessageHelper.showToastMessage(message, title: 'Error');
      }
    } catch (e) {
      _logger.e('Failed to post job: $e');
      ToastMessageHelper.showToastMessage(
        'Failed to post job',
        title: 'Error',
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
