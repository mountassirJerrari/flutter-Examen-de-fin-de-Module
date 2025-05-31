import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String conversationId;
  final String content;
  final DateTime timestamp;
  final bool isMe;

  const Message({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.timestamp,
    required this.isMe,
  });

  @override
  List<Object?> get props => [id, conversationId, content, timestamp, isMe];

  Message copyWith({
    String? id,
    String? conversationId,
    String? content,
    DateTime? timestamp,
    bool? isMe,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isMe: isMe ?? this.isMe,
    );
  }
}
