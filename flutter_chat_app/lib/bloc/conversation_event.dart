import 'package:equatable/equatable.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

// Événement pour charger les conversations
class LoadConversations extends ConversationEvent {}

// Événement pour envoyer un message
class SendMessage extends ConversationEvent {
  final String conversationId;
  final String content;
  final bool isMe;

  const SendMessage({
    required this.conversationId,
    required this.content,
    this.isMe = true,
  });

  @override
  List<Object> get props => [conversationId, content, isMe];
}

// Événement pour recevoir un message
class ReceiveMessage extends ConversationEvent {
  final String conversationId;
  final String content;
  final bool isMe;

  const ReceiveMessage({
    required this.conversationId,
    required this.content,
    this.isMe = false,
  });

  @override
  List<Object> get props => [conversationId, content, isMe];
}

// Événement pour créer une nouvelle conversation
class CreateConversation extends ConversationEvent {
  final String contactName;

  const CreateConversation(this.contactName);

  @override
  List<Object> get props => [contactName];
}

// Événement pour charger les messages d'une conversation
class LoadMessages extends ConversationEvent {
  final String conversationId;

  const LoadMessages(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}
