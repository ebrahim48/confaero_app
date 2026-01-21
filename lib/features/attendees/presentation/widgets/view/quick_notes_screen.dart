import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../../presentations/widgets/custom_text.dart';

import '../../controllers/quick_note_controller.dart';
import '../note_card_widget.dart';
import 'note_details_screen.dart';

class QuickNotesScreen extends StatelessWidget {
  const QuickNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QuickNotesController controller = Get.put(QuickNotesController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            height: 98.h,
            color: const Color(0xffF5F5F5),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () =>  Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color: AppColors.textColor424242,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomText(
                      text: 'Quick Notes',
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor424242,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Notes List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff4DB6AC),
                  ),
                );
              }

              if (controller.notes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_alt_outlined,
                        size: 64.sp,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 16.h),
                      CustomText(
                        text: 'No notes yet',
                        fontsize: 16.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: 'Tap "Create Note" to add your first note',
                        fontsize: 14.sp,
                        color: Colors.grey[400]!,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: 10.h,
                  bottom: 90.h,
                ),
                itemCount: controller.notes.length,
                itemBuilder: (context, index) {
                  final note = controller.notes[index];
                  return NoteCard(
                    title: note['title'],
                    date: controller.getFormattedDate(note['date']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetailScreen(
                            noteId: note['id'],
                            title: note['title'],
                            content: note['content'],
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      _showDeleteDialog(context, controller, note['id']);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),


      bottomSheet: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: CustomButton(title: 'Create Note', onpress: () {
          context.pushNamed(AppRoutes.writeNoteScreen);
        },)
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context,
      QuickNotesController controller,
      String noteId,
      ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteNote(noteId);
              Get.back();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
