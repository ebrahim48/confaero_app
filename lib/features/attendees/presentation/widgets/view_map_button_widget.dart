import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../presentations/widgets/custom_text.dart';

class ViewMapButton extends StatelessWidget {
  final VoidCallback onTap;

  const ViewMapButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: const Color(0xff32A69A),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/map.svg',
              width: 20.w,
              height: 20.h,
              colorFilter: const ColorFilter.mode(
                Color(0xff32A69A),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 12.w),
            CustomText(
              text: 'View Map',
              fontsize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff32A69A),
            ),
          ],
        ),
      ),
    );
  }
}