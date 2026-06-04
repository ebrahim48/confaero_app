import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/helpers/logger_helper.dart';
import '../../../../core/services/job_service.dart';
import '../../../../presentations/widgets/custom_text.dart';

class PostAJobScreen extends StatefulWidget {
  const PostAJobScreen({super.key});

  @override
  State<PostAJobScreen> createState() => _PostAJobScreenState();
}

class _PostAJobScreenState extends State<PostAJobScreen> {
  late final PostAJobController ctrl;

  @override
  void initState() {
    super.initState();
    Get.delete<PostAJobController>(force: true);
    ctrl = Get.put(PostAJobController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // ── App bar ──────────────────────────────────────────
          Container(
            width: double.infinity,
            height: 98.h,
            color: const Color(0xffF5F5F5),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.arrow_back,
                        size: 24.sp, color: AppColors.textColor424242),
                  ),
                  SizedBox(width: 16.w),
                  CustomText(
                    text: 'Post a Job',
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor424242,
                  ),
                ],
              ),
            ),
          ),

          // ── Form ─────────────────────────────────────────────
          Expanded(
            child: Form(
              key: ctrl.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: ListView(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
                children: [
                  // ── Banner ──────────────────────────────────
                  CustomText(
                    text: 'Banner',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor252525,
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: ctrl.pickBanner,
                    child: Obx(() => Container(
                          width: double.infinity,
                          height: 130.h,
                          decoration: BoxDecoration(
                            color: const Color(0xffF6F6F6),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.borderColorD2D2D2,
                              width: 1,
                            ),
                          ),
                          child: ctrl.bannerFile.value != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.file(ctrl.bannerFile.value!,
                                      fit: BoxFit.cover,
                                      width: double.infinity),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt_outlined,
                                        size: 28.sp,
                                        color: AppColors.textColor7E7F7E),
                                    SizedBox(height: 6.h),
                                    CustomText(
                                      text: 'Upload',
                                      fontsize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textColor7E7F7E,
                                    ),
                                  ],
                                ),
                        )),
                  ),
                  SizedBox(height: 14.h),

                  // ── Company ─────────────────────────────────
                  _LimitedField(
                    label: 'Company',
                    required: true,
                    controller: ctrl.companyCtrl,
                    limit: 60,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),

                  // ── Job title ───────────────────────────────
                  _LimitedField(
                    label: 'Job title',
                    required: true,
                    controller: ctrl.titleCtrl,
                    limit: 60,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),

                  // ── Job description ─────────────────────────
                  _LimitedField(
                    label: 'Job description',
                    required: true,
                    controller: ctrl.descriptionCtrl,
                    limit: 200,
                    maxLines: 4,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),

                  // ── Requirements ────────────────────────────
                  _LimitedField(
                    label: 'Requirements',
                    required: true,
                    controller: ctrl.requirementsCtrl,
                    limit: 200,
                    maxLines: 4,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),

                  // ── Location ────────────────────────────────
                  _LimitedField(
                    label: 'Location',
                    required: true,
                    controller: ctrl.locationCtrl,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),

                  // ── Location URL ─────────────────────────────
                  _LimitedField(
                    label: 'Location URL',
                    controller: ctrl.locationUrlCtrl,
                    hint: 'https://maps.google.com/...',
                    keyboardType: TextInputType.url,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      if (!v.trim().startsWith('http://') &&
                          !v.trim().startsWith('https://')) {
                        return 'Must start with http:// or https://';
                      }
                      return null;
                    },
                  ),

                  // ── Information section ──────────────────────
                  SizedBox(height: 6.h),
                  CustomText(
                    text: 'Information',
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor252525,
                  ),
                  SizedBox(height: 12.h),

                  // Position
                  _LimitedField(
                    label: 'Position',
                    required: true,
                    controller: ctrl.positionCtrl,
                    hint: 'eg. Senior Designer',
                    limit: 60,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),

                  // Qualification
                  _LimitedField(
                    label: 'Qualification',
                    required: true,
                    controller: ctrl.qualificationCtrl,
                    hint: 'eg. Bachelor\'s Degree',
                    limit: 60,
                  ),

                  // Experience
                  _LimitedField(
                    label: 'Experience',
                    required: true,
                    controller: ctrl.experienceCtrl,
                    hint: 'eg. 3 Years',
                    limit: 60,
                  ),

                  // Job type — dropdown
                  _FieldHeader(label: 'Job type', required: true),
                  SizedBox(height: 6.h),
                  Obx(() => _DropdownField(
                        value: ctrl.jobType.value.isEmpty
                            ? null
                            : ctrl.jobType.value,
                        hint: 'eg. full time',
                        items: const [
                          'Full-time',
                          'Part-time',
                          'Contract',
                          'Internship',
                          'Remote',
                        ],
                        onChanged: (v) => ctrl.jobType.value = v ?? '',
                      )),
                  SizedBox(height: 10.h),

                  // Job Expire
                  _FieldHeader(label: 'Job Expire', required: true),
                  SizedBox(height: 6.h),
                  GestureDetector(
                    onTap: () => ctrl.pickDate(context),
                    child: Obx(() => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 13.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                                color: AppColors.borderColorD2D2D2, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: ctrl.expireDate.value != null
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(ctrl.expireDate.value!)
                                    : 'DD/MM/YYYY',
                                fontsize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: ctrl.expireDate.value != null
                                    ? AppColors.textColor252525
                                    : AppColors.textColor7E7F7E,
                              ),
                              Icon(Icons.calendar_today_outlined,
                                  size: 18.sp,
                                  color: AppColors.textColor7E7F7E),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(height: 10.h),

                  // Salary
                  _LimitedField(
                    label: 'Salary',
                    required: true,
                    controller: ctrl.salaryCtrl,
                    hint: 'eg. Negotiation',
                    limit: 60,
                  ),

                  // ── Facilities and Others ────────────────────
                  SizedBox(height: 4.h),
                  CustomText(
                    text: 'Facilities and Others:',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor252525,
                  ),
                  SizedBox(height: 10.h),

                  // Benefit chips
                  Obx(() => ctrl.benefits.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: ctrl.benefits
                                .map((b) => _BenefitChip(
                                      label: b,
                                      onRemove: () => ctrl.removeBenefit(b),
                                    ))
                                .toList(),
                          ),
                        )),

                  // Facilities Title + Add Option row
                  CustomText(
                    text: 'Facilities Title',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor7E7F7E,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Input — w:155, h:30
                      SizedBox(
                        width: 155.w,
                        height: 40.h,
                        child: TextFormField(
                          controller: ctrl.benefitInputCtrl,
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textColor252525),
                          decoration: InputDecoration(
                            hintText: 'Write your Facilities',
                            hintStyle: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textColor7E7F7E),
                            filled: true,
                            fillColor: Colors.white,
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                  color: AppColors.borderColorD2D2D2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                  color: AppColors.primaryColor32A69A),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                  color: AppColors.borderColorD2D2D2),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // Add Option button — w:160, h:40, #4F6F76
                      GestureDetector(
                        onTap: ctrl.addBenefit,
                        child: Container(
                          width: 160.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: const Color(0xff4F6F76),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add,
                                  size: 18.sp, color: Colors.white),
                              SizedBox(width: 6.w),
                              Text(
                                'Add Option',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // ── Google form link ────────────────────────
                  _LimitedField(
                    label: 'Google form link',
                    required: true,
                    controller: ctrl.applyLinkCtrl,
                    hint: 'http://',
                    keyboardType: TextInputType.url,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (!v.trim().startsWith('http://') &&
                          !v.trim().startsWith('https://')) {
                        return 'Must start with http:// or https://';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 8.h),

                  // ── Post button ─────────────────────────────
                  Obx(() => GestureDetector(
                        onTap: ctrl.isSubmitting.value
                            ? null
                            : () => ctrl.submitJob(context),
                        child: Container(
                          width: double.infinity,
                          height: 54.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor32A69A,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          alignment: Alignment.center,
                          child: ctrl.isSubmitting.value
                              ? SizedBox(
                                  width: 22.w,
                                  height: 22.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : CustomText(
                                  text: 'Post',
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────────────────────────────────────

class PostAJobController extends GetxController {
  final JobService _jobService = Get.find<JobService>();
  final _logger = LoggerHelper('PostAJobController');

  final formKey = GlobalKey<FormState>();

  final companyCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final requirementsCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final locationUrlCtrl = TextEditingController();
  final positionCtrl = TextEditingController();
  final qualificationCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final salaryCtrl = TextEditingController();
  final applyLinkCtrl = TextEditingController();
  final benefitInputCtrl = TextEditingController();

  final jobType = ''.obs;
  final expireDate = Rx<DateTime?>(null);
  final bannerFile = Rx<File?>(null);
  final benefits = <String>[].obs;
  final isSubmitting = false.obs;

  @override
  void onClose() {
    companyCtrl.dispose();
    titleCtrl.dispose();
    descriptionCtrl.dispose();
    requirementsCtrl.dispose();
    locationCtrl.dispose();
    locationUrlCtrl.dispose();
    positionCtrl.dispose();
    qualificationCtrl.dispose();
    experienceCtrl.dispose();
    salaryCtrl.dispose();
    applyLinkCtrl.dispose();
    benefitInputCtrl.dispose();
    super.onClose();
  }

  Future<void> pickBanner() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 80);
      if (picked != null) bannerFile.value = File(picked.path);
    } catch (e) {
      _logger.e('Banner pick failed: $e');
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor32A69A),
        ),
        child: child!,
      ),
    );
    if (picked != null) expireDate.value = picked;
  }

  void addBenefit() {
    final text = benefitInputCtrl.text.trim();
    if (text.isNotEmpty && !benefits.contains(text)) {
      benefits.add(text);
      benefitInputCtrl.clear();
    }
  }

  void removeBenefit(String b) => benefits.remove(b);

  Future<void> submitJob(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (expireDate.value == null) {
      ToastMessageHelper.showToastMessage(
          'Please select a job expire date',
          title: 'Error');
      return;
    }
    if (jobType.value.isEmpty) {
      ToastMessageHelper.showToastMessage(
          'Please select a job type',
          title: 'Error');
      return;
    }

    isSubmitting.value = true;
    try {
      final body = <String, dynamic>{
        'title': titleCtrl.text.trim(),
        'company': companyCtrl.text.trim(),
        'description': descriptionCtrl.text.trim(),
        'requirements': requirementsCtrl.text.trim(),
        'location': locationCtrl.text.trim(),
        if (locationUrlCtrl.text.trim().isNotEmpty)
          'locationUrl': locationUrlCtrl.text.trim(),
        'position': positionCtrl.text.trim(),
        'qualification': qualificationCtrl.text.trim(),
        'experience': experienceCtrl.text.trim(),
        'jobExpire': DateFormat('yyyy-MM-dd').format(expireDate.value!),
        'type': jobType.value,
        'salary': salaryCtrl.text.trim(),
        'benefits': benefits.toList(),
        'applyLink': applyLinkCtrl.text.trim(),
      };

      if (bannerFile.value != null) {
        body['bannerImage'] = bannerFile.value!.path;
      }

      final response = await _jobService.createJob(body);

      if (response['success'] == true) {
        ToastMessageHelper.showToastMessage(
          response['message']?.toString() ?? 'Job created successfully',
        );
        if (context.mounted) Navigator.of(context).pop(true);
      } else {
        final msg =
            response['message']?.toString() ?? 'Failed to create job';
        ToastMessageHelper.showToastMessage(msg, title: 'Error');
      }
    } catch (e) {
      _logger.e('submitJob error: $e');
      ToastMessageHelper.showToastMessage(
          'Something went wrong. Try again.',
          title: 'Error');
    } finally {
      isSubmitting.value = false;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Label + optional * above the field
class _FieldHeader extends StatelessWidget {
  final String label;
  final bool required;
  const _FieldHeader({required this.label, this.required = false});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor252525,
        ),
        children: required
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 13.sp),
                )
              ]
            : [],
      ),
    );
  }
}

