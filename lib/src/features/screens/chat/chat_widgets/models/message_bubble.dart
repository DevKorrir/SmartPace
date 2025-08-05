import 'package:flutter/material.dart';
import 'package:smart_pace/src/features/screens/chat/chat_widgets/models/chat_message.dart';
import '../../../../../constants/app_colors.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isMe 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: _buildMessageBubble(context),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            _buildMyAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          _getInitials(message.senderName),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildMyAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 16,
          color: AppColors.textOnPrimary,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: message.isMe 
            ? AppColors.myMessageBubble 
            : AppColors.otherMessageBubble,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(message.isMe ? 20 : 6),
          bottomRight: Radius.circular(message.isMe ? 6 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: message.isMe 
                ? AppColors.primary.withOpacity(0.2)
                : AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isMe && message.senderName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                message.senderName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          Text(
            message.text,
            style: TextStyle(
              color: message.isMe 
                  ? AppColors.myMessageText 
                  : AppColors.otherMessageText,
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(message.timestamp),
                style: TextStyle(
                  color: message.isMe 
                      ? AppColors.textOnPrimary.withOpacity(0.8)
                      : AppColors.textHint,
                  fontSize: 12,
                ),
              ),
              if (message.isMe) ...[
                const SizedBox(width: 4),
                _buildMessageStatus(),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageStatus() {
    IconData icon;
    Color color;
    
    switch (message.status) {
      case MessageStatus.sending:
        icon = Icons.access_time;
        color = AppColors.textOnPrimary.withOpacity(0.6);
        break;
      case MessageStatus.sent:
        icon = Icons.check;
        color = AppColors.textOnPrimary.withOpacity(0.8);
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = AppColors.textOnPrimary.withOpacity(0.8);
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = AppColors.accent;
        break;
      case MessageStatus.failed:
        icon = Icons.error_outline;
        color = AppColors.error;
        break;
    }
    
    return Icon(
      icon,
      size: 14,
      color: color,
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else {
      return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
    }
  }
}