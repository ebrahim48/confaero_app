# Confaero App — API Implementation Document

> This document explains **how every API** in the Postman collection (`api.json`) should be implemented in the Confaero Flutter app. For each API, you'll find the endpoint details, implementation steps, and which files to create/modify.

---

## 📐 Architecture Overview (How the App Connects to APIs)

Before diving into individual APIs, understand the **5-layer architecture** the app uses:

```
┌─────────────────────────────────────────────────────────┐
│ 1. API Constants       (defines the endpoint URL)       │
│    lib/core/constants/api_constants.dart                 │
├─────────────────────────────────────────────────────────┤
│ 2. Data Model          (converts JSON → Dart object)    │
│    lib/features/{feature}/data/models/                   │
├─────────────────────────────────────────────────────────┤
│ 3. Service/Repository  (makes the API call)             │
│    lib/features/{feature}/domain/services/               │
│    lib/features/{feature}/data/repositories/             │
├─────────────────────────────────────────────────────────┤
│ 4. Controller          (manages UI state + calls service)│
│    lib/features/{feature}/presentation/.../controllers/  │
├─────────────────────────────────────────────────────────┤
│ 5. UI Screen           (displays data to user)          │
│    lib/features/{feature}/presentation/.../screens/      │
└─────────────────────────────────────────────────────────┘
```

### Step-by-Step Pattern for ANY API Implementation:

1. **Add endpoint constant** → `api_constants.dart`
2. **Create/update data model** → `{feature}/data/models/` (if the API returns new data)
3. **Create/update service** → `{feature}/domain/services/` (the actual API call)
4. **Register in DI** → `dependency_injection.dart` (so the app can find the service)
5. **Create/update controller** → `{feature}/presentation/.../controllers/` (manages loading state, calls service)
6. **Wire to UI** → connect the controller to the screen widgets

### Key Files You'll Always Use:

| File                                                                                                             | Purpose                                         |
| ---------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| [api_constants.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/core/constants/api_constants.dart)        | All endpoint URL strings                        |
| [api_service.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/core/services/api_service.dart)             | Dio HTTP client (handles GET/POST/PATCH/DELETE) |
| [dependency_injection.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/core/di/dependency_injection.dart) | GetX DI registration                            |
| [app_constants.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/core/constants/app_constants.dart)        | SharedPreferences keys (tokens, user data)      |
| [prefs_helper.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/core/helpers/prefs_helper.dart)            | Read/write local storage                        |
| [app_exceptions.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/core/exceptions/app_exceptions.dart)     | Custom error types                              |
| [logger_helper.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/core/helpers/logger_helper.dart)          | Logging utility                                 |

---

## ✅ IMPLEMENTED APIs (13 total — ~6% coverage)

These APIs are already working in the app. Below is how each one is implemented.

---

### 1. POST `/auth/register` — Register New User

**What it does:** Creates a new user account with name, email, and password.

**Request Body:**

```json
{
  "name": "test user1",
  "email": "user1@gmail.com",
  "password": "123456",
  "confirmPassword": "123456"
}
```

**Implementation Flow:**

```
api_constants.dart → AuthRepository.register() → SignUpController → SignUpScreen
```

**Files involved:**
| File | What it does |
|---|---|
| [api_constants.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/core/constants/api_constants.dart) | `static const String register = '/auth/register';` |
| [auth_repository.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/auth/data/repositories/auth_repository.dart) | `register()` method — checks connectivity, sends POST with name/email/password/confirmPassword, returns the JSON response map |
| [signup_controller.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/auth/presentation/signup/controllers/signup_controller.dart) | Validates form inputs, calls `_authRepository.register()`, handles success/error, navigates to sign-in screen |

**Key Learning:** The `AuthRepository` sits in the **data layer** — it only handles the raw API call. The `SignUpController` sits in the **presentation layer** — it manages form validation, loading state (`isLoading.obs`), and navigation.

---

### 2. POST `/auth/login` — Login User

**What it does:** Authenticates a user and returns JWT access/refresh tokens.

