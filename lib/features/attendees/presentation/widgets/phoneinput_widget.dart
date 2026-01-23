import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class PhoneInputWidget extends StatelessWidget {
  final String label;
  final String countryFlag;
  final String countryCode;
  final VoidCallback onCountryTap;
  final TextEditingController phoneController;

  const PhoneInputWidget({
    super.key,
    required this.label,
    required this.countryFlag,
    required this.countryCode,
    required this.onCountryTap,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          color: AppColors.textColor252525,
          fontsize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            // Country Code Selector with Flag
            GestureDetector(
              onTap: onCountryTap,
              child: Container(
                width: 100.w,
                height: 44.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xFFE1E1E1),
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          countryFlag,
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          countryCode.isEmpty ? '' : '+$countryCode',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: countryCode.isEmpty
                                ? const Color(0xFF999999)
                                : AppColors.textColor252525,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.textColor252525,
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 6.w),

            // Phone Number Field
            Expanded(
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xFFE1E1E1),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textColor252525,
                  ),
                  decoration: InputDecoration(
                    hintText: '194274575',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF999999),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}