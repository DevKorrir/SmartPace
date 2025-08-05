import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/features/screens/chat/chat_widgets/models/chat_message.dart';

class ChatDetailController extends GetxController {
  final RxList<Message> messages = <Message>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isTyping = false.obs;
  final RxBool isOnline = true.obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  late String currentChatId;
  late String chatName;

  void initializeChat(String chatId, String name, bool online) {
    currentChatId = chatId;
    chatName = name;
    isOnline.value = online;
    loadMessages(chatId);
  }

  Future<void> loadMessages(String chatId) async {
    try {
      isLoading.value = true;
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));
      
      if (chatId == '1') {
        // Study Group messages
        messages.value = [
          Message(
            id: '1',
            text: 'Hey everyone! Don\'t forget about tomorrow\'s quiz on calculus derivatives.',
            isMe: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
            senderName: 'Alex Chen',
          ),
          Message(
            id: '2',
            text: 'Thanks for the reminder! What chapters should we focus on?',
            isMe: true,
            timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
          ),
          Message(
            id: '3',
            text: 'Chapters 3-5, especially the chain rule and product rule examples.',
            isMe: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
            senderName: 'Sarah Kim',
          ),
          Message(
            id: '4',
            text: 'Perfect! I\'ll review those sections tonight. Does anyone have practice problems?',
            isMe: true,
            timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          ),
          Message(
            id: '5',
            text: 'Should we meet at the library before the quiz to review together?',
            isMe: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
            senderName: 'Mike Johnson',
          ),
          Message(
            id: '6',
            text: 'Great idea! What time works for everyone?',
            isMe: true,
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          ),
        ];
      } else if (chatId == '3') {
        // Programming Club messages
        messages.value = [
          Message(
            id: '1',
            text: 'Who\'s joining the Flutter workshop this weekend?',
            isMe: false,
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
            senderName: 'Workshop Admin',
          ),
          Message(
            id: '2',
            text: 'I\'m definitely in! What topics will be covered?',
            isMe: true,
            timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
          ),
          Message(
            id: '3',
            text: 'We\'ll cover state management, navigation, and API integration',
            isMe: false,
            timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
            senderName: 'Workshop Admin',
          ),
          Message(
            id: '4',
            text: 'Sounds perfect! Should I bring my laptop?',
            isMe: true,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ];
      } else {
        // Default individual chat messages
        messages.value = [
          Message(
            id: '1',
            text: 'Hi! How did the presentation go today?',
            isMe: true,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          Message(
            id: '2',
            text: 'It went really well! Thanks for helping me practice yesterday.',
            isMe: false,
            timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
          ),
          Message(
            id: '3',
            text: 'That\'s awesome! I\'m glad I could help. 😊',
            isMe: true,
            timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
          ),
          Message(
            id: '4',
            text: 'Can you send me the notes from today\'s lecture? I missed the last part.',
            isMe: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          ),
          Message(
            id: '5',
            text: 'Of course! I\'ll send them right after this conversation.',
            isMe: true,
            timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          ),
        ];
      }
    } catch (e) {
      _showErrorSnackbar('Failed to load messages');
    } finally {
      isLoading.value = false;
      _scrollToBottom();
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    try {
      // Create new message
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isMe: true,
        timestamp: DateTime.now(),
        status: MessageStatus.sending,
      );

      // Clear input and add message
      messageController.clear();
      messages.add(newMessage);
      _scrollToBottom();

      // Simulate sending delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Update message status to sent
      final index = messages.indexWhere((msg) => msg.id == newMessage.id);
      if (index != -1) {
        messages[index] = newMessage.copyWith(status: MessageStatus.sent);
      }

      // Simulate response for demo (only in individual chats)
      if (!chatName.contains('Group') && !chatName.contains('Club') && !chatName.contains('Team')) {
        _simulateResponse();
      }
    } catch (e) {
      _showErrorSnackbar('Failed to send message');
    }
  }

  Future<void> _simulateResponse() async {
    // Show typing indicator
    isTyping.value = true;
    
    await Future.delayed(const Duration(seconds: 2));
    
    // Hide typing indicator and add response
    isTyping.value = false;
    
    final responses = [
      'Thanks for your message!',
      'I\'ll get back to you on that.',
      'That sounds great!',
      'Let me think about it.',
      'Sure, I can help with that.',
    ];
    
    final randomResponse = responses[DateTime.now().millisecondsSinceEpoch % responses.length];
    
    messages.add(Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: randomResponse,
      isMe: false,
      timestamp: DateTime.now(),
    ));
    
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void makeCall() {
    Get.snackbar(
      'Calling',
      'Voice call feature coming soon!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF2196F3).withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void showMoreOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionTile(Icons.videocam, 'Video Call', () {}),
            _buildOptionTile(Icons.attach_file, 'Send File', () {}),
            _buildOptionTile(Icons.photo, 'Send Photo', () {}),
            _buildOptionTile(Icons.block, 'Block User', () {}),
            _buildOptionTile(Icons.report, 'Report', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2196F3)),
      title: Text(title),
      onTap: () {
        Get.back();
        onTap();
      },
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

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}