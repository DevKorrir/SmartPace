/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Chat Controller
class GroupsController extends GetxController {
  var selectedTab = 0.obs;
  var isCreatingGroup = false.obs;

  // Mock data for study groups
  var studyGroups =
      <StudyGroupModel>[
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
  var availableGroups =
      <StudyGroupModel>[
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
class GroupsPage extends StatelessWidget {
  final GroupsController controller = Get.put(GroupsController());

  GroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildJoinGroupsSection(),
              const SizedBox(height: 24),
              _buildMyGroupsSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateGroupDialog(context),
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Create Group',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
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
                'Groups',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Stay connected with your study partners',
                style: TextStyle(fontSize: 16, color: Colors.black54),
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
            child: const Icon(Icons.search, color: Colors.black54, size: 24),
          ),
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
          child: Obx(
            () => ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: controller.availableGroups.length,
              itemBuilder: (context, index) {
                final group = controller.availableGroups[index];
                return _buildGroupCard(group, isJoinable: true);
              },
            ),
          ),
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
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.studyGroups.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final group = controller.studyGroups[index];
                return _buildStudyGroupItem(group);
              },
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
                child: Icon(Icons.group, color: group.color, size: 20),
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
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
            child: Icon(Icons.group, color: group.color, size: 24),
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
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
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

    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.teal,
    ];

    var selectedColor = colors.first;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: subjectController,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      hintText: 'e.g. Data Structures',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                    children:
                        colors
                            .map(
                              (color) => GestureDetector(
                                onTap: () => selectedColor = color,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border:
                                        selectedColor == color
                                            ? Border.all(
                                              color: Colors.black,
                                              width: 3,
                                            )
                                            : null,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
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
                    controller.createGroup(
                      nameController.text,
                      subjectController.text,
                      selectedColor,
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }
} */
