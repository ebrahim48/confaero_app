import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../global/custom_assets/assets.gen.dart';
import '../../../../presentations/widgets/custom_text.dart';

class SpeakerActionButtons extends StatelessWidget {
  final VoidCallback onLinkedInTap;
  final VoidCallback onWebsiteTap;
  final VoidCallback onContractTap;

  const SpeakerActionButtons({
    super.key,
    required this.onLinkedInTap,
    required this.onWebsiteTap,
    required this.onContractTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 345.w,
      height: 44.h,
      child: Row(
        children: [
          // LinkedIn Button (Left Circle)
          _buildIconButton(
            icon: Assets.icons.link.svg(
              width: 22.w,
              height: 22.h,
              // Remove colorFilter to show original icon
            ),
            onTap: onLinkedInTap,
          ),
          SizedBox(width: 12.w),

          // Website Button (Right Circle)
          _buildIconButton(
            icon: Assets.icons.weblink.svg(
              width: 22.w,
              height: 22.h,
              // Remove colorFilter to show original icon
            ),
            onTap: onWebsiteTap,
          ),
          SizedBox(width: 12.w),

          // Contract Speaker Button (Teal Rounded)
          Expanded(
            child: ElevatedButton(
              onPressed: onContractTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff5BB8AE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Assets.icons.communicationmail.svg(
                    width: 18.w,
                    height: 18.h,
                    // Keep white for email icon
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: CustomText(
                      text: 'Contract Speaker',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      maxline: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.h,
        decoration: const BoxDecoration(
          color: Color(0xff252525),
          shape: BoxShape.circle,
        ),
        child: Center(child: icon),
      ),
    );
  }
}