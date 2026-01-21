import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/quick_note_controller.dart';

class WriteNoteScreen extends StatefulWidget {
  const WriteNoteScreen({super.key});

  @override
  State<WriteNoteScreen> createState() => _WriteNoteScreenState();
}

class _WriteNoteScreenState extends State<WriteNoteScreen> {
  final TextEditingController _noteController = TextEditingController();
  final QuickNotesController _controller = Get.find<QuickNotesController>();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'Write A Note',
          fontsize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor424242,
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
              color: Color(0xff9E9E9E),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            // Text Field
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xffFEFEFE),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xff9E9E9E),
                    width: 0.5,
                  ),
                ),
                child: TextField(
                  controller: _noteController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  autofocus: true,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textColor424242,
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write note',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xff9E9E9E),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),

            // Character count
            Align(
              alignment: Alignment.centerRight,
              child: CustomText(
                text: 'Write at least 200 characters.',
                fontsize: 12.sp,
                color: const Color(0xff9E9E9E),
              ),
            ),
            SizedBox(height: 16.h),

            // Save Button
            ElevatedButton(
              onPressed: () {
                final content = _noteController.text.trim();
                if (content.isNotEmpty) {
                  _controller.addNote(content);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4DB6AC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                minimumSize: Size(345.w, 56.h),
                elevation: 0,
              ),
              child: CustomText(
                text: 'Save Note',
                fontsize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}