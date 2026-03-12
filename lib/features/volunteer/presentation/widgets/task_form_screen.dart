import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/volunteer_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';
import '../../../../presentations/widgets/custom_button.dart';

class TaskFormScreen extends StatelessWidget {
  const TaskFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VolunteerController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Create Task'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Task Name *'),
                  _field(controller.taskNameCtrl, 'Enter task name'),
                  SizedBox(height: 16.h),
                  _label('Description'),
                  _field(
                    controller.taskDescCtrl,
                    'Enter description',
                    maxLines: 3,
                  ),
                  SizedBox(height: 16.h),
                  _label('Location'),
                  _field(controller.taskLocationCtrl, 'Enter location'),
                  SizedBox(height: 32.h),
                  Obx(
                    () => CustomButton(
                      title: 'Create Task',
                      onpress:
                          controller.isSaving.value
                              ? () {}
                              : () => controller.createTask(),
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

  Widget _label(String t) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      t,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
    ),
  );

  Widget _field(TextEditingController c, String h, {int maxLines = 1}) =>
      TextField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: h,
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
        ),
      );
}
