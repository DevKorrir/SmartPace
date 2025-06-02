/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Chat Controller
class ChatController extends GetxController {
  var selectedTab = 0.obs;
  var isCreatingGroup = false.obs;

  // Mock data for chats
  var personalChats = <ChatModel>[
    ChatModel(
      id: '1',
      name: 'Jude',
      lastMessage: 'Hey! Ready for tomorrow\'s study session?',
      time: '2:30 PM',
      unreadCount: 2,
      isOnline: true,
    ),
    ChatModel(
      id: '2',
      name: 'Juma',
      lastMessage: 'Thanks for sharing the notes!',
      time: '1:15 PM',
      unreadCount: 0,
      isOnline: false,
    ),
    ChatModel(
      id: '3',
      name: 'Emma',
      lastMessage: 'Can you please take me through today\'s session on Random Forest?',
      time: '11:45 AM',
      unreadCount: 1,
      isOnline: true,
    ),
  ].obs;

  // Mock data for study groups
  var studyGroups = <StudyGroupModel>[
    StudyGroupModel(
      id: '1',
      name: 'ML Study Group',
      subject: 'Machine Learning',
      lastMessage: 'Jude: Anyone free for practice problems?',
      time: '3:45 PM',
      memberCount: 12,
      unreadCount: 5,
      color: Colors.blue,
      isActive: true,
    ),
    StudyGroupModel(
      id: '2',
      name: 'Tech Gurus',
      subject: 'Software Engineering',
      lastMessage: 'Hayley: Tomorrow we will go through Agile Methodology',
      time: '2:20 PM',
      memberCount: 8,
      unreadCount: 0,
      color: Colors.purple,
      isActive: true,
    ),
    StudyGroupModel(
      id: '3',
      name: 'CS Algorithms Discussion',
      subject: 'Computer Science',
      lastMessage: 'Derick: Check out this sorting algorithm',
      time: '12:30 PM',
      memberCount: 15,
      unreadCount: 3,
      color: Colors.green,
      isActive: false,
    ),
    StudyGroupModel(
      id: '4',
      name: 'Linear regression study group',
      subject: 'Data Science',
      lastMessage: 'You: Thanks everyone for today!',
      time: 'Yesterday',
      memberCount: 6,
      unreadCount: 0,
      color: Colors.red,
      isActive: false,
    ),
  ].obs;

  // Available groups to join
  var availableGroups = <StudyGroupModel>[
    StudyGroupModel(
      id: '5',
      name: 'Data Structure Group',
      subject: 'Data Structures',
      lastMessage: 'Active discussion on Arrays',
      time: 'Now',
      memberCount: 20,
      unreadCount: 0,
      color: Colors.teal,
      isActive: true,
    ),
    StudyGroupModel(
      id: '6',
      name: 'OOP 2 Group',
      subject: 'Programming',
      lastMessage: 'Functions in Java',
      time: '1h ago',
      memberCount: 18,
      unreadCount: 0,
      color: Colors.orange,
      isActive: true,
    ),
  ].obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void joinGroup(StudyGroupModel group) {
    studyGroups.add(group);
    availableGroups.remove(group);
    Get.snackbar(
      'Joined Group',
      'You\'ve successfully joined ${group.name}!',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      snackPosition: SnackPosition.TOP,
    );
  }

  void createGroup(String name, String subject, Color color) {
    final newGroup = StudyGroupModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      subject: subject,
      lastMessage: 'Group created - start the conversation!',
      time: 'Now',
      memberCount: 1,
      unreadCount: 0,
      color: color,
      isActive: true,
    );

    studyGroups.insert(0, newGroup);
    isCreatingGroup.value = false;

    Get.snackbar(
      'Group Created',
      'Your study group "$name" has been created!',
      backgroundColor: Colors.blue.shade100,
      colorText: Colors.blue.shade800,
      snackPosition: SnackPosition.TOP,
    );
  }
}

// Data Models
class ChatModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  ChatModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
  });
}

