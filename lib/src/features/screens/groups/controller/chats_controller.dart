import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/messages_model.dart';
import '../models/study_group_model.dart';
import 'groups_controller.dart';

class GroupChatController extends GetxController {
  final StudyGroupModel group;
  GroupsController? groupsController;
  
  var messages = <MessageModel>[].obs;
  var isLoading = false.obs;
  var messageController = TextEditingController();
  ScrollController? scrollController;
  
  void Function(ScrollController)? setScrollController;

  GroupChatController({required this.group}) {
    setScrollController = (ScrollController controller) {
      scrollController = controller;
    };
  }

  @override
  void onInit() {
    super.onInit();
    try {
      groupsController = Get.find<GroupsController>();
    } catch (e) {
      print('GroupsController not found: $e');
    }
    
    // Load messages after a small delay to avoid build conflicts
    Future.delayed(const Duration(milliseconds: 100), () {
      _loadGroupMessages();
      // Mark group as read when entering chat
      groupsController?.markGroupAsRead(group.id);
    });
  }

  void _loadGroupMessages() {
    isLoading.value = true;
    
    // Load different messages based on group ID
    switch (group.id) {
      case '1': // ML Study Group
        _loadMLGroupMessages();
        break;
      case '2': // Tech Gurus
        _loadTechGurusMessages();
        break;
      case '3': // CS Algorithms Discussion
        _loadAlgorithmsMessages();
        break;
      case '4': // Linear regression study group
        _loadLinearRegressionMessages();
        break;
      case '5': // Data Structure Group
        _loadDataStructureMessages();
        break;
      case '6': // OOP 2 Group
        _loadOOPMessages();
        break;
      default:
        _loadDefaultMessages();
    }
    
    isLoading.value = false;
  }

  void _loadMLGroupMessages() {
    messages.value = [
      MessageModel(
        id: '1',
        senderId: 'user1',
        senderName: 'Jude',
        content: 'Hey everyone! Anyone free for practice problems today?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      MessageModel(
        id: '2',
        senderId: 'user2',
        senderName: 'Sarah',
        content: 'I\'m available! What topics are we covering?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      MessageModel(
        id: '3',
        senderId: 'me',
        senderName: 'You',
        content: 'Great! Let\'s focus on linear regression algorithms.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        isMe: true,
      ),
      MessageModel(
        id: '4',
        senderId: 'user3',
        senderName: 'Mike',
        content: 'Perfect! I have some datasets we can work with.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      MessageModel(
        id: '5',
        senderId: 'user1',
        senderName: 'Jude',
        content: 'Anyone free for practice problems?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
    ];
  }

  void _loadTechGurusMessages() {
    messages.value = [
      MessageModel(
        id: '1',
        senderId: 'user1',
        senderName: 'Alex',
        content: 'What do you all think about microservices architecture?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      MessageModel(
        id: '2',
        senderId: 'user2',
        senderName: 'Emma',
        content: 'It\'s great for scalability but adds complexity',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      ),
      MessageModel(
        id: '3',
        senderId: 'me',
        senderName: 'You',
        content: 'I agree! Docker containers help manage that complexity',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        isMe: true,
      ),
      MessageModel(
        id: '4',
        senderId: 'user3',
        senderName: 'Hayley',
        content: 'Tomorrow we will go through Agile Methodology',
        timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
      ),
    ];
  }

  void _loadAlgorithmsMessages() {
    messages.value = [
      MessageModel(
        id: '1',
        senderId: 'user1',
        senderName: 'Lisa',
        content: 'Can someone explain the time complexity of quicksort?',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      MessageModel(
        id: '2',
        senderId: 'user2',
        senderName: 'James',
        content: 'Best case is O(n log n), worst case is O(n²)',
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
      ),
      MessageModel(
        id: '3',
        senderId: 'me',
        senderName: 'You',
        content: 'The pivot selection strategy really matters for performance',
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
        isMe: true,
      ),
      MessageModel(
        id: '4',
        senderId: 'user3',
        senderName: 'Derick',
        content: 'Check out this sorting algorithm',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      ),
    ];
  }

  void _loadLinearRegressionMessages() {
    messages.value = [
      MessageModel(
        id: '1',
        senderId: 'user1',
        senderName: 'Anna',
        content: 'Great session today everyone!',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
      MessageModel(
        id: '2',
        senderId: 'user2',
        senderName: 'Tom',
        content: 'The gradient descent explanation was really helpful',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      ),
      MessageModel(
        id: '3',
        senderId: 'me',
        senderName: 'You',
        content: 'Thanks everyone for today!',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isMe: true,
      ),
    ];
  }

  void _loadDataStructureMessages() {
    messages.value = [
      MessageModel(
        id: '1',
        senderId: 'user1',
        senderName: 'Kevin',
        content: 'Let\'s discuss different array implementations',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      MessageModel(
        id: '2',
        senderId: 'user2',
        senderName: 'Maria',
        content: 'Dynamic arrays vs static arrays - what are the trade-offs?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      MessageModel(
        id: '3',
        senderId: 'user3',
        senderName: 'Carlos',
        content: 'Active discussion on Arrays',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];
  }

  void _loadOOPMessages() {
    messages.value = [
      MessageModel(
        id: '1',
        senderId: 'user1',
        senderName: 'Nina',
        content: 'Can we review inheritance in Java?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      ),
      MessageModel(
        id: '2',
        senderId: 'user2',
        senderName: 'David',
        content: 'Sure! Let\'s start with basic class structures',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
      ),
      MessageModel(
        id: '3',
        senderId: 'user3',
        senderName: 'Sophie',
        content: 'Functions in Java',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];
  }

  void _loadDefaultMessages() {
    messages.value = [
      MessageModel(
        id: '1',
        senderId: 'system',
        senderName: 'System',
        content: 'Welcome to the study group! Start the conversation.',
        timestamp: DateTime.now(),
      ),
    ];
  }

  void sendMessage(String content) {
    if (content.trim().isEmpty) return;

    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      senderName: 'You',
      content: content.trim(),
      timestamp: DateTime.now(),
      isMe: true,
    );

    messages.add(message);
    messageController.clear();
    
    // Update the group's last message in the groups controller if available
    groupsController?.updateGroupLastMessage(group.id, content.trim());
    
    // Scroll to bottom
    _scrollToBottom();
  }

  void sendAttachment(String fileName, String filePath) {
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      senderName: 'You',
      content: 'Shared a file',
      timestamp: DateTime.now(),
      type: MessageType.file,
      attachmentName: fileName,
      attachmentUrl: filePath,
      isMe: true,
    );

    messages.add(message);
    groupsController?.updateGroupLastMessage(group.id, 'Shared a file');
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (scrollController != null && scrollController!.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController!.hasClients) {
          scrollController!.animateTo(
            scrollController!.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}