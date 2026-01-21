import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/quick_note_controller.dart';
import 'edit_notes_screen.dart';

class NoteDetailScreen extends StatelessWidget {
  final String noteId;
  final String title;
  final String content;

  const NoteDetailScreen({
    super.key,
    required this.noteId,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final QuickNotesController controller = Get.find<QuickNotesController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
        leading: IconButton(
          onPressed: () =>  Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textColor424242,
            size: 24.sp,
          ),
        ),
        title: CustomText(
          text: title,
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textColor424242,
          maxline: 1,
          textOverflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                    () => EditNoteScreen(
                  noteId: noteId,
                  initialContent: content,
                ),
              );
            },
            icon: const Icon(
              Icons.edit_outlined,
              color: Color(0xff9E9E9E),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Container(
          width: 345.w,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xffFEFEFE),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: const Color(0xff9E9E9E),
              width: 0.5,
            ),
          ),
          child: CustomText(
            text: content,
            fontsize: 14.sp,
            color: AppColors.textColor424242,

          ),
        ),
      ),
    );
  }
}