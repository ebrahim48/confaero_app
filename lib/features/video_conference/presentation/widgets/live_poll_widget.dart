import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/models/live_poll.dart';
import '../controllers/event_live_controller.dart';

/// Widget for displaying a live poll with real-time updates via Socket.IO.
///
/// Supports:
/// - Viewing poll question and options
/// - Voting on poll options (one vote per user)
/// - Real-time results with percentage bars
/// - Speaker-only poll creation
class LivePollWidget extends StatefulWidget {
  final LivePoll poll;
  final int sessionIndex;

  const LivePollWidget({
    super.key,
    required this.poll,
    required this.sessionIndex,
  });

  @override
  State<LivePollWidget> createState() => _LivePollWidgetState();
}

class _LivePollWidgetState extends State<LivePollWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventLiveController>();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFD7EAE8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D000000),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poll header
          Row(
            children: [
              Icon(Icons.poll, color: const Color(0xFF32A69A), size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  widget.poll.question,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              // Total votes badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF32A69A).withAlpha(25),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${widget.poll.totalVotes} votes',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF32A69A),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Poll options
          ...List.generate(widget.poll.options.length, (index) {
            final option = widget.poll.options[index];
            final percentage = widget.poll.getOptionPercentage(index);
            final hasVoted = widget.poll.hasVoted;
            final isSelected = widget.poll.selectedOptionIndex == index;

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: GestureDetector(
                onTap:
                    hasVoted
                        ? null
                        : () {
                            _animationController.forward(from: 0);
                            controller.voteOnPoll(
                              pollId: widget.poll.id,
                              optionIndex: index,
                            );
                          },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? const Color(0xFF32A69A).withAlpha(25)
                            : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color:
                          isSelected
                              ? const Color(0xFF32A69A)
                              : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background progress bar
                      if (hasVoted)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width:
                              MediaQuery.of(context).size.width *
                              0.7 *
                              (percentage / 100),
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF32A69A).withAlpha(51),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      // Option content
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option.text,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                  color:
                                      isSelected
                                          ? const Color(0xFF32A69A)
                                          : Colors.black87,
                                ),
                              ),
                            ),
                            if (hasVoted) ...[
                              SizedBox(width: 8.w),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected
                                          ? const Color(0xFF32A69A)
                                          : Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '(${option.count})',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                            if (isSelected) ...[
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.check_circle,
                                color: const Color(0xFF32A69A),
                                size: 18.sp,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Vote status message
          if (widget.poll.hasVoted) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 14.sp,
                  color: Colors.green,
                ),
                SizedBox(width: 6.w),
                Text(
                  'You voted for: ${widget.poll.options[widget.poll.selectedOptionIndex!].text}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Dialog for creating a poll (Speaker only).
class CreatePollDialog extends StatefulWidget {
  final int sessionIndex;

  const CreatePollDialog({super.key, required this.sessionIndex});

  @override
  State<CreatePollDialog> createState() => _CreatePollDialogState();
}

class _CreatePollDialogState extends State<CreatePollDialog> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    if (_optionControllers.length > 2) {
      setState(() {
        _optionControllers[index].dispose();
        _optionControllers.removeAt(index);
      });
    }
  }

  void _createPoll() {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<EventLiveController>();
    final options =
        _optionControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList();

    if (options.length < 2) {
      Get.snackbar(
        'Invalid Poll',
        'Poll must have at least 2 options',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    controller.createPoll(
      question: _questionController.text.trim(),
      options: options,
    );

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.add_chart, color: const Color(0xFF32A69A), size: 24.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Create Poll',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Question field
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: 'Poll Question',
                  hintText: 'e.g., What topic should we cover next?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.h),

              // Options section
              Text(
                'Options',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 8.h),

              // Option fields
              ...List.generate(_optionControllers.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _optionControllers[index],
                          decoration: InputDecoration(
                            hintText: 'Option ${index + 1}',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_optionControllers.length > 2) ...[
                        SizedBox(width: 8.w),
                        IconButton(
                          onPressed: () => _removeOption(index),
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                            size: 20.sp,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ],
                  ),
                );
              }),

              // Add option button
              TextButton.icon(
                onPressed: _addOption,
                icon: Icon(Icons.add, size: 18.sp, color: const Color(0xFF32A69A)),
                label: Text(
                  'Add Option',
                  style: TextStyle(color: const Color(0xFF32A69A)),
                ),
              ),

              SizedBox(height: 16.h),

              // Create button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createPoll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF32A69A),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Create Poll',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
