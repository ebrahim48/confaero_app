import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../global/custom_assets/assets.gen.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../attendees/presentation/widgets/custom_app_bar_widget.dart';
import '../../controllers/agenda_details_controller.dart';
import '../action_button_widgets.dart';
import '../section_header_widgets.dart';
import '../spark_card_widgets.dart';

class AgendaDetailsScreen extends StatefulWidget {
  final String sessionIdx;

  const AgendaDetailsScreen({super.key, required this.sessionIdx});

  @override
  State<AgendaDetailsScreen> createState() => _AgendaDetailsScreenState();
}

class _AgendaDetailsScreenState extends State<AgendaDetailsScreen> {
  late final AgendaDetailsController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AgendaDetailsController>()) {
      Get.delete<AgendaDetailsController>(force: true);
    }
    controller = Get.put(AgendaDetailsController(widget.sessionIdx));
  }

  @override
  void dispose() {
    Get.delete<AgendaDetailsController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Obx(() => CustomAppBarWidget(title: controller.sessionTitle)),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return SizedBox(
                    height: 300.h,
                    child: const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xff5BB8AE)),
                    ),
                  );
                }

                final session = controller.sessionDetails;
                final sessionData =
                    (session['session'] as Map<String, dynamic>?) ?? {};
                final isOnline = sessionData['isOnline'] as bool? ?? false;
                final liveStatus =
                    sessionData['liveStatus']?.toString() ?? '';
                final liveProvider =
                    sessionData['liveProvider']?.toString() ?? '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Session Info Card ─────────────────────────────
                    Container(
                      width: 345.w,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border:
                            Border.all(color: const Color(0xffE0E0E0)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x26000000),
                            blurRadius: 6,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CustomText(
                            text: sessionData['title']?.toString() ??
                                'Untitled Session',
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff252525),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.icons.time.svg(),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: CustomText(
                                  text: _formatDateTime(
                                    sessionData['date']?.toString(),
                                    sessionData['time']?.toString(),
                                  ),
                                  fontsize: 12.sp,
                                  color: const Color(0xff757575),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.icons.location.svg(),
                              SizedBox(width: 6.w),
                              CustomText(
                                text: sessionData['floorMapLocation'] != null
                                    ? 'Floor Map Available'
                                    : 'Location TBD',
                                fontsize: 12.sp,
                                color: const Color(0xff757575),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () => controller.viewMap(context),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xffD2D2D2),
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(4.r),
                                  ),
                                  child: CustomText(
                                    text: 'View Map',
                                    fontsize: 10.sp,
                                    color: const Color(0xff252525),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ── Action Buttons ────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ActionButton(
                          svgIcon: 'assets/icons/qa.svg',
                          text: 'Q&A',
                          onTap: () => controller.openQA(context),
                        ),
                        ActionButton(
                          svgIcon: 'assets/icons/poll.svg',
                          text: 'Poll',
                          onTap: () => controller.openPoll(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ActionButton(
                          svgIcon: 'assets/icons/note.svg',
                          text: 'Note',
                          onTap: () => controller.openNote(context),
                        ),
                        Obx(() => ActionButton(
                              svgIcon: 'assets/icons/like.svg',
                              text: 'Like',
                              onTap: () => controller.toggleLike(),
                              iconColor: controller.isLiked.value
                                  ? const Color(0xffE53935)
                                  : null,
                            )),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // ── Session Overview ──────────────────────────────
                    const SectionHeader(title: 'Session Overview'),
                    Container(
                      width: 345.w,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0x66EFEFF0),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.r),
                          bottomRight: Radius.circular(12.r),
                        ),
                      ),
                      child: CustomText(
                        textAlign: TextAlign.start,
                        maxline: 10,
                        text: sessionData['details']
                                    ?.toString()
                                    .isNotEmpty ==
                                true
                            ? sessionData['details'].toString()
                            : 'No overview available',
                        fontsize: 14.sp,
                        color: const Color(0xff252525),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ── How to Attend ─────────────────────────────────
                    const SectionHeader(title: 'How to attend'),
                    Container(
                      width: 345.w,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0x66EFEFF0),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.r),
                          bottomRight: Radius.circular(12.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          _attendRow(
                            icon: isOnline
                                ? Icons.videocam_outlined
                                : Icons.meeting_room_outlined,
                            text: isOnline
                                ? 'Join online${liveProvider.isNotEmpty ? ' via $liveProvider' : ''}'
                                : 'Attend in person',
                          ),
                          if (isOnline && liveStatus.isNotEmpty) ...[
                            SizedBox(height: 12.h),
                            _attendRow(
                              icon: liveStatus == 'LIVE'
                                  ? Icons.circle
                                  : Icons.access_time,
                              iconColor: liveStatus == 'LIVE'
                                  ? const Color(0xffE53935)
                                  : const Color(0xff757575),
                              text: liveStatus == 'LIVE'
                                  ? 'Session is currently LIVE'
                                  : 'Status: $liveStatus',
                            ),
                          ],
                          if (isOnline) ...[
                            SizedBox(height: 12.h),
                            _attendRow(
                              icon: Icons.desktop_mac_outlined,
                              text:
                                  'Open the app and tap "Join" when the session starts',
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ── Speakers ──────────────────────────────────────
                    Obx(() {
                      final profiles = controller.speakerProfiles;
                      final isTrackChair = controller.isTrackChair;

                      if (profiles.isEmpty && !isTrackChair) return const SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeader(title: 'Speakers'),
                          if (profiles.isNotEmpty)
                            Container(
                              width: 345.w,
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: const Color(0x66EFEFF0),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12.r),
                                  bottomRight: Radius.circular(12.r),
                                ),
                              ),
                              child: Column(
                                children: profiles.map((sp) {
                                  final accountId =
                                      sp['accountId']?.toString() ?? '';
                                  final affiliations =
                                      sp['affiliations'] as List?;
                                  final company = affiliations != null &&
                                          affiliations.isNotEmpty
                                      ? (affiliations.first
                                              as Map<String, dynamic>)['company']
                                          ?.toString() ??
                                          ''
                                      : '';
                                  return SpeakerCard(
                                    name: sp['name']?.toString() ?? 'Speaker',
                                    role: sp['sessionRole']?.toString() ?? '',
                                    company: company,
                                    imagePath: sp['avatar']?.toString() ?? '',
                                    about: sp['about']?.toString() ?? '',
                                    onTap: () =>
                                        controller.openSpeakerDetails(
                                      context,
                                      accountId,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          if (isTrackChair) ...[
                            SizedBox(height: 16.h),
                            _AddSpeakerButton(
                              controller: controller,
                              sessionIdx: widget.sessionIdx,
                            ),
                          ],
                        ],
                      );
                    }),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendRow({
    required IconData icon,
    required String text,
    Color iconColor = const Color(0xff252525),
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        SizedBox(width: 12.w),
        Expanded(
          child: CustomText(
            textAlign: TextAlign.start,
            text: text,
            fontsize: 14.sp,
            color: const Color(0xff252525),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(String? isoDate, String? time) {
    String datePart = '';
    if (isoDate != null && isoDate.isNotEmpty) {
      try {
        final dt = DateTime.parse(isoDate);
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
        ];
        datePart = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
      } catch (_) {
        datePart = isoDate;
      }
    }
    if (time != null && time.isNotEmpty) {
      return datePart.isNotEmpty ? '$datePart · $time' : time;
    }
    return datePart.isNotEmpty ? datePart : 'Date not available';
  }
}

class _AddSpeakerButton extends StatelessWidget {
  final AgendaDetailsController controller;
  final String sessionIdx;

  const _AddSpeakerButton({
    required this.controller,
    required this.sessionIdx,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: controller.isAddingSpeaker.value
              ? null
              : () => _showAddSpeakerSheet(context),
          child: Container(
            width: 330.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50.r),
              border: Border.all(
                color: const Color(0xff32A69A),
                width: 1,
              ),
            ),
            child: controller.isAddingSpeaker.value
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xff32A69A),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: Color(0xff32A69A), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Add Speaker',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff32A69A),
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }

  void _showAddSpeakerSheet(BuildContext context) {
    controller.clearSpeakerSearch();
    final emailController = TextEditingController();
    _debounceTimer?.cancel();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddSpeakerSheet(
        agendaController: controller,
        emailController: emailController,
      ),
    ).whenComplete(() {
      _debounceTimer?.cancel();
      controller.clearSpeakerSearch();
    });
  }

  static Timer? _debounceTimer;
}

class _AddSpeakerSheet extends StatefulWidget {
  final AgendaDetailsController agendaController;
  final TextEditingController emailController;

  const _AddSpeakerSheet({
    required this.agendaController,
    required this.emailController,
  });

  @override
  State<_AddSpeakerSheet> createState() => _AddSpeakerSheetState();
}

class _AddSpeakerSheetState extends State<_AddSpeakerSheet> {
  Timer? _debounce;
  bool _showDropdown = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      widget.agendaController.clearSpeakerSearch();
      setState(() => _showDropdown = false);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.agendaController.searchSpeaker(value.trim());
      setState(() => _showDropdown = true);
    });
  }

  void _selectSpeaker(String email, String speakerId) {
    widget.emailController.text = email;
    setState(() => _showDropdown = false);
    widget.agendaController.speakerSearchResult.value =
        widget.agendaController.speakerSearchResult.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Speaker',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff252525),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Color(0xff757575)),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            Text(
              'Enter speaker',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff252525),
              ),
            ),
            SizedBox(height: 8.h),

            // Search field + dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xffD2D2D2)),
                  ),
                  child: Obx(() => TextField(
                        controller: widget.emailController,
                        onChanged: _onEmailChanged,
                        style: const TextStyle(
                          color: Color(0xff252525), // ← black text while typing
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 14.h),
                          hintText: 'Enter speaker email',
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xff9E9E9E),
                          ),
                          suffixIcon: widget.agendaController
                                  .isSearchingSpeaker.value
                              ? Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xff32A69A),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      )),
                ),

                // Dropdown result
                Obx(() {
                  final result = widget.agendaController.speakerSearchResult.value;
                  final error = widget.agendaController.speakerSearchError.value;
                  final isSearching = widget.agendaController.isSearchingSpeaker.value;

                  if (!_showDropdown || isSearching) return const SizedBox.shrink();

                  if (error.isNotEmpty && result == null) {
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 4.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xffD2D2D2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'No speaker found',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xff9E9E9E),
                        ),
                      ),
                    );
                  }

                  if (result != null) {
                    final email = result['email']?.toString() ?? '';
                    final speakerId = result['speakerId']?.toString() ?? '';
                    final assignedSessions =
                        (result['alreadyAssignedSessions'] as List?)
                                ?.map((e) => e.toString())
                                .join(', ') ??
                            '';

                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xffD2D2D2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () => _selectSpeaker(email, speakerId),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18.r,
                                backgroundColor: const Color(0xffE8F5F3),
                                child: Text(
                                  email.isNotEmpty
                                      ? email[0].toUpperCase()
                                      : 'S',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff32A69A),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      email,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff252525),
                                      ),
                                    ),
                                    if (assignedSessions.isNotEmpty) ...[
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Already in session(s): $assignedSessions',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: const Color(0xff9E9E9E),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.check_circle_outline,
                                color: const Color(0xff32A69A),
                                size: 18.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                }),
              ],
            ),

            SizedBox(height: 24.h),

            // Assign button
            Obx(() {
              final result = widget.agendaController.speakerSearchResult.value;
              final speakerId = result?['speakerId']?.toString() ?? '';
              final canAssign = speakerId.isNotEmpty &&
                  widget.emailController.text.trim().isNotEmpty;

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canAssign
                      ? () {
                          Navigator.of(context).pop();
                          widget.agendaController.addSpeaker(speakerId);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff32A69A),
                    disabledBackgroundColor: const Color(0xffB0B0B0),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Assign',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
