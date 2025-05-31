import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/bloc/conversation_bloc.dart';
import 'package:flutter_chat_app/bloc/conversation_event.dart';
import 'package:flutter_chat_app/bloc/conversation_state.dart';
import 'package:flutter_chat_app/models/conversation.dart';
import 'package:flutter_chat_app/widgets/conversation_item.dart';
import 'package:intl/intl.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({Key? key}) : super(key: key);

  @override
  _ConversationListScreenState createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  late final ConversationBloc _conversationBloc;

  @override
  void initState() {
    super.initState();
    _conversationBloc = context.read<ConversationBloc>();
    _conversationBloc.add(LoadConversations());
  }

  void _showCreateConversationDialog() {
    final TextEditingController controller = TextEditingController();
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
                Text(
                  'New Conversation',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the name of the person you want to chat with',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Contact name',
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    autofocus: true,
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
                        if (controller.text.isNotEmpty) {
                          context.read<ConversationBloc>().add(
                                CreateConversation(controller.text),
                              );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
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
                        'CREATE',
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

  void _createNewConversation() {
    _showCreateConversationDialog();
  }
  
  void _navigateToConversation(String conversationId, String contactName) {
    Navigator.pushNamed(
      context,
      '/conversation',
      arguments: {
        'conversationId': conversationId,
        'contactName': contactName,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Messages',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            BlocBuilder<ConversationBloc, ConversationState>(
              builder: (context, state) {
                final count = state is ConversationsLoaded
                    ? state.conversations.length
                    : 0;
                return Text(
                  '$count ${count == 1 ? 'conversation' : 'conversations'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.hintColor,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: theme.iconTheme.color,
            ),
            onPressed: () {
              // TODO: Implémenter la recherche
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: theme.iconTheme.color,
            ),
            onSelected: (value) {
              // Gérer les actions du menu
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'new_group',
                child: Text('New group'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: 'archived',
                child: Text('Archived'),
              ),
              const PopupMenuItem(
                value: 'favorites',
                child: Text('Favorites'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.primaryColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5],
                )
              : null,
        ),
        child: BlocBuilder<ConversationBloc, ConversationState>(
          builder: (context, state) {
            if (state is ConversationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ConversationError) {
              return Center(child: Text('Erreur: ${state.message}'));
            } else if (state is ConversationsLoaded || state is ConversationCreated) {
              final conversations = state is ConversationsLoaded
                  ? state.conversations
                  : (state as ConversationCreated).conversations;

              if (conversations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.message_outlined,
                        size: 64,
                        color: theme.hintColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No conversations yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.hintColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start a new conversation by tapping the + button',
                        style: TextStyle(
                          color: theme.hintColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ConversationBloc>().add(LoadConversations());
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  itemCount: conversations.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 0.5,
                    indent: 88,
                    endIndent: 16,
                    color: theme.dividerColor.withOpacity(0.5),
                  ),
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    return ConversationItem(
                      key: ValueKey(conversation.id),
                      conversation: conversation,
                      onTap: () => _navigateToConversation(
                        conversation.id,
                        conversation.contactName,
                      ),
                    );
                  },
                ),
              );
            } else if (state is MessageSent || state is MessageReceived) {
              // Mettre à jour la liste des conversations après envoi/réception d'un message
              List<Conversation> conversations = [];
              if (state is MessageSent) {
                conversations = state.conversations;
              } else if (state is MessageReceived) {
                conversations = state.conversations;
              }
              
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ConversationBloc>().add(LoadConversations());
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  itemCount: conversations.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 0.5,
                    indent: 88,
                    endIndent: 16,
                    color: theme.dividerColor.withOpacity(0.5),
                  ),
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    return ConversationItem(
                      key: ValueKey(conversation.id),
                      conversation: conversation,
                      onTap: () => _navigateToConversation(
                        conversation.id,
                        conversation.contactName,
                      ),
                    );
                  },
                ),
              );
            } else {
              // État inconnu ou non géré
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Unexpected state',
                      style: TextStyle(
                        fontSize: 18,
                        color: theme.hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ConversationBloc>().add(LoadConversations());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewConversation,
        backgroundColor: theme.primaryColor,
        elevation: 4,
        child: const Icon(
          Icons.chat_bubble_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