**Request Body:**

```json
{
  "email": "attendee@gmail.com",
  "password": "123456"
}
```

**Response Data:**

```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "...",
    "activeRole": "ATTENDEE"
  }
}
```

**Implementation Flow:**

```
api_constants.dart → AuthRepository.login() → SignInController → SignInScreen
```

**Files involved:**
| File | What it does |
|---|---|
| [api_constants.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/core/constants/api_constants.dart) | `static const String login = '/auth/login';` |
| [auth_repository.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/auth/data/repositories/auth_repository.dart) | `login()` method — connectivity check, POST with email/password |
| [login_controller.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/auth/presentation/signin/controllers/login_controller.dart) | Validates form, calls `_authRepository.login()`, **saves tokens to SharedPreferences** (`PrefsHelper.setString`), navigates to events screen |

**Key Learning:** After login, the controller saves `accessToken`, `refreshToken`, and `activeRole` to local storage using `PrefsHelper`. The `ApiService` interceptor automatically reads this token and adds it to every future request header as `Authorization: Bearer <token>`.

---

### 3. POST `/auth/forgot-password` — Send Password Reset Code

**What it does:** Sends a 6-digit verification code to the user's email.

**Request Body:**

```json
{ "email": "user@gmail.com" }
```

**Implementation Flow:**

```
api_constants.dart → ApiService.post() → ForgetPasswordController → ForgetPasswordScreen
```

**Files involved:**
| File | What it does |
|---|---|
| [api_constants.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/core/constants/api_constants.dart) | `static const String forgetPassword = '/auth/forgot-password';` |
| [forget_password_controller.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/auth/presentation/forget/controllers/forget_password_controller.dart) | Calls `_apiService.post()` directly (no repository), validates email, shows toast, navigates to verify screen |

**Key Learning:** This controller uses `ApiService` directly instead of going through a repository. Both patterns exist in the app. The `validateStatus: false` parameter tells Dio to **not throw an error** for non-200 status codes, so the controller can read the response body even on error responses.

---

### 4. POST `/auth/verify-reset-code` — Verify Reset Code

**What it does:** Validates the 6-digit code sent to email, returns a `resetToken`.

**Request Body:**

```json
{ "email": "user@gmail.com", "code": "123456" }
```

**Response:** Returns `{ "data": { "resetToken": "abc123..." } }`

**Implementation Flow:**

```
api_constants.dart → ApiService.post() → VerifyController → VerifyScreen
```

**Files involved:**
| File | What it does |
|---|---|
| [api_constants.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/core/constants/api_constants.dart) | `static const String verifyResetCode = '/auth/verify-reset-code';` |
| [verify_controller.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/auth/presentation/verify/controllers/verify_controller.dart) | Verifies enter PIN length (6 digits), sends POST, extracts `resetToken` from response, navigates to reset password screen with token as query parameter. Also handles **resend code** by calling `forgetPassword` endpoint again |

**Key Learning:** The `VerifyController` has a built-in **resend timer** (60 seconds). It also handles the "resend code" feature by re-calling the `/auth/forgot-password` endpoint — showing that one controller can call multiple APIs.

---

### 5. POST `/auth/reset-password` — Reset Password

**What it does:** Sets a new password using the reset token.

**Request Body:**

```json
{
  "token": "abc123...",
  "email": "user@gmail.com",
  "newPassword": "newpass123",
  "confirmPassword": "newpass123"
}
```

**Implementation Flow:**

```
api_constants.dart → ApiService.post() → ResetPasswordController → ResetPasswordScreen
```

**Files involved:**
| File | What it does |
|---|---|
| [api_constants.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/core/constants/api_constants.dart) | `static const String resetPassword = '/auth/reset-password';` |
| [reset_password_controller.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/auth/presentation/reset/controllers/reset_password_controller.dart) | Validates passwords match, sends POST with token + new passwords, handles expired tokens by redirecting back to forget-password screen |

**Key Learning:** This controller receives `email` and `resetToken` as query parameters from GoRouter navigation. It shows how data flows between screens using URL query parameters. It also detects **expired tokens** and redirects the user.

