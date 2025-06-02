/* import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Chat Model
class ChatMessage {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final int unreadCount;
  final bool isOnline;

  ChatMessage({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

// Chat Controller
class ChatController extends GetxController {
  var chatMessages = <ChatMessage>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadChatMessages();
  }

  void loadChatMessages() {
    isLoading.value = true;
    
    // Simulate loading delay
    Future.delayed(Duration(milliseconds: 500), () {
      chatMessages.value = [
        ChatMessage(
          id: '1',
          name: 'Study Group - Math 101',
          lastMessage: 'Hey everyone! Don\'t forget about tomorrow\'s quiz on calculus derivatives.',
          time: '2:30 PM',
          avatarUrl: 'https://via.placeholder.com/50/4CAF50/FFFFFF?text=SG',
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
      ];
      isLoading.value = false;
    });
  }

  void openChat(ChatMessage chat) {
    // Navigate to individual chat page
    Get.to(() => ChatDetailPage(chat: chat));
  }

  void markAsRead(String chatId) {
    int index = chatMessages.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      chatMessages[index] = ChatMessage(
        id: chatMessages[index].id,
        name: chatMessages[index].name,
        lastMessage: chatMessages[index].lastMessage,
        time: chatMessages[index].time,
        avatarUrl: chatMessages[index].avatarUrl,
        unreadCount: 0,
        isOnline: chatMessages[index].isOnline,
      );
    }
  }
}

// Main Chat Screen
class ChatScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
              Get.snackbar(
                'Search',
                'Search functionality coming soon!',
                snackPosition: SnackPosition.TOP,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurple,
            ),
          );
        }

        if (controller.chatMessages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No messages yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Start a conversation with your classmates',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.chatMessages.length,
          itemBuilder: (context, index) {
            final chat = controller.chatMessages[index];
            return ChatTile(
              chat: chat,
              onTap: () => controller.openChat(chat),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Start new chat
          Get.snackbar(
            'New Chat',
            'New chat functionality coming soon!',
            snackPosition: SnackPosition.TOP,
          );
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add_comment, color: Colors.white),
      ),
    );
  }
}

// Chat Tile Widget
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[200],
                      child: Text(
                        chat.name.split(' ').map((e) => e[0]).take(2).join(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (chat.isOnline)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 16),
                
                // Chat content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chat.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            chat.time,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.lastMessage,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chat.unreadCount > 0)
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                chat.unreadCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
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
      ),
    );
  }
}

// Message Model for individual messages
class Message {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String senderName;

  Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.senderName = '',
  });
}

// Chat Detail Controller
class ChatDetailController extends GetxController {
  var messages = <Message>[].obs;
  var isLoading = false.obs;
  final TextEditingController messageController = TextEditingController();

  void loadMessages(String chatId) {
    isLoading.value = true;
    
    // Sample messages based on chat type
    Future.delayed(Duration(milliseconds: 300), () {
      if (chatId == '1') {
        // Study Group messages
        messages.value = [
          Message(
            id: '1',
            text: 'Hey everyone! Don\'t forget about tomorrow\'s quiz on calculus derivatives.',
            isMe: false,
            timestamp: DateTime.now().subtract(Duration(minutes: 30)),
            senderName: 'Alex Chen',
          ),
          Message(
            id: '2',
            text: 'Thanks for the reminder! What chapters should we focus on?',
            isMe: true,
            timestamp: DateTime.now().subtract(Duration(minutes: 25)),
          ),
          Message(
            id: '3',
            text: 'Chapters 3-5, especially the chain rule and product rule examples.',
            isMe: false,
            timestamp: DateTime.now().subtract(Duration(minutes: 20)),
            senderName: 'Sarah Kim',
          ),
          Message(
            id: '4',
            text: 'Perfect! I\'ll review those sections tonight.',
            isMe: true,
            timestamp: DateTime.now().subtract(Duration(minutes: 15)),
          ),
          Message(
            id: '5',
            text: 'Should we meet at the library before the quiz to review together?',
            isMe: false,
            timestamp: DateTime.now().subtract(Duration(minutes: 10)),
            senderName: 'Mike Johnson',
          ),
        ];
      } else {
        // Individual chat messages
        messages.value = [
          Message(
            id: '1',
            text: 'Hi! How did the presentation go today?',
            isMe: true,
            timestamp: DateTime.now().subtract(Duration(hours: 2)),
          ),
          Message(
            id: '2',
            text: 'It went really well! Thanks for helping me practice yesterday.',
            isMe: false,
            timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 55)),
          ),
          Message(
            id: '3',
            text: 'That\'s awesome! I\'m glad I could help.',
            isMe: true,
            timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 50)),
          ),
          Message(
            id: '4',
            text: 'Can you send me the notes from today\'s lecture? I missed the last part.',
            isMe: false,
            timestamp: DateTime.now().subtract(Duration(minutes: 15)),
          ),
        ];
      }
      isLoading.value = false;
    });
  }

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      messages.add(Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: messageController.text.trim(),
        isMe: true,
        timestamp: DateTime.now(),
      ));
      messageController.clear();
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}

// Individual Chat Detail Page
class ChatDetailPage extends StatelessWidget {
  final ChatMessage chat;
  final ChatDetailController controller = Get.put(ChatDetailController());

  ChatDetailPage({required this.chat});

  @override
  Widget build(BuildContext context) {
    controller.loadMessages(chat.id);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Text(
                chat.name.split(' ').map((e) => e[0]).take(2).join(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (chat.isOnline)
                    Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                );
              }

              return Container(
                color: Colors.grey[50],
                child: ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(16),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages.reversed.toList()[index];
                    return MessageBubble(message: message);
                  },
                ),
              );
            }),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: controller.messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      onSubmitted: (_) => controller.sendMessage(),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: controller.sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Message Bubble Widget
class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.deepPurple.withOpacity(0.1),
              child: Text(
                message.senderName.isNotEmpty 
                    ? message.senderName.split(' ').map((e) => e[0]).take(2).join()
                    : 'U',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isMe ? Colors.deepPurple : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(message.isMe ? 20 : 4),
                  bottomRight: Radius.circular(message.isMe ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isMe && message.senderName.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        message.senderName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : Colors.grey[800],
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isMe 
                          ? Colors.white.withOpacity(0.7)
                          : Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isMe) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.deepPurple.withOpacity(0.1),
              child: Text(
                'Me',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ],
      ),
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
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}*/