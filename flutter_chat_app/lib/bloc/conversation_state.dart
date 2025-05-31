import 'package:equatable/equatable.dart';
import 'package:flutter_chat_app/models/conversation.dart';
import 'package:flutter_chat_app/models/message.dart';

// État de base
abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

// État initial
class ConversationInitial extends ConversationState {}

// État de chargement
class ConversationLoading extends ConversationState {}

// État d'erreur
class ConversationError extends ConversationState {
  final String message;

  const ConversationError(this.message);

  @override
  List<Object> get props => [message];
}

// État pour la liste des conversations
class ConversationsLoaded extends ConversationState {
  final List<Conversation> conversations;

  const ConversationsLoaded(this.conversations);

  @override
  List<Object> get props => [conversations];
}

// État pour les messages d'une conversation
class MessagesLoaded extends ConversationState {
  final String conversationId;
  final List<Message> messages;
  final List<Conversation> conversations;

  const MessagesLoaded({
    required this.conversationId,
    required this.messages,
    required this.conversations,
  });

  @override
  List<Object> get props => [conversationId, messages, conversations];
}

// État pour une nouvelle conversation créée
class ConversationCreated extends ConversationState {
  final Conversation conversation;
  final List<Conversation> conversations;

  const ConversationCreated({
    required this.conversation,
    required this.conversations,
  });

  @override
  List<Object> get props => [conversation, conversations];
}

// État pour un message envoyé
class MessageSent extends MessagesLoaded {
  final Message message;

  const MessageSent({
    required String conversationId,
    required List<Message> messages,
    required List<Conversation> conversations,
    required this.message,
  }) : super(
          conversationId: conversationId,
          messages: messages,
          conversations: conversations,
        );

  @override
  List<Object> get props => [message, ...super.props];
}

// État pour un message reçu
class MessageReceived extends MessagesLoaded {
  final Message message;

  const MessageReceived({
    required String conversationId,
    required List<Message> messages,
    required List<Conversation> conversations,
    required this.message,
  }) : super(
          conversationId: conversationId,
          messages: messages,
          conversations: conversations,
        );

  @override
  List<Object> get props => [message, ...super.props];
}

// État pour les messages marqués comme lus
class MessagesMarkedAsRead extends MessagesLoaded {
  final List<String> messageIds;

  const MessagesMarkedAsRead({
    required String conversationId,
    required List<Message> messages,
    required List<Conversation> conversations,
    required this.messageIds,
  }) : super(
          conversationId: conversationId,
          messages: messages,
          conversations: conversations,
        );

  @override
  List<Object> get props => [messageIds, ...super.props];
}