---

### 6. GET `/attendee/events` — Get Upcoming Events

**What it does:** Fetches all upcoming events for the attendee.

**Response:** `{ "success": true, "data": [ { event objects... } ] }`

**Implementation Flow:**

```
api_constants.dart → EventsService.getAllUpcomingEvents() → Controller → EventsScreen
```

**Files involved:**
| File | What it does |
|---|---|
| [api_constants.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/core/constants/api_constants.dart) | `static const String getAllUpcomingEvents = '/attendee/events';` |
| [events_service.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/Events/domain/services/events_service.dart) | `getAllUpcomingEvents()` — GET request, parses response `data` array into `List<EventModel>` |
| [event_model.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/Events/data/models/event_model.dart) | `EventModel.fromJson()` — converts JSON to Dart object |

**Key Learning:** The `EventsService` has a private `_checkConnectivity()` helper method that's reused by all methods in the class. The response parsing pattern is: check `success` boolean → check `data` is a List → map each item through `Model.fromJson()`.

---

### 7. GET `/superAdmin/events` — Get Explore Events

**What it does:** Fetches all events (for the explore/discover tab).

**Implementation:** Almost identical to #6 but uses `ApiConstants.getExploreEvents` → `EventsService.getExploreEvents()`.

---

### 8. GET `/attendee/my-event` — Get My Registered Events

**What it does:** Fetches events the current user has registered for.

**Response:** `{ "data": [ { "event": {...}, "status": "VERIFIED" } ] }`

**Implementation Flow:**

```
api_constants.dart → EventsService.getMyEvents() → Controller → MyEventsScreen
```

**Key Learning:** This uses `MyEventModel` (not `EventModel`) because the response wraps each event with a `status` field. Different response shapes → different models.

---

### 9. GET `/attendee/events/:id` — Get Event Details

**What it does:** Fetches full details for a single event by ID.

**Implementation:** `EventsService.getEventDetails(eventId)` — the `eventId` is appended to the URL path dynamically: `'${ApiConstants.getEventDetails}/$eventId'`.

**Key Learning:** For APIs with **path parameters** (`:id`), you build the URL by string concatenation. The API constant stores the base path, and you append the dynamic ID.

---

### 10. POST `/attendee/events/:id/initiate-registration` — Initiate Event Registration

**What it does:** Starts the registration process for an event (may require organizer approval).

**Implementation:** `EventsService.initiateRegistration(eventId)` — builds URL as `'${ApiConstants.initiateRegistration}/$eventId/initiate-registration'`.

**Key Learning:** This method has **extra error handling** using `on DioException catch (e)` to extract the server's error message from `e.response?.data`. This is useful when the API returns meaningful error messages (like "Already registered" or "Event is full").

---

### 11. GET `/attendee/events/:id/home` — Get Event Home Data

**What it does:** Fetches the home/dashboard data for a specific event (sponsors, sessions, announcements combined).

**Implementation:** `EventsService.getEventHome(eventId)` → returns `EventHomeModel`.

---

### 12. GET `/organizer/events/:id/floormaps` — Get Event Floor Maps

**What it does:** Fetches floor map images for an event.

**Implementation Flow:**

```
api_constants.dart → FloorMapService.getFloorMaps(eventId) → Controller → FloorMapScreen
```

**Files involved:**
| File | What it does |
|---|---|
| [floor_map_service.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/attendees/domain/floor_map_service.dart) | Dedicated service class for floor maps |
| [floor_map_model.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/attendees/data/floor_map_model.dart) | Data model for floor map data |

---

### 13. POST `/auth/forgot-password` (Resend) — Resend Verification Code

**What it does:** Same endpoint as #3, reused as a "resend code" button on the verify screen.

**Implementation:** The `VerifyController.resendCode()` method calls the same `ApiConstants.forgetPassword` endpoint with the same email. After success, it restarts the 60-second resend timer.

