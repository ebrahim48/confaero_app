import 'package:confaero_app/core/constants/app_colors.dart';
import 'package:confaero_app/presentations/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../resources/data/models/resource_model.dart';
import '../custom_app_bar_widget.dart';
import '../../controllers/resources_controller.dart';

class PollScreen extends StatefulWidget {
  final PollModel? poll;

  const PollScreen({super.key, this.poll});

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  int? _selectedIndex;
  bool _isSubmitting = false;

  ResourcesController get _controller => Get.find<ResourcesController>();

  Future<void> _submit() async {
    if (_selectedIndex == null) {
      Get.snackbar('Warning', 'Please select an option');
      return;
    }
    setState(() => _isSubmitting = true);
    await _controller.submitPollVote(widget.poll!.id, _selectedIndex!);
    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final poll = widget.poll;

    if (poll == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const CustomAppBarWidget(title: 'Poll'),
            const Expanded(
              child: Center(child: Text('No poll available.')),
            ),
          ],
        ),
      );
    }

    final totalVotes = poll.options.fold<int>(0, (sum, o) => sum + o.votes);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBarWidget(title: 'Poll'),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: poll.isActive
                          ? const Color(0xffE8F5E9)
                          : const Color(0xffFFF3E0),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: CustomText(
                      text: poll.isActive ? 'Active Poll' : 'Closed Poll',
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: poll.isActive
                          ? const Color(0xff388E3C)
                          : const Color(0xffF57C00),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Question
                  CustomText(
                    textAlign: TextAlign.start,
                    text: poll.question,
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff252525),
                  ),
                  SizedBox(height: 6.h),

                  CustomText(
                    textAlign: TextAlign.start,
                    text: '$totalVotes response(s)',
                    fontsize: 12.sp,
                    color: const Color(0xff757575),
                  ),
                  SizedBox(height: 24.h),

                  Divider(color: AppColors.textColorD2D2D2),
                  SizedBox(height: 16.h),

                  // Options
                  ...List.generate(poll.options.length, (index) {
                    final option = poll.options[index];
                    final isSelected = _selectedIndex == index;
                    return GestureDetector(
                      onTap: poll.isActive
                          ? () => setState(() => _selectedIndex = index)
                          : null,
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xffE8F5F4)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xff32A69A)
                                : const Color(0xff9E9E9E),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              size: 22.sp,
                              color: isSelected
                                  ? const Color(0xff32A69A)
                                  : const Color(0xff9E9E9E),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: CustomText(
                                textAlign: TextAlign.start,
                                text: option.text,
                                fontsize: 14.sp,
                                color: const Color(0xff252525),
                              ),
                            ),
                            CustomText(
                              text: '${option.votes}',
                              fontsize: 12.sp,
                              color: const Color(0xff757575),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          if (poll.isActive)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(title: 'Submit Vote', onpress: _submit),
            ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
