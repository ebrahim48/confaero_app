import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';

/// NOTE: Session CRUD endpoints have been removed from backend API.
/// This screen is kept as a placeholder.
class SessionFormScreen extends StatelessWidget {
  const SessionFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Session Management'),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Text(
                  'Session management is not available at this time.',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