**Key Learning:** You don't always need a new API constant for every feature — the same endpoint can serve multiple use cases (initial send + resend).

---

---

## ❌ NOT IMPLEMENTED APIs — Implementation Guide

Below is every unimplemented API from the Postman collection, organized by priority. For each, I describe **what to do** step by step.

---

### 🔴 HIGH PRIORITY — Auth Completion & User Profile

---

#### API 14: POST `/auth/change-password`

**Purpose:** Let user change password from settings screen.

**Request Body:**

```json
{
  "currentPassword": "old123",
  "newPassword": "new456",
  "confirmPassword": "new456"
}
```

**Implementation Steps:**

1. **Add constant:** `static const String changePassword = '/auth/change-password';` in `api_constants.dart`
2. **Add method to `AuthRepository`:**
   ```dart
   Future<Map<String, dynamic>> changePassword({
     required String currentPassword,
     required String newPassword,
     required String confirmPassword,
   }) async {
     await _checkConnectivity();
     final response = await _apiService.post(
       ApiConstants.changePassword,
       data: {
         'currentPassword': currentPassword,
         'newPassword': newPassword,
         'confirmPassword': confirmPassword,
       },
     );
     return response.data as Map<String, dynamic>;
   }
   ```
3. **Create controller** in `lib/features/auth/presentation/settings/controllers/change_password_controller.dart`
4. **Wire to UI** — connect to the existing change password screen

---

#### API 15: POST `/auth/refresh-token`

**Purpose:** Automatically refresh expired access tokens to keep the user logged in.

**Request Body:**

```json
{ "refreshToken": "saved_refresh_token_here" }
```

**Implementation Steps:**

1. **Add constant:** `static const String refreshTokenEndpoint = '/auth/refresh-token';`
2. **Add Dio Interceptor** in `api_service.dart` that automatically calls this endpoint when a 401 response is received:
   ```dart
   // Inside onError interceptor:
   if (error.response?.statusCode == 401) {
     // Read refresh token from SharedPreferences
     // Call /auth/refresh-token
     // Save new access token
     // Retry the original request
   }
   ```
3. **No new controller needed** — this works silently in the background

> **Why this matters:** Without token refresh, users get logged out every time their access token expires (usually in 5 hours). This is the most impactful auth API to implement.

---

#### API 16: GET `/auth/me` — Get Current User

**Purpose:** Fetch the logged-in user's profile data.

**Response:**

```json
{
  "success": true,
  "data": {
    "_id": "...",
    "name": "John",
    "email": "john@gmail.com",
    "roles": ["ATTENDEE"],
    "activeRole": "ATTENDEE"
  }
}
```

**Implementation Steps:**

1. **Add constant:** `static const String getMe = '/auth/me';`
2. **Create model:** `lib/features/auth/data/models/user_model.dart` with `UserModel.fromJson()`
3. **Add method to `AuthRepository`:**
   ```dart
   Future<UserModel?> getMe() async {
     final response = await _apiService.get(ApiConstants.getMe);
     // Parse data into UserModel
   }
   ```
4. **Call on app startup** (after successful login) to populate user profile data

---

#### API 17: DELETE `/auth/delete-account`

**Purpose:** Delete the user's account (required by Apple App Store guidelines).

**Implementation Steps:**

1. **Add constant:** `static const String deleteAccount = '/auth/delete-account';`
2. **Add method to `AuthRepository`:**
   ```dart
   Future<Map<String, dynamic>> deleteAccount() async {
     final response = await _apiService.delete(ApiConstants.deleteAccount);
     return response.data as Map<String, dynamic>;
   }
   ```
3. **After success:** Clear all SharedPreferences data and navigate to login screen
4. **Add confirmation dialog** before deletion — "Are you sure? This action cannot be undone."

---

#### API 18: PATCH `/auth/notification`

**Purpose:** Toggle email notification preferences.

**Request Body:**

```json
{ "emailNotification": true }
```

**Implementation Steps:**

