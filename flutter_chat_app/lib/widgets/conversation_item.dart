import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_chat_app/models/conversation.dart';

class ConversationItem extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationItem({
    Key? key,
    required this.conversation,
    required this.onTap,
  }) : super(key: key);

  // Générer une couleur basée sur le nom du contact
  Color _getContactColor(String name) {
    final hash = name.codeUnits.fold(0, (int result, int char) => result + char);
    final random = Random(hash);
    return HSLColor.fromAHSL(
      1.0,
      random.nextDouble() * 360,
      0.7,
      0.7,
    ).toColor();
  }

  // Obtenir les initiales du contact
  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    } else if (name.isNotEmpty) {
      return name[0];
    }
    return '??';
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(dateTime);
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactColor = _getContactColor(conversation.contactName);
    final initials = _getInitials(conversation.contactName);
    final hasUnread = conversation.unreadCount > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Avatar avec initiales
              Hero(
                tag: 'avatar-${conversation.id}',
                child: Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: contactColor.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: contactColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: contactColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Détails de la conversation
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.contactName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: hasUnread 
                                  ? FontWeight.bold 
                                  : FontWeight.normal,
                              color: hasUnread 
                                  ? Colors.black 
                                  : Colors.grey[800],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDateTime(conversation.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: hasUnread 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey[500],
                            fontWeight: hasUnread 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: hasUnread 
                                  ? Colors.grey[900] 
                                  : Colors.grey[600],
                              fontWeight: hasUnread 
                                  ? FontWeight.w500 
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (hasUnread)
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
