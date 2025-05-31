import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_chat_app/models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) const SizedBox(width: 8.0),
          Flexible(
            child: IntrinsicWidth(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 2.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? theme.primaryColor
                      : isDarkMode 
                          ? Colors.grey[800] 
                          : Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18.0),
                    topRight: const Radius.circular(18.0),
                    bottomLeft: Radius.circular(isMe ? 18.0 : 4.0),
                    bottomRight: Radius.circular(isMe ? 4.0 : 18.0),
                  ),
                  boxShadow: isMe 
                      ? [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.2),
                            blurRadius: 6.0,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content,
                      style: TextStyle(
                        color: isMe 
                            ? Colors.white 
                            : theme.textTheme.bodyLarge?.color,
                        fontSize: 15.0,
                        height: 1.3,
                        letterSpacing: 0.2,
                      ),
                      textAlign: isMe ? TextAlign.right : TextAlign.left,
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(message.timestamp),
                          style: TextStyle(
                            color: isMe 
                                ? Colors.white70 
                                : Colors.grey[500],
                            fontSize: 10.0,
                            letterSpacing: 0.2,
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4.0),
                          Icon(
                            Icons.done_all,
                            size: 12.0,
                            color: isMe 
                                ? Colors.white70 
                                : Colors.grey[500],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 8.0),
        ],
      ),
    );
  }
}
