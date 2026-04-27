class ReviewerDashboardModel {
  final int totalAbstracts;
  final int totalPosters;
  final int totalAssigned;
  final int reviewed;
  final int remaining;
  final double progress;
  final List<LatestDocumentModel> latestDocuments;

  ReviewerDashboardModel({
    required this.totalAbstracts,
    required this.totalPosters,
    required this.totalAssigned,
    required this.reviewed,
    required this.remaining,
    required this.progress,
    required this.latestDocuments,
  });

  factory ReviewerDashboardModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as Map<String, dynamic>? ?? {};
    return ReviewerDashboardModel(
      totalAbstracts: (summary['totalAbstracts'] as num?)?.toInt() ?? 0,
      totalPosters: (summary['totalPosters'] as num?)?.toInt() ?? 0,
      totalAssigned: (summary['totalAssigned'] as num?)?.toInt() ?? 0,
      reviewed: (summary['reviewed'] as num?)?.toInt() ?? 0,
      remaining: (summary['remaining'] as num?)?.toInt() ?? 0,
      progress: (summary['progress'] as num?)?.toDouble() ?? 0,
      latestDocuments: (json['latestDocuments'] as List? ?? [])
          .map((e) => LatestDocumentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  double get progressFraction => totalAssigned == 0 ? 0 : reviewed / totalAssigned;
}

class LatestDocumentModel {
  final String attachmentId;
  final String type;
  final String title;
  final String reviewStatus;
  final String assignedAt;
  final String url;
  final String authorName;
  final String authorAvatar;

  LatestDocumentModel({
    required this.attachmentId,
    required this.type,
    required this.title,
    required this.reviewStatus,
    required this.assignedAt,
    required this.url,
    required this.authorName,
    required this.authorAvatar,
  });

  factory LatestDocumentModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>? ?? {};
    return LatestDocumentModel(
      attachmentId: json['attachmentId']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      reviewStatus: json['reviewStatus']?.toString() ?? '',
      assignedAt: json['assignedAt']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      authorName: author['name']?.toString() ?? '',
      authorAvatar: author['avatar']?.toString() ?? '',
    );
  }
}

class AuthorModel {
  final String authorId;
  final String name;
  final String avatar;
  final String role;
  final int totalFiles;
  final int pending;
  final String lastSubmittedAt;

  AuthorModel({
    required this.authorId,
    required this.name,
    required this.avatar,
    required this.role,
    required this.totalFiles,
    required this.pending,
    required this.lastSubmittedAt,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>? ?? {};
    return AuthorModel(
      authorId: json['authorId']?.toString() ?? '',
      name: author['name']?.toString() ?? '',
      avatar: author['avatar']?.toString() ?? '',
      role: author['role']?.toString() ?? '',
      totalFiles: (json['totalFiles'] as num?)?.toInt() ?? 0,
      pending: (json['pending'] as num?)?.toInt() ?? 0,
      lastSubmittedAt: json['lastSubmittedAt']?.toString() ?? '',
    );
  }
}

class SubmissionModel {
  final String attachmentId;
  final String authorId;
  final String title;
  final String type;
  final String fileUrl;
  final int size;
  final String uploadedAt;
  final String reviewStatus;
  final String authorName;
  final String authorAvatar;
  final String authorRole;
  final String dueDate;

  SubmissionModel({
    required this.attachmentId,
    this.authorId = '',
    required this.title,
    required this.type,
    required this.fileUrl,
    required this.size,
    required this.uploadedAt,
    required this.reviewStatus,
    required this.authorName,
    required this.authorAvatar,
    required this.authorRole,
    required this.dueDate,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>? ?? {};
    return SubmissionModel(
      attachmentId: json['attachmentId']?.toString() ?? '',
      authorId: json['authorId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      fileUrl: json['fileUrl']?.toString() ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      uploadedAt: json['uploadedAt']?.toString() ?? '',
      reviewStatus: json['reviewStatus']?.toString() ?? '',
      authorName: author['name']?.toString() ?? '',
      authorAvatar: author['avatar']?.toString() ?? '',
      authorRole: author['role']?.toString() ?? '',
      dueDate: json['dueDate']?.toString() ?? '',
    );
  }

  SubmissionModel copyWith({String? authorId}) => SubmissionModel(
        attachmentId: attachmentId,
        authorId: authorId ?? this.authorId,
        title: title,
        type: type,
        fileUrl: fileUrl,
        size: size,
        uploadedAt: uploadedAt,
        reviewStatus: reviewStatus,
        authorName: authorName,
        authorAvatar: authorAvatar,
        authorRole: authorRole,
        dueDate: dueDate,
      );

  bool get isPoster => type == 'image';
  bool get isAbstract => type == 'pdf';
  String get sizeLabel {
    if (size == 0) return '';
    final mb = size / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }
}

class AttachmentDetailModel {
  final String attachmentId;
  final String title;
  final String type;
  final String fileUrl;
  final String reviewStatus;
  final String uploadedAt;
  final String dueDate;
  final String authorName;
  final String authorAvatar;
  final String authorRole;

  AttachmentDetailModel({
    required this.attachmentId,
    required this.title,
    required this.type,
    required this.fileUrl,
    required this.reviewStatus,
    required this.uploadedAt,
    required this.dueDate,
    required this.authorName,
    required this.authorAvatar,
    required this.authorRole,
  });

  factory AttachmentDetailModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>? ?? {};
    return AttachmentDetailModel(
      attachmentId: json['attachmentId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      fileUrl: json['fileUrl']?.toString() ?? '',
      reviewStatus: json['reviewStatus']?.toString() ?? '',
      uploadedAt: json['uploadedAt']?.toString() ?? '',
      dueDate: json['dueDate']?.toString() ?? '',
      authorName: author['name']?.toString() ?? '',
      authorAvatar: author['avatar']?.toString() ?? '',
      authorRole: author['role']?.toString() ?? '',
    );
  }

  bool get isPoster => type == 'image';
}
