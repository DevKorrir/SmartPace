import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/groups_controller.dart';
import 'models/study_group_model.dart';
import 'screens/chats_page.dart';
import 'widgets/create_group.dart';
import 'widgets/group_card.dart';
import 'widgets/group_item.dart';

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
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!controller.isSearching.value) ...[
            const Expanded(
              child: Column(
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
            ),
            GestureDetector(
              onTap: controller.toggleSearch,
              child: Container(
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
            ),
          ] else ...[
            Expanded(
              child: TextField(
                autofocus: true,
                onChanged: controller.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search groups...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: controller.toggleSearch,
              child: Container(
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
                child: const Icon(Icons.close, color: Colors.black54, size: 24),
              ),
            ),
          ],
        ],
      )),
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
          child: Obx(() {
            final groups = controller.filteredAvailableGroups;
            if (groups.isEmpty) {
              return const Center(
                child: Text(
                  'No groups found',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return GroupCard(
                  group: group,
                  isJoinable: true,
                  onJoin: () => controller.joinGroup(group),
                );
              },
            );
          }),
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
          Obx(() {
            final groups = controller.filteredStudyGroups;
            if (groups.isEmpty) {
              return const Center(
                child: Text(
                  'No groups found',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groups.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final group = groups[index];
                return StudyGroupItem(
                  group: group,
                  onTap: () => _navigateToChat(group),
                );
              },
            );
          }),
        ],
      ),
    );
  }
void _navigateToChat(StudyGroupModel group) {
  Future.delayed(Duration.zero, () {
    Get.to(() => ChatPage(group: group));
  });
}
  void _showCreateGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CreateGroupDialog(
        onCreateGroup: controller.createGroup,
      ),
    );
  }
}