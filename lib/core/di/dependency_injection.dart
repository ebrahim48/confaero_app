import 'package:get/get.dart';

import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/connection/domain/services/connection_service.dart';
import '../../features/mainattendees/domain/services/attendee_service.dart';
import '../../features/message/domain/services/message_service.dart';
import '../../features/profile/domain/services/profile_service.dart';
import '../../features/agenda/domain/services/agenda_service.dart';
import '../../features/announcements/domain/services/announcement_service.dart';
import '../../features/notes/domain/services/note_service.dart';
import '../../features/sponsors/domain/services/sponsor_service.dart';
import '../../features/documents/domain/services/document_service.dart';
import '../../features/photos/domain/services/photo_service.dart';
import '../../features/resources/domain/services/resource_service.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import '../services/connectivity_service.dart';
import '../services/qr_service.dart';
import '../services/job_service.dart';
import '../services/invitation_service.dart';
import '../services/content_service.dart';
import '../services/organizer_service.dart';
import '../services/booth_service.dart';
import '../services/sponsor_dashboard_service.dart';
import '../services/poster_service.dart';
import '../services/poster_assign_service.dart';
import '../services/reviewer_service.dart';
import '../services/volunteer_service.dart';
import '../services/video_conference_service.dart';
import '../services/organizer_message_service.dart';
import '../services/socket_service.dart';
import '../services/verified_email_service.dart';
import '../services/speaker_service.dart';
import '../controllers/session_controller.dart';
import '../controllers/role_controller.dart';

/// Dependency Injection setup for the application.
///
/// This class manages all service and repository instances using the GetX
/// dependency injection framework. It follows the Dependency Inversion Principle
/// by ensuring that high-level modules don't depend on low-level modules.
///
/// **Architecture Layers:**
/// - Core Services: Low-level services (API, Cache, Connectivity)
/// - Repositories: Data access layer (handles API calls and caching)
/// - Domain Services: Business logic layer (coordinates repositories)
/// - Controllers: Presentation layer (manages UI state)
///
/// **Usage:**
/// Call [init] in main.dart before running the app:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   DependencyInjection.init();
///   runApp(MyApp());
/// }
/// ```
///
/// **Testing:**
/// Use [clear] to reset all dependencies between tests:
/// ```dart
/// setUp(() {
///   DependencyInjection.clear();
///   DependencyInjection.init();
/// });
/// ```
class DependencyInjection {
  // Private constructor to prevent instantiation
  DependencyInjection._();

  /// Initialize all application dependencies.
  ///
  /// This method sets up all services, repositories, and controllers using
  /// lazy initialization. Dependencies are only created when first accessed.
  ///
  /// **Initialization Order:**
  /// 1. Core Services (API, Cache, Connectivity)
  /// 2. Repositories (depends on Core Services)
  /// 3. Domain Services (depends on Repositories and Core Services)
  /// 4. Controllers (depends on Domain Services and Repositories)
  ///
  /// The `fenix: true` parameter ensures services are recreated if deleted.
  static void init() {
    // Global session state (must come first)
    Get.put<SessionController>(SessionController(), permanent: true);

    // Role controller (must be initialized early for role-based UI)
    Get.put<RoleController>(RoleController(), permanent: true);

    // Core Services (Singletons)
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<CacheService>(() => CacheService(), fenix: true);
    Get.lazyPut<ConnectivityService>(() => ConnectivityService(), fenix: true);

    // Socket.IO Service (real-time communication)
    Get.lazyPut<SocketService>(() => SocketService(), fenix: true);

    // Auth Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Profile Service
    Get.lazyPut<ProfileService>(
      () => ProfileService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Connection Service
    Get.lazyPut<ConnectionService>(
      () => ConnectionService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Attendee Service
    Get.lazyPut<AttendeeService>(
      () => AttendeeService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Message Service
    Get.lazyPut<MessageService>(
      () => MessageService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Agenda Service
    Get.lazyPut<AgendaService>(
      () => AgendaService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Announcement Service
    Get.lazyPut<AnnouncementService>(
      () => AnnouncementService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Note Service
    Get.lazyPut<NoteService>(
      () => NoteService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Sponsor Service
    Get.lazyPut<SponsorService>(
      () => SponsorService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Document Service
    Get.lazyPut<DocumentService>(
      () => DocumentService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Photo Service
    Get.lazyPut<PhotoService>(
      () => PhotoService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Resource Service
    Get.lazyPut<ResourceService>(
      () => ResourceService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // QR Service
    Get.lazyPut<QrService>(
      () => QrService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Job Service
    Get.lazyPut<JobService>(
      () => JobService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Invitation Service
    Get.lazyPut<InvitationService>(
      () => InvitationService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Content Service
    Get.lazyPut<ContentService>(
      () => ContentService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Verified Email Service
    Get.lazyPut<VerifiedEmailService>(
      () => VerifiedEmailService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // ======================== Role-Specific Services ========================

    // Organizer Service
    Get.lazyPut<OrganizerService>(
      () => OrganizerService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Booth Service
    Get.lazyPut<BoothService>(
      () => BoothService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Sponsor Dashboard Service
    Get.lazyPut<SponsorDashboardService>(
      () => SponsorDashboardService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Poster Service
    Get.lazyPut<PosterService>(
      () => PosterService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Poster Assign Service
    Get.lazyPut<PosterAssignService>(
      () => PosterAssignService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Reviewer Service
    Get.lazyPut<ReviewerService>(
      () => ReviewerService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Volunteer Service
    Get.lazyPut<VolunteerService>(
      () => VolunteerService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Video Conference Service
    Get.lazyPut<VideoConferenceService>(
      () => VideoConferenceService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Organizer Message Service
    Get.lazyPut<OrganizerMessageService>(
      () => OrganizerMessageService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Speaker Service
    Get.lazyPut<SpeakerService>(
      () => SpeakerService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );
  }

  /// Clear all dependencies from memory.
  ///
  /// This is useful for testing to ensure a clean state between tests.
  /// The `force: true` parameter ensures all instances are deleted even
  /// if they're marked as permanent.
  ///
  /// **Example:**
  /// ```dart
  /// tearDown(() {
  ///   DependencyInjection.clear();
  /// });
  /// ```
  static void clear() {
    Get.deleteAll(force: true);
  }
}