1. **Add constant:** `static const String toggleNotification = '/auth/notification';`
2. **Add method to `AuthRepository`:**
   ```dart
   Future<Map<String, dynamic>> toggleNotification(bool enable) async {
     final response = await _apiService.patch(
       ApiConstants.toggleNotification,
       data: {'emailNotification': enable},
     );
     return response.data as Map<String, dynamic>;
   }
   ```

---

#### API 19: GET `/user/my-profile`

**Purpose:** Get the full user profile (name, bio, avatar, resume, social links).

**Implementation Steps:**

1. **Add constant:** `static const String getMyProfile = '/user/my-profile';`
2. **Create model:** `lib/features/profile/data/models/profile_model.dart`
3. **Create service:** `lib/features/profile/domain/services/profile_service.dart`
4. **Register in DI:** Add `ProfileService` to `dependency_injection.dart`
5. **Create controller + wire to profile screen**

---

#### API 20: PATCH `/user/update-profile`

**Purpose:** Update user profile fields (name, bio, avatar, etc).

**Request Body (multipart/form-data):**

```json
{
  "name": "John Updated",
  "bio": "Software Developer",
  "avatar": "<file>",
  "resume": "<file>"
}
```

**Implementation Steps:**

1. **Add constant:** `static const String updateProfile = '/user/update-profile';`
2. **Use `FormData`** for file uploads:
   ```dart
   final formData = FormData.fromMap({
     'name': name,
     'bio': bio,
     if (avatarFile != null) 'avatar': await MultipartFile.fromFile(avatarFile.path),
   });
   final response = await _apiService.patch(ApiConstants.updateProfile, data: formData);
   ```

> **Key Learning:** For file uploads, you use `FormData` from Dio instead of a regular JSON map. This automatically sets the `Content-Type` to `multipart/form-data`.

---

#### API 21: DELETE `/user/delete-resume`

**Purpose:** Remove resume attachment from user profile.

**Implementation:** Simple DELETE request in `ProfileService`.

---

#### API 22: GET `/attendee/my-events/:id`

**Purpose:** Get details of a specific registered event.

**Implementation:** Similar to `getEventDetails()` but uses the `my-events` endpoint which includes registration status.

---

#### API 23: POST `/attendee/events/:id/register`

**Purpose:** Complete full registration for an event (after initiate-registration).

**Implementation:** Add to `EventsService` — POST request with eventId in URL path.

---

#### API 24: GET `/attendee/events/:id/sessions`

**Purpose:** Get all sessions/agenda for an event.

**Implementation Steps:**

1. **Add constant:** `static const String getEventSessions = '/attendee/events';`
2. **Create model:** `SessionModel` in events data models
3. **Add to `EventsService`:**
   ```dart
   Future<List<SessionModel>> getEventSessions(String eventId) async {
     final response = await _apiService.get('${ApiConstants.getEventSessions}/$eventId/sessions');
     // Parse list of SessionModel
   }
   ```

---

### 🟠 MEDIUM PRIORITY — Social & Engagement

---

#### API 25-30: Connection APIs

| #   | Endpoint                          | Method | Purpose                   |
| --- | --------------------------------- | ------ | ------------------------- |
| 25  | `/connection/request/:eventId`    | POST   | Send connection request   |
| 26  | `/connection/requests/:id/accept` | PATCH  | Accept connection request |
| 27  | `/connection/requests`            | GET    | Get all pending requests  |
| 28  | `/connection`                     | GET    | My connections list       |
| 29  | `/connection/:id`                 | GET    | Connection details        |
| 30  | `/connection/:id/bookmark`        | PATCH  | Bookmark a connection     |

**Implementation Steps (for all connection APIs):**

1. **Create feature folder:** `lib/features/connection/`
2. **Create models:** `ConnectionModel`, `ConnectionRequestModel` in `data/models/`
3. **Create service:** `lib/features/connection/domain/services/connection_service.dart`
   ```dart
   class ConnectionService {
     final ApiService _apiService;
     final ConnectivityService _connectivityService;

     Future<Map<String, dynamic>> sendRequest(String eventId) async { ... }
     Future<Map<String, dynamic>> acceptRequest(String requestId) async { ... }
     Future<List<ConnectionRequestModel>> getPendingRequests() async { ... }
     Future<List<ConnectionModel>> getMyConnections() async { ... }
     Future<ConnectionModel?> getConnectionDetails(String id) async { ... }
     Future<Map<String, dynamic>> bookmarkConnection(String id) async { ... }
   }
   ```
