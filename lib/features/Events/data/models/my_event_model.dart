import 'event_model.dart';

/// Wraps the my-events API response:
/// { "event": { ...EventModel... }, "status": "VERIFIED" | "PENDING" }
class MyEventModel {
  final EventModel event;
  final String status;

  MyEventModel({required this.event, required this.status});

  factory MyEventModel.fromJson(Map<String, dynamic> json) {
    return MyEventModel(
      event: EventModel.fromJson(json['event'] as Map<String, dynamic>),
      status: json['status'] as String? ?? '',
    );
  }

  bool get isVerified => status == 'VERIFIED';
  bool get isPending => status == 'PENDING';
}