/// "Limit: X char" right-aligned hint below a field
class _LimitHint extends StatelessWidget {
  final int limit;
  const _LimitHint({required this.limit});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Text(
          'Limit: $limit char',
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textColor7E7F7E,
          ),
        ),
      ),
    );
  }
}

/// Full field block: label → text field → "Limit: X char"
class _LimitedField extends StatelessWidget {
  final String label;
  final bool required;
  final TextEditingController controller;
  final String? hint;
  final int? limit;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _LimitedField({
    required this.label,
    this.required = false,
    required this.controller,
    this.hint,
    this.limit,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldHeader(label: label, required: required),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: limit,
          keyboardType: keyboardType,
          validator: validator,
          inputFormatters: limit != null
              ? [LengthLimitingTextInputFormatter(limit)]
              : null,
          style: TextStyle(
              fontSize: 13.sp, color: AppColors.textColor252525),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textColor7E7F7E,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white,
            counterText: '', // hide default counter
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: maxLines > 1 ? 12.h : 13.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide:
                  const BorderSide(color: AppColors.borderColorD2D2D2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide:
                  const BorderSide(color: AppColors.primaryColor32A69A),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.red, width: 0.8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.red, width: 0.8),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide:
                  const BorderSide(color: AppColors.borderColorD2D2D2),
            ),
          ),
        ),
        if (limit != null) _LimitHint(limit: limit!),
        SizedBox(height: 10.h),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final void Function(String?) onChanged;

  const _DropdownField({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderColorD2D2D2, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(
                fontSize: 13.sp, color: AppColors.textColor7E7F7E),
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textColor7E7F7E, size: 20.sp),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textColor252525),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _BenefitChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _BenefitChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xff4F6F76).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
            color: const Color(0xff4F6F76).withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xff4F6F76),
                fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 6.w),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close,
                size: 14.sp, color: const Color(0xff4F6F76)),
          ),
        ],
      ),
    );
  }
}
