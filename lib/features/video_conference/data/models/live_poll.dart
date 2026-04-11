/// Model for a poll option in a live session.
class PollOption {
  final String text;
  final int count;

  PollOption({
    required this.text,
    required this.count,
  });

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      text: json['text']?.toString() ?? '',
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'count': count,
    };
  }

  int get totalVotes => count;

  @override
  String toString() => 'PollOption(text: $text, count: $count)';
}

/// Model for a live session poll.
///
/// Received from socket event: `event-live:poll-created`
class LivePoll {
  final String id;
  final String question;
  final List<PollOption> options;
  final DateTime createdAt;
  int? selectedOptionIndex;

  LivePoll({
    required this.id,
    required this.question,
    required this.options,
    DateTime? createdAt,
    this.selectedOptionIndex,
  }) : createdAt = createdAt ?? DateTime.now();

  factory LivePoll.fromJson(Map<String, dynamic> json) {
    List<PollOption> options = [];
    if (json['options'] is List) {
      options = (json['options'] as List)
          .map((e) => PollOption.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return LivePoll(
      id: json['id']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options: options,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  int get totalVotes => options.fold(0, (sum, option) => sum + option.count);

  bool get hasVoted => selectedOptionIndex != null;

  double getOptionPercentage(int optionIndex) {
    if (totalVotes == 0) return 0.0;
    return (options[optionIndex].count / totalVotes) * 100;
  }

  @override
  String toString() => 'LivePoll(id: $id, question: $question, options: ${options.length})';
}

/// Model for poll vote update.
///
/// Received from socket event: `event-live:poll-updated`
class PollVoteUpdate {
  final String pollId;
  final int optionIndex;

  PollVoteUpdate({
    required this.pollId,
    required this.optionIndex,
  });

  factory PollVoteUpdate.fromJson(Map<String, dynamic> json) {
    return PollVoteUpdate(
      pollId: json['pollId']?.toString() ?? '',
      optionIndex: json['optionIndex'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pollId': pollId,
      'optionIndex': optionIndex,
    };
  }

  @override
  String toString() => 'PollVoteUpdate(pollId: $pollId, optionIndex: $optionIndex)';
}
