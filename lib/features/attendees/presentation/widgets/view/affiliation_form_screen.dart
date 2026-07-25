import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  DateTime? _fromDate;
  DateTime? _toDate;

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
    if (_fromDate == null) {
      Get.snackbar('Error', 'Please select a start date',
          backgroundColor: Colors.red[100]);
      return;
    }
    if (!_isCurrent && _toDate == null) {
      Get.snackbar('Error', 'Please select an end date or check "I currently work here"',
          backgroundColor: Colors.red[100]);
      return;
    }
    if (!_isCurrent && _toDate!.isBefore(_fromDate!)) {
      Get.snackbar('Error', 'End date cannot be before the start date',
          backgroundColor: Colors.red[100]);
      return;
    }

    final fmt = DateFormat('yyyy-MM');
    final from = fmt.format(_fromDate!);
    final to = _isCurrent ? '' : fmt.format(_toDate!);

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
                  const AppFormSectionHeader('Affiliation'),
                  SizedBox(height: 16.h),

                  FormInputWidget(controller: _companyController, hintText: 'Company *'),
                  SizedBox(height: 12.h),
                  FormInputWidget(controller: _positionController, hintText: 'Position Title *'),
                  SizedBox(height: 16.h),

                  CustomText(text: 'From *', fontsize: 13.sp, fontWeight: FontWeight.w500,
                      color: AppColors.textColor424242),
                  SizedBox(height: 8.h),
                  AppDatePickerField(
                    value: _fromDate,
                    hint: 'Select start date',
                    onPicked: (d) => setState(() => _fromDate = d),
                  ),
                  SizedBox(height: 16.h),

                  if (!_isCurrent) ...[
                    CustomText(text: 'To *', fontsize: 13.sp, fontWeight: FontWeight.w500,
                        color: AppColors.textColor424242),
                    SizedBox(height: 8.h),
                    AppDatePickerField(
                      value: _toDate,
                      hint: 'Select end date',
                      firstDate: _fromDate,
                      onPicked: (d) => setState(() => _toDate = d),
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
