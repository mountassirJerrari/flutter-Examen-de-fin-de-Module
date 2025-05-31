import 'dart:async';
import 'package:flutter_chat_app/models/conversation.dart';
import 'package:flutter_chat_app/models/message.dart';

class ConversationRepository {
  // Données simulées
  final List<Conversation> _conversations = [
    Conversation(
      id: '1',
      contactName: 'John Doe',
      lastMessage: 'Salut, ça va ?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
      avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
    ),
    Conversation(
      id: '2',
      contactName: 'Jane Smith',
      lastMessage: 'À demain pour la réunion',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
      avatarUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
    ),
    Conversation(
      id: '3',
      contactName: 'Bob Wilson',
      lastMessage: 'J\'ai envoyé le document',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 1,
      avatarUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
    ),
  ];

  final Map<String, List<Message>> _messages = {
    '1': [
      Message(
        id: '1',
        conversationId: '1',
        content: 'Salut, ça va ?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isMe: false,
      ),
      Message(
        id: '2',
        conversationId: '1',
        content: 'Oui et toi ?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        isMe: true,
      ),
      Message(
        id: '3',
        conversationId: '1',
        content: 'Super, merci !',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        isMe: false,
      ),
    ],
    '2': [
      Message(
        id: '4',
        conversationId: '2',
        content: 'Bonjour, la réunion est prévue pour demain',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isMe: false,
      ),
      Message(
        id: '5',
        conversationId: '2',
        content: 'D\'accord, à demain pour la réunion',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: true,
      ),
    ],
    '3': [
      Message(
        id: '6',
        conversationId: '3',
        content: 'As-tu envoyé le document ?',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        isMe: true,
      ),
      Message(
        id: '7',
        conversationId: '3',
        content: 'Oui, je l\'ai envoyé',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isMe: false,
      ),
    ],
  };

  // Récupérer toutes les conversations
  Future<List<Conversation>> getConversations() async {
    // Simuler un délai de réseau
    await Future.delayed(const Duration(milliseconds: 500));
    return _conversations;
  }

  // Récupérer les messages d'une conversation
  Future<List<Message>> getMessages(String conversationId) async {
    // Simuler un délai de réseau
    await Future.delayed(const Duration(milliseconds: 300));
    return _messages[conversationId] ?? [];
  }

  // Envoyer un message
  Future<void> sendMessage({
    required String conversationId,
    required String content,
    bool isMe = true,
  }) async {
    // Simuler un délai de réseau
    await Future.delayed(const Duration(milliseconds: 200));
    
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversationId,
      content: content,
      timestamp: DateTime.now(),
      isMe: isMe,
    );
    
    _messages[conversationId] = [..._messages[conversationId] ?? [], message];
    
    // Mettre à jour la dernière conversation
    final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (conversationIndex != -1) {
      final conversation = _conversations[conversationIndex];
      _conversations[conversationIndex] = conversation.copyWith(
        lastMessage: content,
        timestamp: DateTime.now(),
        unreadCount: isMe ? 0 : conversation.unreadCount + 1,
      );
    }
  }

  // Créer une nouvelle conversation
  Future<Conversation> createConversation(String contactName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final newConversation = Conversation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      contactName: contactName,
      lastMessage: 'Nouvelle conversation',
      timestamp: DateTime.now(),
      avatarUrl: 'https://randomuser.me/api/portraits/lego/1.jpg',
    );
    
    _conversations.insert(0, newConversation);
    _messages[newConversation.id] = [];
    
    return newConversation;
  }
}
