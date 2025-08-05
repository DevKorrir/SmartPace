// src/controllers/menu_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../routing/routes/app_routes.dart';

class DmenuController extends GetxController {
  // Observable variables
  var isMenuOpen = false.obs;
  var selectedMenuItem = ''.obs;
  
  // Menu items with updated routes
  final List<MenuItemModel> menuItems = [
    MenuItemModel(
      id: 'account',
      title: 'Account',
      icon: Icons.account_circle,
      route: AppRoutes.account,
    ),
    MenuItemModel(
      id: 'settings',
      title: 'Settings',
      icon: Icons.settings,
      route: AppRoutes.settings,
    ),
    MenuItemModel(
      id: 'help',
      title: 'Help & Support',
      icon: Icons.help_outline,
      route: AppRoutes.help,
    ),
    MenuItemModel(
      id: 'about',
      title: 'About',
      icon: Icons.info_outline,
      route: AppRoutes.about,
    ),
    MenuItemModel(
      id: 'logout',
      title: 'Logout',
      icon: Icons.logout,
      route: '',
      isLogout: true,
    ),
  ];

  // Toggle menu visibility
  void toggleMenu() {
    isMenuOpen.value = !isMenuOpen.value;
  }

  // Handle menu item selection
  void selectMenuItem(MenuItemModel item) {
    selectedMenuItem.value = item.id;
    isMenuOpen.value = false;
    
    if (item.isLogout) {
      _handleLogout();
    } else if (item.route.isNotEmpty) {
      Get.toNamed(item.route);
    }
  }

  // Handle logout with Firebase integration
  void _handleLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Add your Firebase logout logic here
                // await Get.find<AuthRepository>().signOut();
                
                Get.back(); // Close dialog
                Get.offAllNamed(AppRoutes.welcome); // Navigate to welcome screen
                
                Get.snackbar(
                  'Success',
                  'Logged out successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.back(); // Close dialog
                Get.snackbar(
                  'Error',
                  'Failed to logout. Please try again.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Close menu
  void closeMenu() {
    isMenuOpen.value = false;
  }
}

// Menu Item Model
class MenuItemModel {
  final String id;
  final String title;
  final IconData icon;
  final String route;
  final bool isLogout;

  MenuItemModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    this.isLogout = false,
  });
}