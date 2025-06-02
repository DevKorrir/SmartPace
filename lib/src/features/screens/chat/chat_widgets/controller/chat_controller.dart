import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/chat_detail_page.dart';
import '../models/chat_message.dart';

class ChatController extends GetxController {
  final RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  
  // Filtered messages based on search
  List<ChatMessage> get filteredMessages {
    if (searchQuery.isEmpty) return chatMessages;
    return chatMessages.where((chat) =>
      chat.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
      chat.lastMessage.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadChatMessages();
  }

  Future<void> loadChatMessages() async {
    try {
      isLoading.value = true;
      
      // Simulate API call with realistic delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      chatMessages.value = [
        ChatMessage(
          id: '1',
          name: 'Study Group - Math 101',
          lastMessage: 'Hey everyone! Don\'t forget about tomorrow\'s quiz on calculus derivatives.',
          time: '2:30 PM',
          avatarUrl: 'https://via.placeholder.com/50/2196F3/FFFFFF?text=SG',
          unreadCount: 3,
          isOnline: true,
        ),
        ChatMessage(
          id: '2',
          name: 'Sarah Wilson',
          lastMessage: 'Can you send me the notes from today\'s lecture? I missed the last part.',
          time: '1:45 PM',
          avatarUrl: 'https://via.placeholder.com/50/2196F3/FFFFFF?text=SW',
          unreadCount: 1,
          isOnline: false,
        ),
        ChatMessage(
          id: '3',
          name: 'Programming Club',
          lastMessage: 'Who\'s joining the Flutter workshop this weekend?',
          time: '12:20 PM',
          avatarUrl: 'https://via.placeholder.com/50/2196F3/FFFFFF?text=PC',
          unreadCount: 5,
          isOnline: true,
        ),
        ChatMessage(
          id: '4',
          name: 'Alex Chen',
          lastMessage: 'Thanks for helping with the project! 🚀',
          time: '11:30 AM',
          avatarUrl: 'https://via.placeholder.com/50/2196F3/FFFFFF?text=AC',
          unreadCount: 0,
          isOnline: true,
        ),
        ChatMessage(
          id: '5',
          name: 'Design Team',
          lastMessage: 'New mockups are ready for review',
          time: 'Yesterday',
          avatarUrl: 'https://via.placeholder.com/50/2196F3/FFFFFF?text=DT',
          unreadCount: 2,
          isOnline: false,
        ),
      ];
    } catch (e) {
      _showErrorSnackbar('Failed to load messages');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMessages() async {
    await loadChatMessages();
    Get.snackbar(
      'Refreshed',
      'Messages updated successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void openChat(ChatMessage chat) {
    // Mark as read when opening
    markAsRead(chat.id);
    
    // Navigate to chat detail page
    Get.to(
      () => ChatDetailPage(chat: chat),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  void markAsRead(String chatId) {
    final index = chatMessages.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      chatMessages[index] = chatMessages[index].copyWith(unreadCount: 0);
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  void startNewChat() {
    Get.snackbar(
      'Coming Soon',
      'New chat functionality will be available soon!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF2196F3).withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void showSearchDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Search Messages'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Type to search...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: updateSearchQuery,
        ),
        actions: [
          TextButton(
            onPressed: () {
              clearSearch();
              Get.back();
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // Get total unread count
  int get totalUnreadCount {
    return chatMessages.fold(0, (sum, chat) => sum + chat.unreadCount);
  }
}