import 'package:flutter/material.dart';
import 'package:smart_pace/src/features/screens/chat/chat_widgets/models/chat_message.dart';
import '../../../../../constants/app_colors.dart';

class ChatTile extends StatelessWidget {
  final ChatMessage chat;
  final VoidCallback onTap;

  const ChatTile({
    Key? key,
    required this.chat,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 16),
                Expanded(child: _buildChatContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _getInitials(chat.name),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textOnPrimary,
                fontSize: 18,
              ),
            ),
          ),
        ),
        if (chat.isOnline)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.online,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.online.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildChatContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                chat.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              chat.time,
              style: TextStyle(
                fontSize: 12,
                color: chat.unreadCount > 0 
                    ? AppColors.primary 
                    : AppColors.textHint,
                fontWeight: chat.unreadCount > 0 
                    ? FontWeight.w600 
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                chat.lastMessage,
                style: TextStyle(
                  fontSize: 14,
                  color: chat.unreadCount > 0 
                      ? AppColors.textSecondary 
                      : AppColors.textHint,
                  height: 1.4,
                  fontWeight: chat.unreadCount > 0 
                      ? FontWeight.w500 
                      : FontWeight.normal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (chat.unreadCount > 0) ...[
              const SizedBox(width: 12),
              _buildUnreadBadge(),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildUnreadBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        chat.unreadCount > 99 ? '99+' : chat.unreadCount.toString(),
        style: const TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0].substring(0, words[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'U';
  }
}