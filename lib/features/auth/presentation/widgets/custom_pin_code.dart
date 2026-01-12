import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/constants/app_colors.dart';

class CustomPinCodeTextField extends StatelessWidget {
  final TextEditingController? textEditingController;

  const CustomPinCodeTextField({super.key, this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      backgroundColor: Colors.transparent,
      cursorColor: AppColors.textColor222222,
      controller: textEditingController,
      textStyle: TextStyle(color: AppColors.textColor222222),
      autoFocus: false,
      appContext: context,
      length: 6,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10),
        selectedColor: AppColors.borderColorEADFD7,
        activeFillColor: AppColors.borderColorEADFD7,
        selectedFillColor: AppColors.borderColorEADFD7,
        inactiveFillColor: AppColors.borderColorEADFD7,
        fieldHeight: 66.h,
        fieldWidth: 44.w,
        inactiveColor: AppColors.borderColorD6BDD4,
        activeColor: AppColors.borderColorEADFD7,
      ),
      obscureText: false,
      keyboardType: TextInputType.number,
      onChanged: (value) {},
      onCompleted: (value) {
        textEditingController?.text = value;
      },
    );
  }
}
