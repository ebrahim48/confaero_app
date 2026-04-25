class TaskModel {
  final String id;
  final String eventId;
  final String title;
  final String startDate;
  final String endDate;
  final String location;
  final String instruction;
  final String referenceImage;
  final String status;
  final TaskCreatedByModel createdBy;
  final String createdAt;
  final String updatedAt;

  TaskModel({
    required this.id,
    required this.eventId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.instruction,
    required this.referenceImage,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    // Support both new (startDate/endDate) and old (date/time) formats
    final startDate = json['startDate']?.toString() ??
        _buildDateTime(json['date']?.toString(), json['time']?.toString());
    final endDate = json['endDate']?.toString() ?? '';
    return TaskModel(
      id: json['_id']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      startDate: startDate,
      endDate: endDate,
      location: json['location']?.toString() ?? '',
      instruction: json['instruction']?.toString() ?? '',
      referenceImage: json['referenceImage']?.toString() ?? '',
      status: json['status']?.toString() ?? 'PENDING',
      createdBy: TaskCreatedByModel.fromJson(
          json['createdBy'] as Map<String, dynamic>? ?? {}),
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  static String _buildDateTime(String? date, String? time) {
    if (date == null || date.isEmpty) return '';
    if (time == null || time.isEmpty) return date;
    return '${date}T$time';
  }

  bool get isActive => status == 'PENDING' || status == 'IN_PROGRESS' || status == 'DUE';
}

class TaskCreatedByModel {
  final String id;
  final String email;
  final String activeRole;

  TaskCreatedByModel({
    required this.id,
    required this.email,
    required this.activeRole,
  });

  factory TaskCreatedByModel.fromJson(Map<String, dynamic> json) =>
      TaskCreatedByModel(
        id: json['_id']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        activeRole: json['activeRole']?.toString() ?? '',
      );
}

class TaskDetailModel {
  final String taskId;
  final String title;
  final String startDate;
  final String endDate;
  final String location;
  final String instruction;
  final String referenceImage;
  final String status;
  final TaskOrganizerModel createdBy;
  final String createdAt;

  TaskDetailModel({
    required this.taskId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.instruction,
    required this.referenceImage,
    required this.status,
    required this.createdBy,
    required this.createdAt,
  });

  factory TaskDetailModel.fromJson(Map<String, dynamic> json) {
    final startDate = json['startDate']?.toString() ??
        TaskModel._buildDateTime(json['date']?.toString(), json['time']?.toString());
    final endDate = json['endDate']?.toString() ?? '';
    return TaskDetailModel(
      taskId: json['taskId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      startDate: startDate,
      endDate: endDate,
      location: json['location']?.toString() ?? '',
      instruction: json['instruction']?.toString() ?? '',
      referenceImage: json['referenceImage']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdBy: TaskOrganizerModel.fromJson(
          json['createdBy'] as Map<String, dynamic>? ?? {}),
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

class TaskOrganizerModel {
  final String email;
  final String name;
  final String photo;
  final String role;

  TaskOrganizerModel({
    required this.email,
    required this.name,
    required this.photo,
    required this.role,
  });

  factory TaskOrganizerModel.fromJson(Map<String, dynamic> json) =>
      TaskOrganizerModel(
        email: json['email']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        photo: json['photo']?.toString() ?? '',
        role: json['role']?.toString() ?? '',
      );
}

class TodayProgressModel {
  final int totalTasks;
  final int completedTasks;
  final int remainingTasks;
  final double progress;

  TodayProgressModel({
    required this.totalTasks,
    required this.completedTasks,
    required this.remainingTasks,
    required this.progress,
  });

  factory TodayProgressModel.fromJson(Map<String, dynamic> json) =>
      TodayProgressModel(
        totalTasks: (json['totalTasks'] as num?)?.toInt() ?? 0,
        completedTasks: (json['completedTasks'] as num?)?.toInt() ?? 0,
        remainingTasks: (json['remainingTasks'] as num?)?.toInt() ?? 0,
        progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      );

  double get progressFraction =>
      totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
}

class CheckInHistoryModel {
  final int totalCheckedIn;
  final List<LastScanModel> lastScans;

  CheckInHistoryModel({
    required this.totalCheckedIn,
    required this.lastScans,
  });

  factory CheckInHistoryModel.fromJson(Map<String, dynamic> json) =>
      CheckInHistoryModel(
        totalCheckedIn: (json['totalCheckedIn'] as num?)?.toInt() ?? 0,
        lastScans: (json['lastScans'] as List? ?? [])
            .map((e) => LastScanModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class LastScanModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String scannedAt;
  final String avatar;

  LastScanModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.scannedAt,
    required this.avatar,
  });

  factory LastScanModel.fromJson(Map<String, dynamic> json) => LastScanModel(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        role: json['role']?.toString() ?? '',
        scannedAt:
            json['scannedAt']?.toString() ?? json['time']?.toString() ?? '',
        avatar:
            json['avatar']?.toString() ?? json['photo']?.toString() ?? '',
      );
}
