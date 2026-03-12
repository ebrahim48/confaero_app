import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/organizer_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';
import '../../../../presentations/widgets/custom_button.dart';

class SessionFormScreen extends StatelessWidget {
  const SessionFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrganizerController>();
    // If extra data passed, it's an edit
    final editSession =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isEditing = editSession != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBarWidget(title: isEditing ? 'Edit Session' : 'New Session'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Session Title *'),
                  _textField(controller.titleController, 'Enter session title'),
                  SizedBox(height: 16.h),
                  _label('Description'),
                  _textField(
                    controller.descriptionController,
                    'Enter description',
                    maxLines: 4,
                  ),
                  SizedBox(height: 16.h),
                  _label('Start Time'),
                  _textField(controller.startTimeController, 'e.g. 10:00 AM'),
                  SizedBox(height: 16.h),
                  _label('End Time'),
                  _textField(controller.endTimeController, 'e.g. 11:00 AM'),
                  SizedBox(height: 16.h),
                  _label('Location'),
                  _textField(
                    controller.locationController,
                    'e.g. Hall A, Room 201',
                  ),
                  SizedBox(height: 32.h),
                  Obx(
                    () => CustomButton(
                      title: isEditing ? 'Update Session' : 'Create Session',
                      onpress:
                          controller.isSaving.value
                              ? () {}
                              : () {
                                if (isEditing) {
                                  controller.updateSession(
                                    editSession['_id'] as String? ?? '',
                                  );
                                } else {
                                  controller.createSession();
                                }
                              },
                      color: const Color(0xff32A69A),
                      height: 52.h,
                      borderRadius: 12.r,
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

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF252525),
      ),
    ),
  );

  Widget _textField(
    TextEditingController ctrl,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade400),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xff32A69A)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }
}
