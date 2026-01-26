import 'package:confaero_app/features/agenda/presentation/widgets/speaker_session_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';

class SpeakerSessionsSection extends StatelessWidget {
  final List<Map<String, dynamic>> sessions;
  final Function(String) onSessionTap;
  final Function(String) onFavoriteTap;
  final bool Function(String) isSessionFavorited;

  const SpeakerSessionsSection({
    super.key,
    required this.sessions,
    required this.onSessionTap,
    required this.onFavoriteTap,
    required this.isSessionFavorited,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Speaking At',
              fontsize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff252525),
            ),
            CustomText(
              text: '${sessions.length} sessions',
              fontsize: 14.sp,
              color: const Color(0xff757575),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Sessions List
        ...sessions.map((session) {
          final sessionId = session['id']?.toString() ?? '';
          return SpeakerSessionCard(
            type: session['type']?.toString() ?? '',
            title: session['title']?.toString() ?? '',
            time: session['time']?.toString() ?? '',
            attendees: session['attendees'] ?? 0,
            isFavorited: isSessionFavorited(sessionId),
            onTap: () => onSessionTap(sessionId),
            onFavoriteTap: () => onFavoriteTap(sessionId),
          );
        }).toList(),
      ],
    );
  }
}