class DocumentModel {
  final String id;
  final String documentType;
  final String documentUrl;
  final String createdAt;

  DocumentModel({
    required this.id,
    required this.documentType,
    required this.documentUrl,
    required this.createdAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['_id']?.toString() ?? '',
      documentType: json['documentType']?.toString() ?? '',
      documentUrl: json['documentUrl']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

class DocumentDetailsModel {
  final String id;
  final String eventId;
  final String documentType;
  final String documentUrl;
  final String documentName;
  final String status;
  final String createdAt;
  final String uploadedByEmail;
  final String uploadedByRole;

  DocumentDetailsModel({
    required this.id,
    required this.eventId,
    required this.documentType,
    required this.documentUrl,
    required this.documentName,
    required this.status,
    required this.createdAt,
    required this.uploadedByEmail,
    required this.uploadedByRole,
  });

  factory DocumentDetailsModel.fromJson(Map<String, dynamic> json) {
    final uploadedBy = json['uploadedBy'] as Map<String, dynamic>? ?? {};
    return DocumentDetailsModel(
      id: json['_id']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? '',
      documentType: json['documentType']?.toString() ?? '',
      documentUrl: json['documentUrl']?.toString() ?? '',
      documentName: json['documentName']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      uploadedByEmail: uploadedBy['email']?.toString() ?? '',
      uploadedByRole: uploadedBy['activeRole']?.toString() ?? '',
    );
  }
}
