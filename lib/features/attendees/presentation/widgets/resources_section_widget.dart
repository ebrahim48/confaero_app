import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResourcesSectionWidget extends StatelessWidget {
  final List<Map<String, String>> resources;

  const ResourcesSectionWidget({
    super.key,
    required this.resources,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resources',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF252525),
          ),
        ),
        SizedBox(height: 12.h),

        ...resources.map((resource) => _buildResourceItem(
          name: resource['name']!,
          size: resource['size']!,
          onDownload: () {},
        )),
      ],
    );
  }

  Widget _buildResourceItem({
    required String name,
    required String size,
    required VoidCallback onDownload,
  }) {
    return Container(
      width: 346.w,
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFD2D2D2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/pdficon.svg',
            width: 24.w,
            height: 24.h,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF252525),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  size,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7E7F7E),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/downloadicon.svg',
              width: 20.w,
              height: 20.h,
              color: const Color(0xFF252525),
            ),
            onPressed: onDownload,
          ),
        ],
      ),
    );
  }
}