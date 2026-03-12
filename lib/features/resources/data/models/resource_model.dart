class QnAModel {
  final String id;
  final String question;
  final String answer;
  final String eventId;
  final String askerId;
  final int votes;
  final String createdAt;

  QnAModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.eventId,
    required this.askerId,
    required this.votes,
    required this.createdAt,
  });

  factory QnAModel.fromJson(Map<String, dynamic> json) {
    return QnAModel(
      id: json['_id']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? '',
      askerId: json['askerId']?.toString() ?? '',
      votes: json['votes'] as int? ?? 0,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

class PollOptionModel {
  final String id;
  final String text;
  final int votes;

  PollOptionModel({required this.id, required this.text, required this.votes});

  factory PollOptionModel.fromJson(Map<String, dynamic> json) {
    return PollOptionModel(
      id: json['_id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      votes: json['votes'] as int? ?? 0,
    );
  }
}

class PollModel {
  final String id;
  final String question;
  final String eventId;
  final List<PollOptionModel> options;
  final bool isActive;
  final String createdAt;

  PollModel({
    required this.id,
    required this.question,
    required this.eventId,
    required this.options,
    required this.isActive,
    required this.createdAt,
  });

  factory PollModel.fromJson(Map<String, dynamic> json) {
    var list = json['options'] as List? ?? [];
    List<PollOptionModel> optionsList =
        list.map((i) => PollOptionModel.fromJson(i)).toList();

    return PollModel(
      id: json['_id']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? '',
      options: optionsList,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
