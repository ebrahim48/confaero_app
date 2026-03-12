import 'connection_model.dart';

class ConnectionRequestModel {
  final String id;
  final ConnectionModel sender;
  final String status;
  final String eventId;

  ConnectionRequestModel({
    required this.id,
    required this.sender,
    required this.status,
    required this.eventId,
  });

  factory ConnectionRequestModel.fromJson(Map<String, dynamic> json) {
    return ConnectionRequestModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      sender: ConnectionModel.fromJson(
        json['sender'] as Map<String, dynamic>? ?? {},
      ),
      status: json['status']?.toString() ?? 'PENDING',
      eventId: json['event']?.toString() ?? '',
    );
  }
}
