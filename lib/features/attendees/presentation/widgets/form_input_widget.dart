import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class FormInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType? keyboardType;

  const FormInputWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: maxLines > 1
          ? BoxConstraints(minHeight: 147.h)
          : BoxConstraints(maxHeight: 44.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xff9E9E9E),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff9E9E9E),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
    );
  }
}

/// Professional, theme-consistent dropdown used across the profile forms.
/// White menu, dark readable text, teal focus border — regardless of the
/// global (possibly dark) theme defaults.
class AppDropdownField<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;

  const AppDropdownField({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: c, width: w),
        );

    final itemStyle = TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.textColor424242,
    );

    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      menuMaxHeight: 320.h,
      elevation: 3,
      icon: Icon(Icons.keyboard_arrow_down_rounded,
          color: AppColors.textColor7E7F7E, size: 22.sp),
      style: itemStyle,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xff9E9E9E)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: border(const Color(0xff9E9E9E)),
        enabledBorder: border(const Color(0xff9E9E9E)),
        focusedBorder: border(AppColors.primaryColor32A69A, 1.5),
      ),
      items: items
          .map((e) => DropdownMenuItem<T>(
                value: e,
                child: Text(labelBuilder(e), style: itemStyle),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}

/// A tappable field that opens a themed Material calendar. Displays the picked
/// date as "MMM yyyy" (month + year granularity, suited to job/education dates).
class AppDatePickerField extends StatelessWidget {
  final DateTime? value;
  final String hint;
  final ValueChanged<DateTime> onPicked;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const AppDatePickerField({
    super.key,
    required this.value,
    required this.hint,
    required this.onPicked,
    this.firstDate,
    this.lastDate,
  });

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: firstDate ?? DateTime(1950),
      lastDate: lastDate ?? DateTime(now.year + 5, 12, 31),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryColor32A69A,
            onPrimary: Colors.white,
            onSurface: AppColors.textColor424242,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor32A69A,
            ),
          ),
          dialogTheme: DialogThemeData(backgroundColor: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return GestureDetector(
      onTap: () => _pick(context),
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xff9E9E9E)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasValue ? DateFormat('MMM yyyy').format(value!) : hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: hasValue
                      ? AppColors.textColor424242
                      : const Color(0xff9E9E9E),
                ),
              ),
            ),
            Icon(Icons.calendar_today_outlined,
                size: 18.sp, color: AppColors.textColor7E7F7E),
          ],
        ),
      ),
    );
  }
}

/// Section header with a teal accent bar — used at the top of each form.
class AppFormSectionHeader extends StatelessWidget {
  final String title;
  const AppFormSectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: AppColors.primaryColor32A69A,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        CustomText(
          text: title,
          fontsize: 15.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textColor424242,
        ),
      ],
    );
  }
}