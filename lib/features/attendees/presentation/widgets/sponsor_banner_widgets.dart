import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';


class SponsorBanner extends StatelessWidget {
  final String sponsorName;
  final VoidCallback onTap;

  const SponsorBanner({
    super.key,
    required this.sponsorName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 370.w,
        height: 35.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: const BoxDecoration(
          color: Color(0xff2E978C),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Platinum Sponsor: $sponsorName',
              fontsize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColorFFFFFF,
            ),
            SvgPicture.asset(
              'assets/icons/chevronright.svg',
              width: 16.w,
              height: 16.h,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}