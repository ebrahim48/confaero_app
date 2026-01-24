import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Icon
                  Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.people_outline,
                          color: Colors.black,
                          size: 24.r,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event Participant',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Connect with everyone',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Search Bar
                  Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by participant',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[500],
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[500],
                          size: 20.r,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Messages List
            Expanded(
              child: ListView(
                children: [
                  _buildMessageItem(
                    name: 'Jane Cooper',
                    message: 'hello how are you',
                    time: '4:30 PM',
                    avatarUrl: 'https://i.pravatar.cc/150?img=1',
                    hasUnread: true,
                  ),
                  _buildMessageItem(
                    name: 'Wade Warren',
                    message: 'hello how are you',
                    time: '1:30 PM',
                    avatarUrl: 'https://i.pravatar.cc/150?img=2',
                    hasUnread: true,
                  ),
                  _buildMessageItem(
                    name: 'Wade Warren',
                    message: 'hello how are you',
                    time: '1:30 PM',
                    avatarUrl: 'https://i.pravatar.cc/150?img=3',
                    hasUnread: false,
                  ),
                  _buildMessageItem(
                    name: 'Wade Warren',
                    message: 'hello how are you',
                    time: '1:30 PM',
                    avatarUrl: 'https://i.pravatar.cc/150?img=4',
                    hasUnread: false,
                  ),
                  _buildMessageItem(
                    name: 'Wade Warren',
                    message: 'hello how are you',
                    time: '1:30 PM',
                    avatarUrl: 'https://i.pravatar.cc/150?img=5',
                    hasUnread: false,
                  ),
                  _buildMessageItem(
                    name: 'Wade Warren',
                    message: 'hello how are you',
                    time: '1:30 PM',
                    avatarUrl: 'https://i.pravatar.cc/150?img=6',
                    hasUnread: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem({
    required String name,
    required String message,
    required String time,
    required String avatarUrl,
    required bool hasUnread,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(avatarUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Name and Message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Time and Unread Badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (hasUnread) ...[
                SizedBox(height: 4.h),
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}