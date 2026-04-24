import 'event_model.dart';

/// Wraps the my-events API response:
/// { "event": { ...EventModel... }, "status": "VERIFIED" | "PENDING" }
class MyEventModel {
  final EventModel event;
  final String status;
  final String role;

  MyEventModel({required this.event, required this.status, this.role = ''});

  factory MyEventModel.fromJson(Map<String, dynamic> json) {
    return MyEventModel(
      event: EventModel.fromJson(json['event'] as Map<String, dynamic>),
      status: json['status'] as String? ?? '',
      role: (json['role'] ?? json['activeRole']) as String? ?? '',
    );
  }

  bool get isVerified => status == 'VERIFIED';
  bool get isPending => status == 'PENDING';
}