class StudyGroupModel {
  final String id;
  final String name;
  final String subject;
  final String lastMessage;
  final String time;
  final int memberCount;
  final int unreadCount;
  final Color color;
  final bool isActive;

  StudyGroupModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.lastMessage,
    required this.time,
    required this.memberCount,
    required this.unreadCount,
    required this.color,
    required this.isActive,
  });
}

// Main Chat Screen
class ChatsScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());

  ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: Obx(() => controller.selectedTab.value == 0
                  ? _buildChatsTab()
                  : _buildGroupsTab()),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() => controller.selectedTab.value == 1
          ? FloatingActionButton.extended(
        onPressed: () => _showCreateGroupDialog(context),
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Create Group',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      )
          : FloatingActionButton(
        onPressed: () => Get.snackbar('New Chat', 'Start a new conversation'),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.message, color: Colors.white),
      )),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Messages',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Stay connected with your study partners',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.search,
              color: Colors.black54,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() => Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.changeTab(0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: controller.selectedTab.value == 0 ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: controller.selectedTab.value == 0 ? Colors.white : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Chats',
                      style: TextStyle(
                        color: controller.selectedTab.value == 0 ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.changeTab(1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: controller.selectedTab.value == 1 ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group,
                      color: controller.selectedTab.value == 1 ? Colors.white : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Groups',
                      style: TextStyle(
                        color: controller.selectedTab.value == 1 ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildChatsTab() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Obx(() => ListView.separated(
        itemCount: controller.personalChats.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final chat = controller.personalChats[index];
          return _buildChatItem(chat);
        },
      )),
    );
  }

  Widget _buildGroupsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildJoinGroupsSection(),
          const SizedBox(height: 24),
          _buildMyGroupsSection(),
        ],
      ),
    );
  }

  Widget _buildJoinGroupsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Discover Study Groups',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: Obx(() => ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: controller.availableGroups.length,
            itemBuilder: (context, index) {
              final group = controller.availableGroups[index];
              return _buildGroupCard(group, isJoinable: true);
            },
          )),
        ),
      ],
    );
  }

  Widget _buildMyGroupsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Study Groups',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.studyGroups.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final group = controller.studyGroups[index];
              return _buildStudyGroupItem(group);
            },
          )),
        ],
      ),
    );
  }

  Widget _buildChatItem(ChatModel chat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  chat.name.split(' ').map((e) => e[0]).take(2).join(),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (chat.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      chat.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      chat.time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        chat.lastMessage,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (chat.unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          chat.unreadCount.toString(),
                          style: const TextStyle(
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
    );
  }

  Widget _buildGroupCard(StudyGroupModel group, {bool isJoinable = false}) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: group.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.group,
                  color: group.color,
                  size: 20,
                ),
              ),
              const Spacer(),
              if (group.isActive)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            group.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            group.subject,
            style: TextStyle(
              fontSize: 12,
              color: group.color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${group.memberCount} members',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const Spacer(),
          if (isJoinable)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.joinGroup(group),
                style: ElevatedButton.styleFrom(
                  backgroundColor: group.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Join',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStudyGroupItem(StudyGroupModel group) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: group.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.group,
              color: group.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        group.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        if (group.isActive)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Text(
                          group.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  group.lastMessage,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: group.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${group.memberCount} members',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: group.color,
                        ),
                      ),
                    ),
                    if (group.unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: group.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          group.unreadCount.toString(),
                          style: const TextStyle(
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
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final subjectController = TextEditingController();

    final colors = [Colors.blue, Colors.purple, Colors.green, Colors.orange, Colors.red, Colors.teal];

    var selectedColor = colors.first;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Create Study Group'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Group Name',
                  hintText: 'e.g., Calculus Study Group',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  hintText: 'e.g. Data Structures',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose Group Color',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: colors.map((color) => GestureDetector(
                  onTap: () => selectedColor = color,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: selectedColor == color
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.createGroup(nameController.text, subjectController.text, selectedColor);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}*/