import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../profile/data/models/profile_model.dart';
import '../form_input_widget.dart';

// ══════════════════════════════════════════════════════
// EDUCATION FORM  — returns EducationModel
// ══════════════════════════════════════════════════════
class EducationFormScreen extends StatefulWidget {
  const EducationFormScreen({super.key});

  @override
  State<EducationFormScreen> createState() => _EducationFormScreenState();
}

class _EducationFormScreenState extends State<EducationFormScreen> {
  final _schoolController = TextEditingController();
  final _degreeController = TextEditingController();
  final _majorController  = TextEditingController();
  int? _fromYear;
  int? _toYear;
  bool _isCurrent = false;

  List<int> get _years {
    final current = DateTime.now().year;
    return List.generate(current - 1949, (i) => current - i);
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _degreeController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  void _save() {
    if (_schoolController.text.trim().isEmpty) {
      Get.snackbar('Error', 'School name is required', backgroundColor: Colors.red[100]);
      return;
    }
    if (_fromYear == null) {
      Get.snackbar('Error', 'Please select start year', backgroundColor: Colors.red[100]);
      return;
    }
    if (!_isCurrent && _toYear == null) {
      Get.snackbar('Error', 'Please select end year or check "I currently study here"',
          backgroundColor: Colors.red[100]);
      return;
    }

    Navigator.pop(
      context,
      EducationModel(
        institute: _schoolController.text.trim(),
        degree: _degreeController.text.trim(),
        major: _majorController.text.trim(),
        from: '$_fromYear',
        to: _isCurrent ? '' : '$_toYear',
        isCurrent: _isCurrent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, 'Education'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Education'),
                  SizedBox(height: 16.h),
                  FormInputWidget(controller: _schoolController, hintText: 'School *'),
                  SizedBox(height: 12.h),
                  FormInputWidget(controller: _degreeController, hintText: 'Degree'),
                  SizedBox(height: 12.h),
                  FormInputWidget(controller: _majorController, hintText: 'Major / Field of Study'),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text: 'From *', fontsize: 13.sp,
                                fontWeight: FontWeight.w500, color: AppColors.textColor424242),
                            SizedBox(height: 8.h),
                            _yearDropdown(_fromYear, 'Year', (v) => setState(() => _fromYear = v)),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      if (!_isCurrent)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: 'To *', fontsize: 13.sp,
                                  fontWeight: FontWeight.w500, color: AppColors.textColor424242),
                              SizedBox(height: 8.h),
                              _yearDropdown(_toYear, 'Year', (v) => setState(() => _toYear = v)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _buildCheckbox('I currently study here', _isCurrent,
                      (v) => setState(() => _isCurrent = v ?? false)),
                  SizedBox(height: 32.h),
                  CustomButton(title: 'Add', onpress: _save,
                      color: const Color(0xff32A69A), height: 48.h, borderRadius: 8.r),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _yearDropdown(int? value, String hint, ValueChanged<int?> onChanged) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textColor7E7F7E),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xffD9D9D9))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xffD9D9D9))),
      ),
      isExpanded: true,
      items: _years
          .map((y) => DropdownMenuItem(value: y, child: Text('$y', style: TextStyle(fontSize: 13.sp))))
          .toList(),
      onChanged: onChanged,
    );
  }
}

// ══════════════════════════════════════════════════════
// LOCATION FORM  — returns LocationModel
// ══════════════════════════════════════════════════════
class LocationFormScreen extends StatefulWidget {
  const LocationFormScreen({super.key});

  @override
  State<LocationFormScreen> createState() => _LocationFormScreenState();
}