4. **Add all constants to `api_constants.dart`**
5. **Register `ConnectionService` in DI**
6. **Create controllers and wire to existing community/connection screens**

---

#### API 31-33: Attendee APIs

| #   | Endpoint                                             | Method | Purpose             |
| --- | ---------------------------------------------------- | ------ | ------------------- |
| 31  | `/eventAttendee/events/:id/attendees`                | GET    | Event attendee list |
| 32  | `/eventAttendee/events/:id/attendees/:id`            | GET    | Attendee details    |
| 33  | `/eventAttendee/events/:eid/attendees/:aid/bookmark` | PATCH  | Bookmark attendee   |

**Implementation:** Create `AttendeeService` in the existing `attendees` feature folder with methods for listing, details, and bookmarking attendees.

---

#### API 34-37: Message APIs

| #   | Endpoint                          | Method | Purpose                      |
| --- | --------------------------------- | ------ | ---------------------------- |
| 34  | `/message/send/:eventId`          | POST   | Send message                 |
| 35  | `/message/conversations/:eventId` | GET    | Get conversations list       |
| 36  | `/message/:convId/:eventId`       | GET    | Get messages in conversation |
| 37  | `/message/seen/:msgId/:eventId`   | PATCH  | Mark message as seen         |

**Implementation Steps:**

1. **Create models:** `ConversationModel`, `MessageModel`
2. **Create service:** `lib/features/message/domain/services/message_service.dart`
3. **For sending messages:**
   ```dart
   Future<Map<String, dynamic>> sendMessage(String eventId, {
     required String receiverId,
     required String content,
     String? attachmentUrl,
   }) async {
     final response = await _apiService.post(
       '${ApiConstants.sendMessage}/$eventId',
       data: {'receiverId': receiverId, 'content': content, ...},
     );
     return response.data;
   }
   ```

---

#### API 38: POST `/upload/chat-attachment`

**Purpose:** Upload file attachments for chat messages.

**Implementation:** Uses `FormData` with `MultipartFile` (same pattern as profile avatar upload).

---

### 🟡 MEDIUM PRIORITY — Content & Resources

---

#### API 39-45: Agenda/Sessions APIs

| #   | Endpoint                                          | Method | Purpose              |
| --- | ------------------------------------------------- | ------ | -------------------- |
| 39  | `/organizer-sessions/events/:id/agenda`           | GET    | Full event agenda    |
| 40  | `/organizer-sessions/events/:id/my-agenda`        | GET    | My bookmarked agenda |
| 41  | `/organizer-sessions/events/:id/my-agenda/:idx`   | POST   | Bookmark session     |
| 42  | `/organizer-sessions/events/:id/my-agenda/:idx`   | DELETE | Remove bookmark      |
| 43  | `/organizer-sessions/agenda/:id/:idx/toggle-like` | PATCH  | Like/unlike session  |
| 44  | `/organizer-sessions/events/:id/agenda/:idx`      | GET    | Session details      |
| 45  | `/organizer-sessions/events/:id/speakers/:id`     | GET    | Speaker details      |

**Implementation:** Create `AgendaService` in the existing `agenda` feature folder with all the above methods.

---

#### API 46: GET `/announcement/event/:eventId`

**Purpose:** Get all announcements for an event.

**Implementation:**

1. Create `AnnouncementModel` and `AnnouncementService`
2. Simple GET request with eventId in path

---

#### API 47-48: Notes APIs

| #   | Endpoint       | Method | Purpose                 |
| --- | -------------- | ------ | ----------------------- |
| 47  | `/note/create` | POST   | Create or update a note |
| 48  | `/note/notes`  | GET    | Get all user's notes    |

