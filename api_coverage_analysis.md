# API Coverage Analysis — Confaero App

## Summary

| Metric | Count |
|---|---|
| **Total API endpoints in Postman** | 218 |
| **Implemented in app** | 13 |
| **Not implemented** | ~205 |
| **Coverage** | **~6%** |

---

## ✅ Implemented APIs (13 total)

| # | Category | Endpoint | Method | File |
|---|---|---|---|---|
| 1 | Auth | `/auth/register` | POST | [auth_repository.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/auth/data/repositories/auth_repository.dart) |
| 2 | Auth | `/auth/login` | POST | [auth_repository.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/auth/data/repositories/auth_repository.dart) |
| 3 | Auth | `/auth/forgot-password` | POST | [forget_password_controller.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/auth/presentation/forget/controllers/forget_password_controller.dart) |
| 4 | Auth | `/auth/verify-reset-code` | POST | [verify_controller.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/auth/presentation/verify/controllers/verify_controller.dart) |
| 5 | Auth | `/auth/reset-password` | POST | [reset_password_controller.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/auth/presentation/reset/controllers/reset_password_controller.dart) |
| 6 | Events | `/attendee/events` (upcoming) | GET | [events_service.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/Events/domain/services/events_service.dart) |
| 7 | Events | `/superAdmin/events` (explore) | GET | [events_service.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/Events/domain/services/events_service.dart) |
| 8 | Events | `/attendee/my-event` | GET | [events_service.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/Events/domain/services/events_service.dart) |
| 9 | Events | `/attendee/events/:id` (details) | GET | [events_service.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/Events/domain/services/events_service.dart) |
| 10 | Events | `/attendee/events/:id/initiate-registration` | POST | [events_service.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/Events/domain/services/events_service.dart) |
| 11 | Events | `/attendee/events/:id/home` | GET | [events_service.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/Events/domain/services/events_service.dart) |
| 12 | Attendees | `/organizer/events/:id/floormaps` | GET | [floor_map_service.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/attendees/domain/floor_map_service.dart) |
| 13 | Auth | `/auth/forgot-password` (resend) | POST | [verify_controller.dart](file:///c:/Users/jahid/SPARKTECH/confaero_app/lib/features/auth/presentation/verify/controllers/verify_controller.dart) |

---

## ❌ Not Implemented — By Category & Priority

### 🔴 HIGH PRIORITY — Core Attendee Features

These are essential for a working attendee experience:

| Endpoint | Method | Purpose |
|---|---|---|
| `/auth/change-password` | POST | Change password from settings |
| `/auth/refresh-token` | POST | Keep sessions alive (token refresh) |
| `/auth/me` | GET | Get current user profile |
| `/auth/delete-account` | DELETE | Account deletion (App Store requirement) |
| `/auth/notification` | PATCH | Toggle email notifications |
| `/user/my-profile` | GET | Get full user profile with details |
| `/user/update-profile` | PATCH | Update profile (name, bio, avatar, resume, etc) |
| `/user/delete-resume` | DELETE | Remove resume from profile |
| `/attendee/my-events/:id` | GET | Get a specific registered event |
| `/attendee/events/:id/register` | POST | Register for an event |
| `/attendee/events/:id/sessions` | GET | Get sessions for an event |

### 🟠 MEDIUM PRIORITY — Social & Engagement Features

| Category | Endpoint | Method | Purpose |
|---|---|---|---|
| **Connection** | `/connection/request/:eventId` | POST | Send connection request |
| **Connection** | `/connection/requests/:id/accept` | PATCH | Accept request |
| **Connection** | `/connection/requests` | GET | See all pending requests |
| **Connection** | `/connection` | GET | My connections list |
| **Connection** | `/connection/:id` | GET | Connection details |
| **Connection** | `/connection/:id/bookmark` | PATCH | Bookmark a connection |
| **Attendees** | `/eventAttendee/events/:id/attendees` | GET | Event attendee list |
| **Attendees** | `/eventAttendee/events/:id/attendees/:id` | GET | Attendee details |
| **Attendees** | `/eventAttendee/events/:eid/attendees/:aid/bookmark` | PATCH | Bookmark attendee |
| **Message** | `/message/send/:eventId` | POST | Send message |
| **Message** | `/message/conversations/:eventId` | GET | Get conversations |
| **Message** | `/message/:convId/:eventId` | GET | Get messages in conversation |
| **Message** | `/message/seen/:msgId/:eventId` | PATCH | Mark message as seen |
| **Upload** | `/upload/chat-attachment` | POST | Upload chat attachments |

### 🟡 MEDIUM PRIORITY — Content & Resources

| Category | Endpoint | Method | Purpose |
|---|---|---|---|
| **Agenda** | `/organizer-sessions/events/:id/agenda` | GET | Full event agenda |
| **Agenda** | `/organizer-sessions/events/:id/my-agenda` | GET | My bookmarked agenda |
| **Agenda** | `/organizer-sessions/events/:id/my-agenda/:idx` | POST | Bookmark agenda session |
| **Agenda** | `/organizer-sessions/events/:id/my-agenda/:idx` | DELETE | Remove bookmark |
| **Agenda** | `/organizer-sessions/agenda/:id/:idx/toggle-like` | PATCH | Like/unlike session |
| **Agenda** | `/organizer-sessions/events/:id/agenda/:idx` | GET | Session details |
| **Agenda** | `/organizer-sessions/events/:id/speakers/:id` | GET | Speaker details |
| **Announcement** | `/announcement/event/:eventId` | GET | Event announcements |
| **Notes** | `/note/create` | POST | Create/update note |
| **Notes** | `/note/notes` | GET | Get all notes |
| **Sponsors** | `/organizerSponsor/all-sponsors/:eventId` | GET | All sponsors |
| **Sponsors** | `/organizerSponsor/sponsor/:id` | GET | Sponsor details |
| **Sponsors** | `/sponsor/view/:id` | PATCH | Increment sponsor views |
| **Docs** | `/document/:eventId/all` | GET | All public documents |
| **Docs** | `/document/:eventId/my` | GET | My documents |
| **Docs** | `/document/:eventId` | POST | Upload document |
| **Docs** | `/document/my/:id` | DELETE | Delete my document |
| **Photos** | `/photo/events/:id/photos` | POST | Upload photo |
| **Photos** | `/photo/events/:id/photos` | GET | Get event photos |
| **Photos** | `/photo/public/events/:id/photos` | GET | Public event photos |
| **Resources** | `/resouce/event/qna/:eventId` | GET | Q&A for event |
| **Resources** | `/resouce/event/poll/:eventId` | GET | Polls for event |
| **Resources** | `/resouce/poll/:id/:eventId/submit` | POST | Submit poll vote |

### 🟢 LOW PRIORITY — Role-specific Features (not attendee)

| Category | Count | Roles |
|---|---|---|
| **Super Admin** | 12 endpoints | SUPER_ADMIN |
| **Organizer** | ~20 endpoints | ORGANIZER |
| **Booth/Exhibitor** | 8 endpoints | EXHIBITOR |
| **Sponsor actions** | 8 endpoints | SPONSOR |
| **Poster/Reviewer** | 20+ endpoints | ABSTRACT_REVIEWER |
| **Volunteer/Task** | 9 endpoints | VOLUNTEER |
| **Video Conference** | 4 endpoints | SPEAKER/ORGANIZER |
| **Organizer Message** | 6 endpoints | ORGANIZER |

### ⚪ OTHER

| Endpoint | Method | Purpose |
|---|---|---|
| `/auth/change-role` | POST | Switch active role |
| `/auth/my-roles` | GET | Get user's available roles |
| `/appContent/TERMS_CONDITION` | GET | App terms & conditions |
| `/qr/generate/:eventId` | GET | Generate QR for event |
| `/qr/scan/:eventId` | POST | Scan QR code |
| `/job/` | GET | Public job listings |
| `/job/:id` | GET | Job details |
| `/invitation/my-invitations/:eventId` | GET | My invitations |
| `/invitation/:id/accept/:eventId` | PATCH | Accept invitation |
| `/invitation/:id/reject/:eventId` | PATCH | Reject invitation  |

---

## Recommended Implementation Order

> [!IMPORTANT]
> The app currently has **UI screens** for many of these features (profile, settings, messages, connections, agenda, sponsors, etc.), but they are using **dummy/mock data**. The screens exist — they just need to be wired up to real API calls.

1. **🔴 Auth completion** — `refresh-token`, `change-password`, `delete-account`, `me` (profile)
2. **🔴 User profile** — `my-profile`, `update-profile`
3. **🟠 Connections & Attendees** — Social networking features
4. **🟠 Messaging** — Real-time chat with Socket.IO + API
5. **🟡 Agenda & Sessions** — Bookmarking, likes, session details
6. **🟡 Announcements & Notes** — Content consumption
7. **🟡 Sponsors, Docs, Photos** — Event content
8. **🟢 Role-specific** — Organizer, exhibitor, etc. features
