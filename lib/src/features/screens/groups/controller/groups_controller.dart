import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/study_group_model.dart';

class GroupsController extends GetxController {
  var selectedTab = 0.obs;
  var isCreatingGroup = false.obs;
  var searchQuery = ''.obs;
  var isSearching = false.obs;

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

  //Mock Groups to join
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

  // Filtered groups based on search
  List<StudyGroupModel> get filteredStudyGroups {
    if (searchQuery.value.isEmpty) {
      return studyGroups;
    }
    return studyGroups.where((group) =>
        group.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        group.subject.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
  }

  List<StudyGroupModel> get filteredAvailableGroups {
    if (searchQuery.value.isEmpty) {
      return availableGroups;
    }
    return availableGroups.where((group) =>
        group.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        group.subject.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchQuery.value = '';
    }
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

  void updateGroupLastMessage(String groupId, String message) {
    final groupIndex = studyGroups.indexWhere((group) => group.id == groupId);
    if (groupIndex != -1) {
      final group = studyGroups[groupIndex];
      studyGroups[groupIndex] = group.copyWith(
        lastMessage: 'You: $message',
        time: 'Now',
      );
    }
  }

  void markGroupAsRead(String groupId) {
    final groupIndex = studyGroups.indexWhere((group) => group.id == groupId);
    if (groupIndex != -1) {
      final group = studyGroups[groupIndex];
      studyGroups[groupIndex] = group.copyWith(unreadCount: 0);
    }
  }
}