**Implementation:** Create `NoteService` with `createNote()` and `getNotes()` methods.

---

#### API 49-51: Sponsor APIs

| #   | Endpoint                                  | Method | Purpose                      |
| --- | ----------------------------------------- | ------ | ---------------------------- |
| 49  | `/organizerSponsor/all-sponsors/:eventId` | GET    | All sponsors for event       |
| 50  | `/organizerSponsor/sponsor/:id`           | GET    | Sponsor details              |
| 51  | `/sponsor/view/:id`                       | PATCH  | Increment sponsor view count |

**Implementation:** Create `SponsorService` — view count tracking uses PATCH with no body (just hitting the endpoint increments the count).

---

#### API 52-55: Document APIs

| #   | Endpoint                 | Method | Purpose                    |
| --- | ------------------------ | ------ | -------------------------- |
| 52  | `/document/:eventId/all` | GET    | All public documents       |
| 53  | `/document/:eventId/my`  | GET    | My uploaded documents      |
| 54  | `/document/:eventId`     | POST   | Upload document (FormData) |
| 55  | `/document/my/:id`       | DELETE | Delete my document         |

---

#### API 56-58: Photo APIs

| #   | Endpoint                          | Method | Purpose                 |
| --- | --------------------------------- | ------ | ----------------------- |
| 56  | `/photo/events/:id/photos`        | POST   | Upload photo (FormData) |
| 57  | `/photo/events/:id/photos`        | GET    | Get event photos        |
| 58  | `/photo/public/events/:id/photos` | GET    | Public event photos     |

---

#### API 59-61: Resource APIs (Q&A, Polls)

| #   | Endpoint                            | Method | Purpose          |
| --- | ----------------------------------- | ------ | ---------------- |
| 59  | `/resouce/event/qna/:eventId`       | GET    | Q&A for event    |
| 60  | `/resouce/event/poll/:eventId`      | GET    | Polls for event  |
| 61  | `/resouce/poll/:id/:eventId/submit` | POST   | Submit poll vote |

---

### ⚪ OTHER APIs

---

#### API 62-63: Role APIs

| #   | Endpoint            | Method | Purpose                    |
| --- | ------------------- | ------ | -------------------------- |
| 62  | `/auth/change-role` | POST   | Switch active role         |
| 63  | `/auth/my-roles`    | GET    | Get user's available roles |

**Implementation:** Add to `AuthRepository`.

---

#### API 64: GET `/appContent/TERMS_CONDITION`

**Purpose:** Fetch terms & conditions content.

**Implementation:** Simple GET, display HTML/markdown content in a WebView or RichText widget.

---

#### API 65-66: QR Code APIs

| #   | Endpoint                | Method | Purpose               |
| --- | ----------------------- | ------ | --------------------- |
| 65  | `/qr/generate/:eventId` | GET    | Generate QR for event |
| 66  | `/qr/scan/:eventId`     | POST   | Scan QR code          |

---

#### API 67-68: Job APIs

| #   | Endpoint   | Method | Purpose             |
| --- | ---------- | ------ | ------------------- |
| 67  | `/job/`    | GET    | Public job listings |
| 68  | `/job/:id` | GET    | Job details         |

---

#### API 69-71: Invitation APIs

| #   | Endpoint                              | Method | Purpose           |
| --- | ------------------------------------- | ------ | ----------------- |
| 69  | `/invitation/my-invitations/:eventId` | GET    | My invitations    |
| 70  | `/invitation/:id/accept/:eventId`     | PATCH  | Accept invitation |
| 71  | `/invitation/:id/reject/:eventId`     | PATCH  | Reject invitation |

---

### 🟢 LOW PRIORITY — Role-specific APIs

These are for non-attendee roles (organizer, exhibitor, sponsor, volunteer, etc.) and include ~80+ endpoints. They should be implemented only after all attendee-facing features are complete:

