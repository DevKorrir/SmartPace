import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/features/screens/groups/groups_page.dart';

import '../../features/screens/chat/chats.dart';
import '../../features/screens/home/home.dart';
import '../../features/screens/planner/planner_screen.dart';
import 'model/nav_model.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}

// Main Navigation Widget
class MainNavigation extends StatelessWidget {
  final NavigationController navController = Get.put(NavigationController());

  MainNavigation({super.key});

  final List<Widget> pages = [
    HomeScreen(),
    AIStudyPlannerScreen(),
    ChatScreen(),
    GroupsPage(),
  ];

  // Navigation items configuration
  final List<NavigationItem> navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
      color: const Color(0xFF6366F1), // Indigo
    ),
    NavigationItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today_rounded,
      label: 'Plan',
      color: const Color(0xFF8B5CF6), // Purple
    ),
    NavigationItem(
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
      label: 'Chats',
      color: const Color(0xFF06B6D4), // Cyan
    ),
    NavigationItem(
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_rounded,
      label: 'Groups',
      color: const Color(0xFF10B981), // Emerald
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Obx(() => pages[navController.selectedIndex.value]),
      bottomNavigationBar: Obx(() => Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isDark 
            ? const Color(0xFF1F2937).withOpacity(0.95)
            : Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: navigationItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = navController.selectedIndex.value == index;
            
            return GestureDetector(
              onTap: () => navController.changeTabIndex(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? item.color.withOpacity(0.1)
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? item.color.withOpacity(0.15)
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isSelected ? item.activeIcon : item.icon,
                        color: isSelected 
                          ? item.color
                          : isDark 
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: isSelected 
                          ? item.color
                          : isDark 
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: isSelected 
                          ? FontWeight.w600 
                          : FontWeight.w500,
                      ),
                      child: Text(item.label),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      )),
    );
  }
}

 