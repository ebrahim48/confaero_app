import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_text.dart';
import 'dashboard_container_widget.dart';


class AddBannerButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final IconData icon;

  const AddBannerButton({
    super.key,
    required this.onTap,
    this.text = 'Add Banner',
    this.icon = Icons.attach_file,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 345.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: DashedBorderContainer(
          borderRadius: 8.r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20.sp,
                color: const Color(0xff252525),
              ),
              SizedBox(width: 6.w),
              CustomText(
                text: text,
                fontsize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff252525),
              ),
            ],
          ),
        ),
      ),
    );
  }
}