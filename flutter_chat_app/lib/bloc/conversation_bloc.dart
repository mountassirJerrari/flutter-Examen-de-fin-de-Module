import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_chat_app/models/conversation.dart';
import 'package:flutter_chat_app/models/message.dart';
import 'package:flutter_chat_app/repositories/conversation_repository.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ConversationRepository _repository;
  
  // Garder une référence à la liste des conversations
  List<Conversation> _conversations = [];
  String? _currentConversationId;
  List<Message> _currentMessages = [];

  ConversationBloc({required ConversationRepository repository})
      : _repository = repository,
        super(ConversationInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<CreateConversation>(_onCreateConversation);
  }

  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      emit(ConversationLoading());
      _conversations = await _repository.getConversations();
      emit(ConversationsLoaded(_conversations));
    } catch (e) {
      emit(ConversationError('Failed to load conversations'));
    }
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      emit(ConversationLoading());
      _currentConversationId = event.conversationId;
      _currentMessages = await _repository.getMessages(event.conversationId);
      
      // Mettre à jour la conversation actuelle
      final conversationIndex = _conversations.indexWhere(
        (c) => c.id == event.conversationId,
      );
      
      if (conversationIndex != -1) {
        // Réinitialiser le compteur de messages non lus
        _conversations[conversationIndex] = _conversations[conversationIndex].copyWith(
          unreadCount: 0,
        );
      }
      
      emit(MessagesLoaded(
        conversationId: event.conversationId,
        messages: _currentMessages,
        conversations: _conversations,
      ));
    } catch (e) {
      emit(ConversationError('Failed to load messages'));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      await _repository.sendMessage(
        conversationId: event.conversationId,
        content: event.content,
        isMe: event.isMe,
      );
      
      // Recharger les messages
      _currentMessages = await _repository.getMessages(event.conversationId);
      _conversations = await _repository.getConversations();
      
      Message newMessage;
      try {
        newMessage = _currentMessages.firstWhere(
          (m) => m.content == event.content && m.isMe == event.isMe,
        );
      } catch (e) {
        newMessage = _currentMessages.last;
      }
      
      emit(MessageSent(
        conversationId: event.conversationId,
        messages: _currentMessages,
        conversations: _conversations,
        message: newMessage,
      ));
    } catch (e) {
      emit(ConversationError('Failed to send message'));
    }
  }

  Future<void> _onReceiveMessage(
    ReceiveMessage event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      await _repository.sendMessage(
        conversationId: event.conversationId,
        content: event.content,
        isMe: false, // Message reçu, donc isMe = false
      );
      
      // Recharger les messages
      _currentMessages = await _repository.getMessages(event.conversationId);
      _conversations = await _repository.getConversations();
      
      Message newMessage;
      try {
        newMessage = _currentMessages.firstWhere(
          (m) => m.content == event.content && m.isMe == false,
        );
      } catch (e) {
        newMessage = _currentMessages.last;
      }
      
      emit(MessageReceived(
        conversationId: event.conversationId,
        messages: _currentMessages,
        conversations: _conversations,
        message: newMessage,
      ));
    } catch (e) {
      emit(ConversationError('Failed to receive message'));
    }
  }

  Future<void> _onCreateConversation(
    CreateConversation event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      emit(ConversationLoading());
      final newConversation = await _repository.createConversation(event.contactName);
      _conversations = await _repository.getConversations();
      
      emit(ConversationCreated(
        conversation: newConversation,
        conversations: _conversations,
      ));
    } catch (e) {
      emit(ConversationError('Failed to create conversation'));
    }
  }
}
