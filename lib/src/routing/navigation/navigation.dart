import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/screens/chat/chats.dart';
import '../../features/screens/home/home.dart';
import '../../features/screens/profile/profile.dart';
import '../../features/screens/schedule/schedulle_screen.dart';

// Navigation Controller using GetX
class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  // Page titles for app bar
  List<String> get pageTitles => [
    'SmartPace',
    'Schedule',
    'Chats',
    'Profile',
  ];

  String get currentPageTitle => pageTitles[selectedIndex.value];
}

// Main Navigation Widget
class MainNavigation extends StatelessWidget {
  final NavigationController navController = Get.put(NavigationController());

  MainNavigation({Key? key}) : super(key: key);

  // List of pages/widgets for navigation
  final List<Widget> pages = [
    HomeScreen(),
    PlannerScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[navController.selectedIndex.value]),
      bottomNavigationBar: Obx(() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: navController.selectedIndex.value,
          onTap: navController.changeTabIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey.shade500,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: "Schedule",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              activeIcon: Icon(Icons.chat),
              label: "Chats",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      )),
    );
  }
}







