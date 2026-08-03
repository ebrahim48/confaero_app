import 'package:confaero_app/features/attendees/presentation/widgets/sidebar_drawer.dart';
import 'package:confaero_app/features/speakers/presentation/widgets/speaker_sidebar_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/controllers/role_controller.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/event_participation.dart';
import '../../../data/models/invitation_model.dart';
import '../../../data/models/my_event_model.dart';
import '../../controllers/events_controller.dart';
import '../../widgets/event_card_widget.dart';
import '../event_card_shimmer.dart';
import '../events_search_widgets.dart';
import '../events_tab_switcher_widget.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final EventsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(EventsController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Obx(() {
        final role = RoleController.to.activeRole.value.toUpperCase();
        if (role == 'SPEAKER') {
          return const SpeakerSidebarDrawer();
        }
        return const SidebarDrawer();
      }),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 98.h,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              color: const Color(0xffF5F5F5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.pushNamed(AppRoutes.myProfileScreen),
                    child: Container(
                      width: 40.w,
                      height: 42.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xff252525), width: 0.7),
                      ),
                      child: ClipOval(
                        child: Image.asset('assets/images/profile.png',
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  CustomText(
                    text: 'Events',
                    fontsize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor424242,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            context.pushNamed(AppRoutes.notificationsScreen),
                        child: SvgPicture.asset(
                          'assets/icons/notification.svg',
                          width: 24.w,
                          height: 24.h,
                          colorFilter: ColorFilter.mode(
                              AppColors.textColor424242, BlendMode.srcIn),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: () => scaffoldKey.currentState?.openDrawer(),
                        child: SvgPicture.asset(
                          'assets/icons/menusidebar.svg',
                          width: 24.w,
                          height: 24.h,
                          colorFilter: ColorFilter.mode(
                              AppColors.textColor424242, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    EventSearchBar(
                      controller: controller.searchController,
                      onChanged: controller.onSearchChanged,
                    ),
                    SizedBox(height: 16.h),
                    Obx(() => EventTabSwitcher(
                      selectedTab: controller.selectedTab.value,
                      onTabChanged: controller.switchTab,
                      tabLabels: controller.tabLabels,
                    )),
                    SizedBox(height: 12.h),
                    Obx(() {
                      final activeRole = RoleController.to.activeRole.value.toUpperCase();
                      final tabIndex = controller.selectedTab.value;

                      // Determine which tab content to show based on role and tab index
                      if (activeRole == 'ATTENDEE' || activeRole == 'SPEAKER') {
                        return tabIndex == 0
                            ? _buildMyEventsTab()
                            : _buildExploreEventsTab();
                      } else if (activeRole == 'VOLUNTEER' ||
                          activeRole == 'REVIEWER' ||
                          activeRole == 'ABSTRACT_REVIEWER' ||
                          activeRole == 'TRACK_CHAIR') {
                        return tabIndex == 0
                            ? _buildMyEventsTab()
                            : _buildInvitedEventsTab();
                      } else if (activeRole == 'EXHIBITOR' ||
                          activeRole == 'BOOTH_STAFF' ||
                          activeRole == 'STAFF' ||
                          activeRole == 'SPONSOR') {
                        return tabIndex == 0
                            ? _buildMyEventsTab()
                            : _buildAllEventsTab();
                      } else if (activeRole == 'ORGANIZER') {
                        return _buildMyEventsTab();
                      } else {
                        // Default
                        return tabIndex == 0
                            ? _buildMyEventsTab()
                            : _buildExploreEventsTab();
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── My Events Tab ─────────────────────────────────────────────────────────

  Widget _buildMyEventsTab() {
    if (controller.isMyEventsLoading.value) return _shimmerList();

    if (controller.myEventsError.isNotEmpty) {
      return _errorWidget(
          controller.myEventsError.value, controller.loadMyEvents);
    }

    final active = controller.filteredActiveEvents;
    final invitations = controller.filteredMyInvitations;

    if (active.isEmpty && invitations.isEmpty) {
      return _noEventsWidget();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pending invitations (awaiting Accept / Reject)
        if (invitations.isNotEmpty) ...[
          CustomText(
            text: 'Invitations(${invitations.length})',
            fontsize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor424242,
            textAlign: TextAlign.start,
            bottom: 12.h,
          ),
          ...invitations.map((inv) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _buildInvitationCard(inv),
          )),
          SizedBox(height: 24.h),
        ],

        // Active (registered) events
        if (active.isNotEmpty) ...[
          CustomText(
            text: 'My events(${active.length})',
            fontsize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor424242,
            textAlign: TextAlign.start,
            bottom: 12.h,
          ),
          ...active.map((m) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _buildRegisteredCard(m),
          )),
          SizedBox(height: 24.h),
        ],
      ],
    );
  }

  Widget _buildInvitationCard(InvitationModel inv) {
    final e = inv.event;
    return EventCard(
      imageUrl: e?.bannerImageUrl ?? '',
      isNetworkImage: e?.bannerImageUrl != null && e!.bannerImageUrl!.isNotEmpty,
      title: e?.title ?? 'Event Invitation',
      date: e?.formattedDateRange ?? '',
      location: e?.location ?? '',
      isRegistered: true,
      registrationStatus: RegistrationStatus.pending,
      invitationRole: inv.role,
      onCardTap: () async {
        await controller.openEventDetails(
          context,
          inv.eventId,
          title: e?.title ?? '',
          registrationStatus: RegistrationStatus.pending,
          role: inv.role,
        );
        // Returning from details — the invitation may now be accepted/rejected.
        await controller.loadMyEvents();
      },
    );
  }

  Widget _buildRegisteredCard(MyEventModel m) {
    final e = m.event;
    return EventCard(
      imageUrl: e.bannerImageUrl ?? '',
      isNetworkImage: e.bannerImageUrl != null && e.bannerImageUrl!.isNotEmpty,
      title: e.title,
      date: e.formattedDateRange,
      location: e.location,
      isRegistered: true,
      // An unanswered invitation is shown as PENDING so the card offers
      // Accept / Reject on the details screen rather than "Enter Event".
      registrationStatus: m.isPendingInvitation
          ? RegistrationStatus.pending
          : RegistrationStatus.verified,
      invitationRole: m.invitationRole,
      onCardTap: () async {
        await controller.openEventDetails(
          context,
          e.id,
          title: e.title,
          registrationStatus: m.isPendingInvitation
              ? RegistrationStatus.pending
              : RegistrationStatus.verified,
          role: m.joinRole,
        );
        // The invitation may have been accepted/rejected while we were away.
        if (m.isInvited) await controller.loadMyEvents();
      },
    );
  }

  Widget _buildUpcomingCard(EventModel e) {
    return EventCard(
      imageUrl: e.bannerImageUrl ?? '',
      isNetworkImage: e.bannerImageUrl != null && e.bannerImageUrl!.isNotEmpty,
      title: e.title,
      date: e.formattedDateRange,
      location: e.location,
      isRegistered: false,
      onRegisterTap: _canSelfRegister
          ? () => controller.registerEvent(context, e.id, title: e.title)
          : null,
      onCardTap: () => controller.openEventDetails(context, e.id, title: e.title),
    );
  }

  // ── Explore Events Tab ────────────────────────────────────────────────────

  Widget _buildExploreEventsTab() {
    if (controller.isExploreLoading.value) return _shimmerList();

    if (controller.exploreError.isNotEmpty) {
      return _errorWidget(
          controller.exploreError.value, controller.loadExploreEvents);
    }

    final events = controller.filteredExploreEvents;
    if (events.isEmpty) return _emptyWidget('No events available');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'All events(${events.length})',
          fontsize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor424242,
          textAlign: TextAlign.start,
          bottom: 12.h,
        ),
        ...events.map((e) => Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: EventCard(
            imageUrl: e.bannerImageUrl ?? '',
            isNetworkImage:
            e.bannerImageUrl != null && e.bannerImageUrl!.isNotEmpty,
            title: e.title,
            date: e.formattedDateRange,
            location: e.location,
            isRegistered: false,
            // Only attendees self-register; other roles open the details page
            // to read the "you join by invitation" explanation.
            onRegisterTap: _canSelfRegister
                ? () => controller.registerEvent(context, e.id, title: e.title)
                : null,
            onCardTap: () => controller.openEventDetails(context, e.id, title: e.title),
          ),
        )),
        SizedBox(height: 24.h),
      ],
    );
  }

  /// True when the active role may use the self-registration path.
  bool get _canSelfRegister =>
      AppRole.canSelfRegister(RoleController.to.activeRole.value);

  // ── Invited Events Tab ────────────────────────────────────────────────────

  Widget _buildInvitedEventsTab() {
    if (controller.isInvitedLoading.value) return _shimmerList();

    if (controller.invitedError.isNotEmpty) {
      return _errorWidget(
          controller.invitedError.value, controller.loadInvitedEvents);
    }

    final events = controller.filteredInvitedEvents;
    if (events.isEmpty) return _emptyWidget('No invited events found');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Invited events(${events.length})',
          fontsize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor424242,
          textAlign: TextAlign.start,
          bottom: 12.h,
        ),
        ...events.map((e) {
          // These are invitations, so pull the matching My Events entry for
          // the invitation role / status.
          final myEvent = controller.activeMyEvents
              .where((m) => m.event.id == e.id)
              .firstOrNull;
          final inMyEvents = myEvent != null;
          final status = myEvent == null
              ? ''
              : (myEvent.isPendingInvitation
                  ? RegistrationStatus.pending
                  : RegistrationStatus.verified);

          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: EventCard(
              imageUrl: e.bannerImageUrl ?? '',
              isNetworkImage:
                  e.bannerImageUrl != null && e.bannerImageUrl!.isNotEmpty,
              title: e.title,
              date: e.formattedDateRange,
              location: e.location,
              isRegistered: inMyEvents,
              registrationStatus: status,
              invitationRole: myEvent?.invitationRole ?? '',
              // Invited roles never self-register — the card just opens.
              onRegisterTap: null,
              onCardTap: () async {
                await controller.openEventDetails(
                  context,
                  e.id,
                  title: e.title,
                  registrationStatus: status,
                  role: myEvent?.joinRole ?? '',
                );
                await controller.loadMyEvents();
                await controller.loadInvitedEvents();
              },
            ),
          );
        }),
        SizedBox(height: 24.h),
      ],
    );
  }

  // ── All Events Tab ────────────────────────────────────────────────────────

  Widget _buildAllEventsTab() {
    if (controller.isAllEventsLoading.value) return _shimmerList();

    if (controller.allEventsError.isNotEmpty) {
      return _errorWidget(
          controller.allEventsError.value, controller.loadAllEvents);
    }

    final events = controller.filteredAllEvents;
    if (events.isEmpty) return _emptyWidget('No events available');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'All events(${events.length})',
          fontsize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor424242,
          textAlign: TextAlign.start,
          bottom: 12.h,
        ),
        ...events.map((e) => Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: EventCard(
            imageUrl: e.bannerImageUrl ?? '',
            isNetworkImage:
            e.bannerImageUrl != null && e.bannerImageUrl!.isNotEmpty,
            title: e.title,
            date: e.formattedDateRange,
            location: e.location,
            isRegistered: false,
            onRegisterTap: _canSelfRegister
                ? () => controller.registerEvent(context, e.id, title: e.title)
                : null,
            onCardTap: () => controller.openEventDetails(context, e.id, title: e.title),
          ),
        )),
        SizedBox(height: 24.h),
      ],
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────

  Widget _shimmerList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        4,
            (i) => Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: const ShimmerEventCard(),
        ),
      ),
    );
  }

  Widget _errorWidget(String message, VoidCallback onRetry) {
    return SizedBox(
      height: 300.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            SizedBox(height: 12.h),
            CustomText(
              text: message,
              fontsize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor7E7F7E,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding:
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xff5BB8AE),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: CustomText(
                  text: 'Retry',
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyWidget(String message) {
    return SizedBox(
      height: 300.h,
      child: Center(
        child: CustomText(
          text: message,
          fontsize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor7E7F7E,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _noEventsWidget() {
    return SizedBox(
      height: 400.h,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.event_busy_outlined,
                size: 80.w,
                color: AppColors.iconColorAEAEAE,
              ),
              SizedBox(height: 24.h),
              CustomText(
                text: 'You have no events',
                fontsize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor252525,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: 'Register for an event to get started!',
                fontsize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor7E7F7E,
                textAlign: TextAlign.center,
                maxline: 2,
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () => controller.switchTab(1),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff5BB8AE),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: CustomText(
                    text: 'Explore Events',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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