import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/constants/app_colors.dart';

class CustomPinCodeTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;

  const CustomPinCodeTextField({
    super.key,
    this.textEditingController,
    this.onCompleted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      backgroundColor: Colors.transparent,
      cursorColor: const Color(0xff222222),
      controller: textEditingController,
      textStyle: TextStyle(
        color: const Color(0xff222222),
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
      autoFocus: false,
      appContext: context,
      length: 6,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8.r),
        fieldHeight: 55.h,
        fieldWidth: 43.w,
        borderWidth: 1,
        // Active state (currently typing)
        activeColor: const Color(0xffD6BDD4),
        activeFillColor: const Color(0xffFAFAFA),
        // Selected state (cursor is here)
        selectedColor: const Color(0xffD6BDD4),
        selectedFillColor: const Color(0xffFAFAFA),
        // Inactive state (not filled yet)
        inactiveColor: const Color(0xffD6BDD4),
        inactiveFillColor: const Color(0xffFAFAFA),
        // Error state
        errorBorderColor: const Color(0xffFF1D1D),
      ),
      enableActiveFill: true,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      onCompleted: (value) {
        if (textEditingController != null) {
          textEditingController!.text = value;
        }
        if (onCompleted != null) {
          onCompleted!(value);
        }
      },
    );
  }
}