| Category          | Approx. Count | Key Endpoints                           |
| ----------------- | ------------- | --------------------------------------- |
| Super Admin       | 12            | Event management, user management       |
| Organizer         | ~20           | Session management, attendee management |
| Booth/Exhibitor   | 8             | Booth setup, lead collection            |
| Sponsor           | 8             | Sponsor dashboard, analytics            |
| Poster/Reviewer   | 20+           | Abstract submission, reviews            |
| Volunteer/Task    | 9             | Task assignment, check-in               |
| Video Conference  | 4             | Room creation, join links               |
| Organizer Message | 6             | Broadcast messages                      |

---

## 📋 Recommended Implementation Order

> Start from the top and work your way down. Each group builds on the previous one.

| Order | Group               | APIs   | Why This Order                                                       |
| ----- | ------------------- | ------ | -------------------------------------------------------------------- |
| 1     | **Auth Completion** | #14-18 | Token refresh prevents logouts; delete-account required by App Store |
| 2     | **User Profile**    | #19-21 | Profile data is used throughout the app                              |
| 3     | **Event Register**  | #22-24 | Complete the event registration flow                                 |
| 4     | **Connections**     | #25-30 | Core social networking feature                                       |
| 5     | **Attendees**       | #31-33 | Browsing event attendees                                             |
| 6     | **Messaging**       | #34-38 | Real-time chat (may need Socket.IO too)                              |
| 7     | **Agenda/Sessions** | #39-45 | Event content browsing                                               |
| 8     | **Announcements**   | #46    | Event updates                                                        |
| 9     | **Notes**           | #47-48 | Personal note-taking                                                 |
| 10    | **Sponsors**        | #49-51 | Sponsor content                                                      |
| 11    | **Documents**       | #52-55 | File sharing                                                         |
| 12    | **Photos**          | #56-58 | Event gallery                                                        |
| 13    | **Resources**       | #59-61 | Q&A and polls                                                        |
| 14    | **Others**          | #62-71 | Roles, QR, jobs, invitations                                         |
| 15    | **Role-specific**   | ~80+   | Organizer/exhibitor/volunteer features                               |

---

## 🧩 Code Template — Implementing Any New API

Here's the exact template you'd follow for any new API:

### Step 1: Add Constant

```dart
// In api_constants.dart
static const String myNewEndpoint = '/path/to/endpoint';
```

### Step 2: Create Model (if needed)

```dart
// In lib/features/{feature}/data/models/my_model.dart
class MyModel {
  final String id;
  final String name;

  MyModel({required this.id, required this.name});

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}
```

### Step 3: Add Service Method

```dart
// In lib/features/{feature}/domain/services/my_service.dart
Future<List<MyModel>> getItems() async {
  await _checkConnectivity();
  _logger.i('Fetching items');

  final response = await _apiService.get(ApiConstants.myNewEndpoint);

  if (response.data is Map<String, dynamic>) {
    final data = response.data as Map<String, dynamic>;
    if ((data['success'] as bool? ?? false) && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => MyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }
  return [];
}
```

### Step 4: Register in DI

```dart
// In dependency_injection.dart
Get.lazyPut<MyService>(
  () => MyService(
    apiService: Get.find<ApiService>(),
    connectivityService: Get.find<ConnectivityService>(),
  ),
  fenix: true,
);
```

### Step 5: Create Controller

```dart
// In lib/features/{feature}/presentation/controllers/my_controller.dart
class MyController extends GetxController {
  final MyService _service = Get.find<MyService>();
  final items = <MyModel>[].obs;
  final isLoading = false.obs;

  Future<void> fetchItems() async {
    isLoading.value = true;
    try {
      items.value = await _service.getItems();
    } catch (e) {
      // Handle error with ToastMessageHelper
    } finally {
      isLoading.value = false;
    }
  }
}
```

### Step 6: Wire to UI

```dart
// In your screen widget
final controller = Get.put(MyController());

Obx(() {
  if (controller.isLoading.value) return CircularProgressIndicator();
  return ListView.builder(
    itemCount: controller.items.length,
    itemBuilder: (ctx, i) => Text(controller.items[i].name),
  );
})
```
