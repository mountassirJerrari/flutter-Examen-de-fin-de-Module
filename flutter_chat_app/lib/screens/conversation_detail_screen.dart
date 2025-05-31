import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/bloc/conversation_bloc.dart';
import 'package:flutter_chat_app/bloc/conversation_event.dart';
import 'package:flutter_chat_app/bloc/conversation_state.dart';
import 'package:flutter_chat_app/models/message.dart';
import 'package:flutter_chat_app/widgets/message_bubble.dart';
import 'package:intl/intl.dart';

class ConversationDetailScreen extends StatefulWidget {
  final String conversationId;
  final String contactName;

  const ConversationDetailScreen({
    Key? key,
    required this.conversationId,
    required this.contactName,
  }) : super(key: key);

  @override
  _ConversationDetailScreenState createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ConversationBloc _conversationBloc;

  @override
  void initState() {
    super.initState();
    _conversationBloc = context.read<ConversationBloc>();
    _conversationBloc.add(LoadMessages(widget.conversationId));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollToBottom();
      }
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      _conversationBloc.add(
        SendMessage(
          conversationId: widget.conversationId,
          content: text,
          isMe: true,
        ),
      );
      _messageController.clear();
      _scrollToBottom();
    }
  }

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

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    } else if (name.isNotEmpty) {
      return name[0];
    }
    return '??';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final contactColor = _getContactColor(widget.contactName);
    final initials = _getInitials(widget.contactName);
    
    return BlocConsumer<ConversationBloc, ConversationState>(
      listener: (context, state) {
        if (state is MessagesLoaded || state is MessageSent || state is MessageReceived) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
      },
      builder: (context, state) {
        List<Message> messages = [];
        
        if (state is MessagesLoaded) {
          messages = state.messages;
        } else if (state is MessageSent) {
          messages = state.messages;
        } else if (state is MessageReceived) {
          messages = state.messages;
        }
        
        return _buildScaffold(context, theme, isDarkMode, contactColor, initials, messages);
      },
    );
  }
  
  Widget _buildScaffold(BuildContext context, ThemeData theme, bool isDarkMode, Color contactColor, String initials, List<Message> messages) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        titleSpacing: 0,
        title: InkWell(
          onTap: () {
            // Voir le profil du contact
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                Hero(
                  tag: 'avatar-${widget.conversationId}',
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: contactColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: contactColor.withOpacity(0.7),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: contactColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.contactName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      BlocBuilder<ConversationBloc, ConversationState>(
                        builder: (context, state) {
                          if (state is MessagesLoaded && state.messages.isNotEmpty) {
                            final lastMessage = state.messages.last;
                            return Text(
                              '${lastMessage.isMe ? 'You' : widget.contactName.split(' ').first}: ${lastMessage.content}',
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.videocam_outlined,
              size: 24,
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
            ),
            onPressed: () {
              // Appel vidéo
            },
          ),
          IconButton(
            icon: Icon(
              Icons.phone_outlined,
              size: 22,
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
            ),
            onPressed: () {
              // Appel vocal
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
            ),
            onSelected: (value) {
              // Gérer les actions du menu
              switch (value) {
                case 'view_contact':
                  // Voir le contact
                  break;
                case 'media':
                  // Voir les médias
                  break;
                case 'search':
                  // Rechercher
                  break;
                case 'mute':
                  // Activer/désactiver les notifications
                  break;
                case 'clear':
                  // Effacer la conversation
                  _showClearChatConfirmation(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'view_contact',
                child: Row(
                  children: const [
                    Icon(Icons.person_outline, size: 20),
                    SizedBox(width: 12),
                    Text('View contact'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'media',
                child: Row(
                  children: const [
                    Icon(Icons.photo_library_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Media, files and links'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'search',
                child: Row(
                  children: const [
                    Icon(Icons.search, size: 20),
                    SizedBox(width: 12),
                    Text('Search'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'mute',
                child: Row(
                  children: const [
                    Icon(Icons.notifications_off_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Mute notifications'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: const [
                    Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Clear chat', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(messages),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Bouton émoji
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.emoji_emotions_outlined,
                  size: 24.0,
                  color: isDarkMode ? Colors.white70 : Colors.grey[600],
                ),
                onPressed: () {},
                padding: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(),
              ),
            ),
            
            // Bouton pièce jointe
            const SizedBox(width: 8.0),
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.attach_file_outlined,
                  size: 24.0,
                  color: isDarkMode ? Colors.white70 : Colors.grey[600],
                ),
                onPressed: () {},
                padding: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(),
              ),
            ),
            
            // Champ de texte
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: TextField(
                  controller: _messageController,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                      fontSize: 16.0,
                    ),
                  ),
                  maxLines: 5,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (text) {
                    _sendMessage();
                  },
                ),
              ),
            ),
            
            // Bouton d'envoi
            const SizedBox(width: 4.0),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20.0,
                ),
                onPressed: _sendMessage,
                padding: const EdgeInsets.all(12.0),
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  


  void _showClearChatConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Clear chat?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'All messages will be deleted. This action cannot be undone.',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implémenter la suppression des messages
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Chat cleared'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'CLEAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageList(List<Message> messages) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message_outlined,
              size: 64,
              color: Theme.of(context).hintColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Send a message to start the conversation',
              style: TextStyle(
                color: Theme.of(context).hintColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.isMe;
        final isSameSender = index < messages.length - 1 && 
            messages[index + 1].isMe == isMe;

        return Padding(
          padding: EdgeInsets.only(
            top: isSameSender ? 2.0 : 8.0,
            bottom: 2.0,
          ),
          child: MessageBubble(
            key: ValueKey('${message.id}-${message.timestamp}'),
            message: message,
            isMe: isMe,
          ),
        );
      },
    );
  }
}
