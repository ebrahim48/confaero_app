import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';

class FormLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const FormLabel({
    super.key,
    required this.text,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: isRequired ? '$text *' : text,
      fontsize: 14.sp,
      fontWeight: FontWeight.w500,
      color: const Color(0xff252525),
    );
  }
}