class _LocationFormScreenState extends State<LocationFormScreen> {
  final _addressController = TextEditingController();
  bool _isCurrent = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _save() {
    if (_addressController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter address', backgroundColor: Colors.red[100]);
      return;
    }
    Navigator.pop(
      context,
      LocationModel(address: _addressController.text.trim(), isCurrent: _isCurrent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, 'Location'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Location'),
                  SizedBox(height: 8.h),
                  CustomText(text: 'Full Address *', fontsize: 13.sp,
                      fontWeight: FontWeight.w500, color: AppColors.textColor424242),
                  SizedBox(height: 8.h),
                  FormInputWidget(controller: _addressController,
                      hintText: 'e.g. Dhaka, Bangladesh', maxLines: 3),
                  SizedBox(height: 16.h),
                  _buildCheckbox('I currently live here', _isCurrent,
                      (v) => setState(() => _isCurrent = v ?? false)),
                  SizedBox(height: 32.h),
                  CustomButton(title: 'Add', onpress: _save,
                      color: const Color(0xff32A69A), height: 48.h, borderRadius: 8.r),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// CONTACT FORM  — returns ContactModel
// ══════════════════════════════════════════════════════
class ContactFormScreen extends StatefulWidget {
  const ContactFormScreen({super.key});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _phoneController  = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController  = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    if (_phoneController.text.trim().isEmpty &&
        _mobileController.text.trim().isEmpty &&
        _emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter at least one contact', backgroundColor: Colors.red[100]);
      return;
    }
    Navigator.pop(
      context,
      ContactModel(
        phone: _phoneController.text.trim(),
        mobile: _mobileController.text.trim(),
        email: _emailController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, 'Contact'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Contact'),
                  SizedBox(height: 16.h),
                  FormInputWidget(controller: _phoneController,
                      hintText: 'Phone number', keyboardType: TextInputType.phone),
                  SizedBox(height: 12.h),
                  FormInputWidget(controller: _mobileController,
                      hintText: 'Mobile number', keyboardType: TextInputType.phone),
                  SizedBox(height: 12.h),
                  FormInputWidget(controller: _emailController,
                      hintText: 'Email', keyboardType: TextInputType.emailAddress),
                  SizedBox(height: 32.h),
                  CustomButton(title: 'Add', onpress: _save,
                      color: const Color(0xff32A69A), height: 48.h, borderRadius: 8.r),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// ABOUT FORM  — returns String (bio)
// ══════════════════════════════════════════════════════
class AboutFormScreen extends StatefulWidget {
  final String initialBio;
  const AboutFormScreen({super.key, this.initialBio = ''});

  @override
  State<AboutFormScreen> createState() => _AboutFormScreenState();
}

class _AboutFormScreenState extends State<AboutFormScreen> {
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.initialBio);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _save() {
    if (_bioController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter bio', backgroundColor: Colors.red[100]);
      return;
    }
    Navigator.pop(context, _bioController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, 'About'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('About'),
                  SizedBox(height: 8.h),
                  CustomText(text: 'Bio', fontsize: 13.sp,
                      fontWeight: FontWeight.w500, color: AppColors.textColor424242),
                  SizedBox(height: 8.h),
                  FormInputWidget(controller: _bioController,
                      hintText: 'Tell people about yourself...', maxLines: 6),
                  SizedBox(height: 32.h),
                  CustomButton(title: 'Save', onpress: _save,
                      color: const Color(0xff32A69A), height: 48.h, borderRadius: 8.r),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// SOCIAL LINK FORM  — returns SocialLink
// ══════════════════════════════════════════════════════
class SocialLinkFormScreen extends StatefulWidget {
  const SocialLinkFormScreen({super.key});

  @override
  State<SocialLinkFormScreen> createState() => _SocialLinkFormScreenState();
}

class _SocialLinkFormScreenState extends State<SocialLinkFormScreen> {
  String _platform = 'LinkedIn';
  final _urlController = TextEditingController();

  static const _platforms = [
    'LinkedIn', 'GitHub', 'Twitter', 'Facebook',
    'Instagram', 'YouTube', 'ResearchGate', 'Other',
  ];

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _save() {
    if (_urlController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter URL', backgroundColor: Colors.red[100]);
      return;
    }
    Navigator.pop(
      context,
      SocialLink(platform: _platform, url: _urlController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, 'Social account link'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Social account link'),
                  SizedBox(height: 16.h),
                  CustomText(text: 'Platform', fontsize: 13.sp,
                      fontWeight: FontWeight.w500, color: AppColors.textColor424242),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<String>(
                    value: _platform,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                    ),
                    items: _platforms
                        .map((p) => DropdownMenuItem(
                            value: p, child: Text(p, style: TextStyle(fontSize: 13.sp))))
                        .toList(),
                    onChanged: (v) => setState(() => _platform = v ?? 'LinkedIn'),
                  ),
                  SizedBox(height: 12.h),
                  CustomText(text: 'Profile URL', fontsize: 13.sp,
                      fontWeight: FontWeight.w500, color: AppColors.textColor424242),
                  SizedBox(height: 8.h),
                  FormInputWidget(controller: _urlController,
                      hintText: 'https://...', keyboardType: TextInputType.url),
                  SizedBox(height: 32.h),
                  CustomButton(title: 'Add', onpress: _save,
                      color: const Color(0xff32A69A), height: 48.h, borderRadius: 8.r),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// WEBPAGE FORM  — returns String (url)
// ══════════════════════════════════════════════════════
class WebpageFormScreen extends StatefulWidget {
  const WebpageFormScreen({super.key});

  @override
  State<WebpageFormScreen> createState() => _WebpageFormScreenState();
}

class _WebpageFormScreenState extends State<WebpageFormScreen> {
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _save() {
    if (_urlController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter webpage URL', backgroundColor: Colors.red[100]);
      return;
    }
    Navigator.pop(context, _urlController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, 'Personal webpages'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Personal webpages'),
                  SizedBox(height: 8.h),
                  CustomText(text: 'Webpage URL', fontsize: 13.sp,
                      fontWeight: FontWeight.w500, color: AppColors.textColor424242),
                  SizedBox(height: 8.h),
                  FormInputWidget(controller: _urlController,
                      hintText: 'https://...', keyboardType: TextInputType.url),
                  SizedBox(height: 32.h),
                  CustomButton(title: 'Add', onpress: _save,
                      color: const Color(0xff32A69A), height: 48.h, borderRadius: 8.r),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// SHARED HELPERS
// ══════════════════════════════════════════════════════
Widget _buildHeader(BuildContext context, String title) {
  return Container(
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
            child: Icon(Icons.arrow_back, size: 24.sp, color: AppColors.textColor424242),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: CustomText(
              text: title,
              fontsize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor424242,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSectionHeader(String title) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: const Color(0xffE1E1E1),
      borderRadius: BorderRadius.circular(4.r),
    ),
    child: CustomText(
      text: title,
      fontsize: 13.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textColor424242,
    ),
  );
}

Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
  return Row(
    children: [
      SizedBox(
        width: 20.w,
        height: 20.h,
        child: Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xff32A69A),
        ),
      ),
      SizedBox(width: 8.w),
      CustomText(
        text: label,
        fontsize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textColor424242,
      ),
    ],
  );
}
