# Full API Audit — api.json vs Implementation

**Source:** [api.json](file:///Users/Jahid/SPARKTECH/confaero_app/api.json) (Postman collection with 218 requests, 198 unique endpoints)

## Coverage Summary

| Category                                                                                                                         | Count         |
| -------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| **Total unique endpoints**                                                                                                       | 198           |
| **Covered** in [api_constants.dart](file:///Users/Jahid/SPARKTECH/confaero_app/lib/core/constants/api_constants.dart) + services | **167** (84%) |
| **Not covered**                                                                                                                  | **31** (16%)  |

## ✅ Covered Categories (167 endpoints)

Auth, User Profile, Events, Connections, Attendees, Messaging, Agenda/Sessions, Announcements (get), Notes, Sponsors, Documents, Photos, Resources (get/vote), QR, Jobs, Invitations, Organizer Sessions, Booth, Sponsor Dashboard, Poster, Poster Assign, Reviewer, Volunteer, Video Conference, Organizer Messaging, App Content.

## ⚠️ 31 Missing Endpoints (NOT in api_constants.dart or services)

### 1. Super Admin (13 endpoints) — Admin panel, not needed in mobile app

| Method | Path                                    | Description                                                                                                                                                  |
| ------ | --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| POST   | `/superAdmin/create/organizer`          | Create organizer account                                                                                                                                     |
| POST   | `/superAdmin/create/event`              | Create event                                                                                                                                                 |
| GET    | `/superAdmin/users`                     | List all users                                                                                                                                               |
| GET    | `/superAdmin/users/:id`                 | User details                                                                                                                                                 |
| GET    | `/superAdmin/organizers`                | List organizers                                                                                                                                              |
| GET    | `/superAdmin/organizers/:id/events`     | Organizer's events                                                                                                                                           |
| GET    | `/superAdmin/organizers/:id/events/:id` | Single event by organizer                                                                                                                                    |
| GET    | `/superAdmin/events`                    | All events (already covered by [getExploreEvents](file:///Users/Jahid/SPARKTECH/confaero_app/lib/features/Events/domain/services/events_service.dart#59-84)) |
| GET    | `/superAdmin/singleEvent/:id/overview`  | Event overview                                                                                                                                               |
| GET    | `/superAdmin/dashboard/overview`        | Dashboard stats                                                                                                                                              |
| DELETE | `/superAdmin/users/suspend`             | Suspend user                                                                                                                                                 |

### 2. Announcement CRUD — Organizer (3 endpoints)

| Method | Path                         | Description         |
| ------ | ---------------------------- | ------------------- |
| POST   | `/announcement/:eventId`     | Create announcement |
| PATCH  | `/announcement/:id/:eventId` | Update announcement |
| DELETE | `/announcement/:id/:eventId` | Delete announcement |

> **Note:** `GET /announcement/event/:eventId` is already covered. Only create/update/delete are missing.

### 3. Resource CRUD — Organizer (5 endpoints)

| Method | Path                                 | Description      |
| ------ | ------------------------------------ | ---------------- |
| POST   | `/resouce/qna/:eventId`              | Create Q&A       |
| PATCH  | `/resouce/qna/:id/:eventId`          | Update Q&A       |
| DELETE | `/resouce/qna/:id/:eventId`          | Delete Q&A       |
| POST   | `/resouce/survey/:eventId/submit`    | Submit survey    |
| GET    | `/resouce/survey/:eventId/analytics` | Survey analytics |

### 4. Verified Email / Email Invite (3 endpoints)

| Method | Path                                 | Description           |
| ------ | ------------------------------------ | --------------------- |
| GET    | `/verifyEmail/events/:id`            | Get verified emails   |
| POST   | `/verifyEmail/events/:id/add-emails` | Add emails            |
| POST   | `/verifyEmail/events/:id/upload-csv` | Upload CSV of emails  |
| DELETE | `/verifyEmail/events/:id/:id`        | Delete verified email |

### 5. QR Exhibitor Leads (3 endpoints)

| Method | Path                           | Description       |
| ------ | ------------------------------ | ----------------- |
| GET    | `/qr/exhibitor/:id/leads`      | Get scanned leads |
| PATCH  | `/qr/exhibitor/leads/:id/note` | Add note to lead  |
| PATCH  | `/qr/exhibitor/leads/:id/tags` | Tag a lead        |

### 6. Organizer Attendee Management (2 endpoints)

| Method | Path                               | Description          |
| ------ | ---------------------------------- | -------------------- |
| GET    | `/organizer/attendee/:eventId/:id` | Get attendee details |
| DELETE | `/organizer/attendee/:eventId/:id` | Remove attendee      |
| GET    | `/organizer/all-register/:eventId` | All registrations    |

### 7. Other (2 endpoints)

| Method | Path                                            | Description                 |
| ------ | ----------------------------------------------- | --------------------------- |
| GET    | `/organizer-sessions/event/:id/speakers/search` | Search speakers             |
| POST   | `/organizer/organizers/:id/stripe/connect`      | Stripe connect              |
| GET    | `/announcement/get-all/:id`                     | Get all announcements (alt) |

## Recommendation

| Category                    | Priority  | Reason                                         |
| --------------------------- | --------- | ---------------------------------------------- |
| Super Admin (13)            | ❌ Skip   | These are admin-panel APIs, not for mobile app |
| Announcement CRUD (3)       | 🟡 Medium | Organizers need to create/edit announcements   |
| Resource CRUD (5)           | 🟡 Medium | Organizers need to create Q&A/polls/surveys    |
| Verified Email (4)          | 🟡 Medium | Organizer feature for managing invites         |
| QR Exhibitor Leads (3)      | 🟢 High   | Exhibitors scanning leads at booths            |
| Organizer Attendee Mgmt (3) | 🟡 Medium | Manage event attendees                         |

**Bottom line:** 167 of 198 endpoints are implemented. The 31 missing are mostly organizer CRUD operations and super-admin APIs. If we exclude the 13 super-admin endpoints (not for mobile), only **18 endpoints remain unimplemented**.

**exclude the 13 super-admin APIs (not for mobile), only 18 endpoints remain unimplemented**
