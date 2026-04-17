import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../profile/data/models/profile_model.dart';
import '../form_input_widget.dart';

class AffiliationFormScreen extends StatefulWidget {
  const AffiliationFormScreen({super.key});

  @override
  State<AffiliationFormScreen> createState() => _AffiliationFormScreenState();
}

class _AffiliationFormScreenState extends State<AffiliationFormScreen> {
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  bool _isCurrent = false;

  // From
  int? _fromYear;
  int? _fromMonth;
  // To
  int? _toYear;
  int? _toMonth;

  static const _months = [
    '01 - January', '02 - February', '03 - March', '04 - April',
    '05 - May', '06 - June', '07 - July', '08 - August',
    '09 - September', '10 - October', '11 - November', '12 - December',
  ];

  List<int> get _years {
    final current = DateTime.now().year;
    return List.generate(current - 1949, (i) => current - i);
  }

  String _monthValue(int? month) => month == null ? '' : month.toString().padLeft(2, '0');

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_companyController.text.trim().isEmpty || _positionController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Company and position are required',
          backgroundColor: Colors.red[100]);
      return;
    }
    if (_fromYear == null || _fromMonth == null) {
      Get.snackbar('Error', 'Please select start year and month',
          backgroundColor: Colors.red[100]);
      return;
    }
    if (!_isCurrent && (_toYear == null || _toMonth == null)) {
      Get.snackbar('Error', 'Please select end year and month or check "I currently work here"',
          backgroundColor: Colors.red[100]);
      return;
    }

    final from = '$_fromYear-${_monthValue(_fromMonth)}';
    final to = _isCurrent ? '' : '$_toYear-${_monthValue(_toMonth)}';

    Navigator.pop(
      context,
      AffiliationModel(
        company: _companyController.text.trim(),
        position: _positionController.text.trim(),
        from: from,
        to: to,
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
          _buildHeader(context, 'Affiliation'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('Affiliation'),
                  SizedBox(height: 16.h),

                  FormInputWidget(controller: _companyController, hintText: 'Company *'),
                  SizedBox(height: 12.h),
                  FormInputWidget(controller: _positionController, hintText: 'Position Title *'),
                  SizedBox(height: 16.h),

                  CustomText(text: 'From *', fontsize: 13.sp, fontWeight: FontWeight.w500,
                      color: AppColors.textColor424242),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(child: _yearDropdown(_fromYear, 'Year', (v) => setState(() => _fromYear = v))),
                      SizedBox(width: 12.w),
                      Expanded(child: _monthDropdown(_fromMonth, 'Month', (v) => setState(() => _fromMonth = v))),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  if (!_isCurrent) ...[
                    CustomText(text: 'To *', fontsize: 13.sp, fontWeight: FontWeight.w500,
                        color: AppColors.textColor424242),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(child: _yearDropdown(_toYear, 'Year', (v) => setState(() => _toYear = v))),
                        SizedBox(width: 12.w),
                        Expanded(child: _monthDropdown(_toMonth, 'Month', (v) => setState(() => _toMonth = v))),
                      ],
                    ),
                    SizedBox(height: 16.h),
                  ],

                  Row(
                    children: [
                      SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: Checkbox(
                          value: _isCurrent,
                          onChanged: (v) => setState(() => _isCurrent = v ?? false),
                          activeColor: const Color(0xff32A69A),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      CustomText(text: 'I currently work here', fontsize: 13.sp,
                          fontWeight: FontWeight.w400, color: AppColors.textColor424242),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  CustomButton(
                    title: 'Add',
                    onpress: _save,
                    color: const Color(0xff32A69A),
                    height: 48.h,
                    borderRadius: 8.r,
                  ),
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
          borderSide: const BorderSide(color: Color(0xffD9D9D9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xffD9D9D9)),
        ),
      ),
      isExpanded: true,
      items: _years
          .map((y) => DropdownMenuItem(value: y, child: Text('$y', style: TextStyle(fontSize: 13.sp))))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _monthDropdown(int? value, String hint, ValueChanged<int?> onChanged) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textColor7E7F7E),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xffD9D9D9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xffD9D9D9)),
        ),
      ),
      isExpanded: true,
      items: List.generate(
        12,
        (i) => DropdownMenuItem(value: i + 1, child: Text(_months[i], style: TextStyle(fontSize: 12.sp))),
      ),
      onChanged: onChanged,
    );
  }
}

Widget _sectionHeader(String title) {
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
