import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';

class EventSpekarContactInfo extends StatelessWidget {
  final String email;
  final String phone;
  final String location;

  const EventSpekarContactInfo({
    super.key,
    required this.email,
    required this.phone,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact Info Header
        CustomText(
          text: 'Contact Info',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xff252525),
        ),
        SizedBox(height: 16.h),

        // Email
        _buildContactItem(Icons.mail_outline, email),
        SizedBox(height: 12.h),

        // Phone
        _buildContactItem(Icons.phone_outlined, phone),
        SizedBox(height: 12.h),

        // Location
        _buildContactItem(Icons.location_on_outlined, location),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Container(
      width: 345.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22.sp,
            color: const Color(0xff757575),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: CustomText(
              textAlign: TextAlign.start,
              text: text,
              fontsize: 14.sp,
              color: const Color(0xff252525),
            ),
          ),
        ],
      ),
    );
  }
}