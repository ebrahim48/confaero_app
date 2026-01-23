import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';

class CustomDropdownWidget extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownWidget({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  void _showDropdownBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E1E1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),

              // Title - FIXED: Added Expanded to prevent overflow
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        textAlign: TextAlign.start,
                        text: label,
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor252525,
                        maxline: 2,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: AppColors.textColor252525,
                        size: 24.sp,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),

              Divider(
                color: const Color(0xFFE1E1E1),
                thickness: 1,
                height: 1,
              ),

              // Options List
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item == value;

                    return InkWell(
                      onTap: () {
                        onChanged(item);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 16.h,
                        ),
                        color: isSelected
                            ? const Color(0xFFF0F9FF)
                            : Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomText(
                                textAlign: TextAlign.start,
                                text: item,
                                fontsize: 14.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: item == 'Select'
                                    ? const Color(0xFF999999)
                                    : AppColors.textColor252525,
                                maxline: 3,
                              ),
                            ),
                            if (isSelected)
                              Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: Icon(
                                  Icons.check,
                                  color: const Color(0xFF32A69A),
                                  size: 20.sp,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

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
          textAlign: TextAlign.start,
          maxline: 2,
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => _showDropdownBottomSheet(context),
          child: Container(
            width: 345.w,
            height: 44.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: const Color(0xFFE1E1E1),
                width: 1,
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    textAlign: TextAlign.start,
                    text: value,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: value == 'Select'
                        ? const Color(0xFF999999)
                        : AppColors.textColor252525,
                    maxline: 1,
                  ),
                ),
                SizedBox(width: 8.w),
                SvgPicture.asset(
                  'assets/images/chevrondown.svg',
                  width: 20.w,
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}