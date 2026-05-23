class ApiConstants {

  // static const String baseUrl = 'http://10.10.11.30:8081/api/v1';
  // static const String imageUrl = "http://10.10.11.30:8081";
  // static const String socketServerUrl = 'http://10.10.11.30:8081';

  static const String baseUrl = 'http://api.confaero.com/api/v1';
  static const String imageUrl = "http://api.confaero.com";
  static const String socketServerUrl = 'http://api.confaero.com';


  static Map<String, String> headers = {'Content-Type': 'application/json'};

  //---------------------------Auth-----------------------------
  static const String googleSignIn = '/auth/google';
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refreshTokenApi = '/auth/refresh-token';
  static const String verifiedAccount = '/auth/verified-account';
  static const String newVerificationLink = '/auth/new-verification-link';
  static const String forgetPassword = '/auth/forgot-password';
  static const String verifyResetCode = '/auth/verify-reset-code';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  static const String getMe = '/auth/me';
  static const String deleteAccount = '/auth/delete-account';
  static const String toggleNotification = '/auth/notification';

  //---------------------------User Profile---------------------
  static const String getMyProfile = '/user/my-profile';
  static const String updateProfile = '/user/update-profile';
  static const String deleteResume = '/user/delete-resume';

  //--------------------------Events----------------------------
  static const String getAllUpcomingEvents = '/attendee/events';
  static const String getExploreEvents = '/attendee/events';

  static const String getMyAllEvents = '/attendee/my-events';
  static const String getMyEventsAndInvitations = '/attendee/my-events';

  static const String getEventDetails = '/attendee/events';
  static const String initiateRegistration = '/attendee/events';
  static const String getEventHome = '/attendee/events';
  // REMOVED: getFloorMaps no longer in backend API
  // static const String getFloorMaps = '/organizer/events';

  //--------------------------Connections-------------------------
  static const String sendConnectionRequest = '/connection/request'; // append /:eventId
  static const String acceptConnectionRequest =
      '/connection/requests'; // append /:id/accept
  static const String getPendingRequests = '/connection/requests';


  static const String getMyConnections = '/connection';
  static const String getConnectionDetails = '/connection'; // append /:id
  static const String bookmarkConnection = '/connection'; // append /:id/bookmark

  //--------------------------Attendees---------------------------
  static const String getEventAttendees = '/eventAttendee/events'; // eventId
  static const String getAttendeeDetails = '/eventAttendee/events'; // append /:id
  static const String bookmarkAttendee = '/eventAttendee/events'; // append /:eid/attendees/:aid/bookmark

  //--------------------------Messaging---------------------------
  static const String sendMessage = '/message/send'; // append /:eventId
  static const String getConversations = '/message/conversations'; // append /:eventId
  static const String getMessages = '/message'; // append /:convId/:eventId
  static const String markMessageSeen = '/message/seen'; // append /:msgId/:eventId

  static const String uploadChatAttachment = '/upload/chat-attachment';

  //--------------------------Agenda/Sessions-----------------------
  static const String getEventAgenda = '/organizer-sessions/events'; // append /:id/agenda

  static const String getMyAgenda = '/organizer-sessions/events'; // append /:id/my-agenda

  static const String bookmarkSession = '/organizer-sessions/events'; // append /:id/my-agenda/:idx

  static const String removeBookmarkSession = '/organizer-sessions/events'; // append /:id/my-agenda/:idx

  static const String toggleSessionLike = '/organizer-sessions/agenda'; // append /:id/:idx/toggle-like

  static const String getSessionDetails = '/organizer-sessions/events'; // append /:id/agenda/:idx

  static const String getSpeakerDetails = '/organizer-sessions/events'; // append /:id/speakers/:id

  //--------------------------Announcements-------------------------
  static const String getAnnouncements =
      '/announcement/event'; // append /:eventId
  static const String getOrganizerAnnouncements =
      '/announcement/get-all'; // GET /:eventId
  static const String createAnnouncement = '/announcement'; // POST /:eventId
  static const String updateAnnouncement =
      '/announcement'; // PATCH /:id/:eventId
  static const String deleteAnnouncement =
      '/announcement'; // DELETE /:id/:eventId

  //--------------------------Notes-------------------------------
  static const String createNote = '/note/create';
  static const String getNotes = '/note/notes';
  static const String updateNotes = '/note/create';

  //--------------------------Sponsors----------------------------
  static const String getAllSponsors =
      '/organizerSponsor/all-sponsors'; // append /:eventId
  static const String getSponsorDetails =
      '/organizerSponsor/sponsor'; // append /:id
  static const String incrementSponsorView = '/sponsor/view'; // append /:id

  //--------------------------Documents---------------------------
  static const String getAllDocuments = '/document'; // append /:eventId/all
  static const String getOrganizerDocuments = '/document'; // GET /:eventId (organizer view)
  static const String getMyDocuments = '/document'; // append /:eventId/my
  static const String uploadDocument = '/document'; // append /:eventId
  static const String deleteMyDocument = '/document/my'; // append /:id

  //--------------------------Photos------------------------------
  static const String uploadPhoto = '/photo/events'; // append /:id/photos
  static const String getEventPhotos = '/photo/events'; // append /:id/photos
  static const String getPublicPhotos =
      '/photo/public/events'; // append /:id/photos

  //--------------------------Resources (Q&A/Polls)---------------

  static const String getEventQnA = '/resource/event/qna'; // append /:eventId
  static const String getEventPolls = '/resource/event/poll'; // append /:eventId
  static const String submitPollVote = '/resource/poll'; // append /:id/:eventId/submit


  //--------------------------Resources CRUD (Organizer)----------
  static const String createQnA = '/resource/qna'; // POST /:eventId
  static const String updateQnA = '/resource/qna'; // PATCH /:id/:eventId
  static const String deleteQnA = '/resource/qna'; // DELETE /:id/:eventId
  static const String createPoll = '/resource/poll'; // POST /:eventId
  static const String updatePoll = '/resource/poll'; // PATCH /:id/:eventId
  static const String deletePoll = '/resource/poll'; // DELETE /:id/:eventId
  static const String getPollVotes = '/resource/poll'; // GET /:id/:eventId/votes
  static const String submitSurvey = '/resource/survey'; // POST /:eventId/submit
  static const String getSurveyAnalytics =
      '/resource/survey'; // GET /:eventId/analytics

  //--------------------------Verified Email (Organizer)----------
  // REMOVED: verifyEmail endpoints no longer in backend API
  // static const String getVerifiedEmails = '/verifyEmail/events';
  // static const String addVerifiedEmails = '/verifyEmail/events';
  // static const String uploadEmailsCsv = '/verifyEmail/events';
  // static const String deleteVerifiedEmail = '/verifyEmail/events';

  //--------------------------QR Exhibitor Leads-----------------
  static const String getExhibitorLeads = '/qr/exhibitor'; // GET /:id/leads
  static const String addLeadNote = '/qr/exhibitor/leads'; // PATCH /:id/note
  static const String tagLead = '/qr/exhibitor/leads'; // PATCH /:id/tags

  //--------------------------Organizer Attendee Management------
  // REMOVED: organizer attendee management endpoints no longer in backend API
  // static const String getOrganizerAttendeeDetail = '/organizer/attendee';
  // static const String removeOrganizerAttendee = '/organizer/attendee';
  // static const String getAllRegistrations = '/organizer/all-register';

  //--------------------------Event Registration-------------------
  static const String getMyEventDetails = '/attendee/my-events'; // append /:id
  static const String getEventSessions =
      '/attendee/events'; // append /:id/sessions
  static const String joinEvent = '/attendee/event'; // PATCH /:eventId/join

  //--------------------------Roles---------------------------------
  static const String changeRole = '/auth/change-role';
  static const String getMyRoles = '/auth/my-roles';

  //--------------------------Terms & Content-----------------------
  // REMOVED: appContent endpoints no longer in backend API
  // static const String getTermsCondition = '/appContent/TERMS_CONDITION';

  //--------------------------QR Code-------------------------------
  static const String generateQR = '/qr/generate'; // append /:eventId
  static const String scanQR = '/qr/scan'; // append /:eventId
  static const String getVolunteerAttendance = '/qr/volunteer'; // GET /:eventId

  //--------------------------Jobs----------------------------------
  static const String getJobs = '/job';
  static const String getJobDetails = '/job'; // append /:id

  //--------------------------Invitations---------------------------
  static const String getMyInvitations =
      '/invitation/my-invitations'; // append /:eventId
  static const String acceptInvitation =
      '/invitation'; // append /:id/accept/:eventId
  static const String rejectInvitation =
      '/invitation'; // append /:id/reject/:eventId
  static const String createInvitation =
      '/invitation/create'; // POST /:eventId
  static const String deleteInvitation =
      '/invitation'; // DELETE /:id/:eventId
  static const String resendInvitation =
      '/invitation'; // POST /:id/resend/:eventId
  static const String makeSpeaker =
      '/invitation'; // POST /:id/make-speaker
  static const String getOrganizerInvitations =
      '/invitation/event'; // GET /:eventId
  static const String getInvitationSessions =
      '/invitation'; // GET /:eventId/sessions

  // ======================== ROLE-SPECIFIC APIs ========================

  //--------------------------Organizer Sessions-----------------------
  // REMOVED: session CRUD endpoints no longer in backend API
  // static const String createSession = '/organizer-sessions/events';
  // static const String updateSession = '/organizer-sessions/events';
  // static const String deleteSession = '/organizer-sessions/events';

  static const String addSpeaker = '/organizer-sessions/events'; // POST /:id/agenda/:idx/speakers/:speakerId
  static const String removeSpeaker = '/organizer-sessions/events'; // DELETE /:id/agenda/:idx/speakers/:speakerId

  static const String searchSpeakerByEmail =
      '/organizer-sessions/event'; // GET /:eventId/speakers/search

  //--------------------------Booth (Organizer)------------------------
  static const String getOrganizerBooths =
      '/organizerBooth/events'; // GET /:eventId/booths
  static const String getBoothDetails = '/organizerBooth/booths'; // GET /:id
  static const String updateBoothNumber =
      '/organizerBooth/booths'; // PATCH /:id/number
  static const String acceptBooth =
      '/organizerBooth/booths'; // PATCH /:id/accept
  static const String cancelBooth =
      '/organizerBooth/booths'; // PATCH /:id/cancel

  ///--------------------------Booth (Exhibitor)------------------------

  static const String getMyBooth = '/booth/me';   // eventId
  static const String updateMyBooth = '/booth/me'; // eventId
  static const String createBooth = '/booth/create';
  static const String addBoothStaff = '/booth/staff'; // eventId
  static const String getBoothStaff = '/booth/staff'; // eventId
  static const String getAnalytics = '/booth/analytics'; // eventId
  static const String getPerformance = '/exhibitor/performance'; // eventId

  //--------------------------Sponsor Dashboard------------------------


  static const String createSponsor = '/sponsor/create';
  static const String updateSponsor = '/sponsor/update'; // PATCH /:id
  static const String getMySponsor = '/sponsor/get-my-sponsor'; // GET /:eventId
  static const String getSponsorDashboard = '/sponsor/dashboard'; // GET /:eventId

  static const String incrementView = '/sponsor/view'; // PATCH /: id



  static const String approveSponsor = '/organizerSponsor'; // PATCH /:id/approve
  static const String rejectSponsor = '/organizerSponsor'; // PATCH /:id/reject

  //--------------------------Poster----------------------------------
  static const String uploadPosterFile = '/poster/upload-file';
  static const String uploadPosterFiles = '/poster/upload-files';
  static const String getRevisedPosters = '/poster/revised';
  static const String updatePosterAttachment = '/poster/author/attachments'; // PATCH /:id

  static const String createPoster = '/poster/create'; // POST /:eventId
  static const String getAcceptedPosters = '/poster/accepted';
  static const String getSinglePoster = '/poster/accepted'; // GET /:id

  //--------------------------Poster Assign----------------------------
  static const String assignPoster = '/poster-assign/create'; // POST /:eventId
  static const String sendPosterReminder =
      '/poster-assign/send-reminder'; // POST /:id
  static const String searchReviewer =
      '/poster-assign/speakers/search'; // GET /:eventId
  static const String searchUnassigned =
      '/poster-assign/unassigned/search'; // GET /:eventId
  static const String reassignPoster =
      '/poster-assign/reassign'; // POST /:eventId
  static const String getUnassignedPosters =
      '/poster-assign/unassigned'; // GET /:eventId
  static const String getAssignedPosters =
      '/poster-assign/assigned'; // GET /:eventId
  static const String getReportedPosters =
      '/poster-assign/reported'; // GET /:eventId

  //--------------------------Reviewer---------------------------------
  static const String getReviewerDashboard = '/reviewer/dashboard'; // GET /:eventId
  static const String getReviewerAuthors = '/reviewer/authors'; // GET /:eventId
  static const String getAuthorSubmissions = '/reviewer/authors'; // GET /:id/submissions
  static const String getAttachmentDetails = '/reviewer/attachments'; // GET /:id
  static const String approveAttachment = '/reviewer/attachments'; // PATCH /:id/approve
  static const String rejectAttachment = '/reviewer/attachments'; // PATCH /:id/reject
  static const String reviseAttachment = '/reviewer/attachments'; // PATCH /:id/revise
  static const String flagAttachmentAdmin = '/reviewer/attachments'; // PATCH /:id/flag-admin
  static const String reviewPosterImage = '/reviewer/attachments'; // POST /:id/image-review
  static const String rejectPoster = '/reviewer/attachments'; // POST /:id

  //--------------------------Volunteer/Task----------------------------
  static const String createTask = '/volunteer/create';

  static const String getMyTasks = '/volunteer/my-tasks'; //enum: ["ASSIGNED", "COMPLETED", "REPORTED"],
  static const String getTaskDetail = '/volunteer/my-task'; // GET /:id
  static const String getTodayProgress = '/volunteer/today-progress';
  static const String submitReport = '/report/report'; // post
  static const String completeTask = '/volunteer'; // PATCH /:id/complete




  static const String searchVolunteer = '/volunteer'; // GET /:eventId/volunteer/search
  static const String getVolunteerDashboard = '/volunteer/volunteers';
  static const String getReportDetail = '/volunteer'; // GET /:id



  //--------------------------Video Conference--------------------------
  static const String getLiveSession = '/eventLive/live'; // GET /:eventId
  static const String startLiveSession = '/eventLive/start'; // POST /:eventId
  static const String joinLiveSession = '/eventLive/join'; // POST /:eventId
  static const String endLiveSession = '/eventLive/end'; // POST /:eventId

  //--------------------------Organizer Messaging-----------------------
  // REMOVED: messageOrganizer endpoints no longer in backend API
  // static const String sendOrganizerMessage = '/messageOrganizer/send';
  // static const String getOrganizerConversations = '/messageOrganizer/conversations';
  // static const String getOrganizerMessages = '/messageOrganizer/messages';
  // static const String getOrganizerPresence = '/messageOrganizer/presence';
  // static const String markOrganizerSeen = '/messageOrganizer/seen';
  // static const String getOrganizerNotifications = '/messageOrganizer/notifications';

  //--------------------------Document (Organizer)---------------------

  static const String getAllPublicDocuments = '/document'; // GET /:eventId/all
  static const String getDocumentDetails = '/document'; // GET /:eventId/details/:id


  //--------------------------Photo (Delete)----------------------------
  static const String deletePhoto = '/photo/photos'; // DELETE /:id

  //--------------------------Job (Organizer/Exhibitor)------------------
  static const String createJob = '/job';
  static const String getMyJobPosts = '/job/my';
  static const String getJobReview = '/job/review';
  static const String updateJobStatus = '/job'; // PATCH /:id/status
  static const String updateJob = '/job'; // PATCH /:id
  static const String deleteJob = '/job'; // DELETE /:id

  //--------------------------App Content-------------------------------
  // REMOVED: appContent create endpoint no longer in backend API
  // static const String createAppContent = '/appContent/create';


  static const String getAppContent = '/appContent'; //  //  | "ORGANIZER_GUIDELINE"//   | "TERMS_CONDITION"//   | "PRIVACY_POLICY"
}
