import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/features/screens/auth/login/login.dart';

import '../model/welcome_item.dart';

class WelcomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> scaleAnimation;
  
  // Add PageController to control the PageView
  late PageController pageController;

  var currentIndex = 0.obs;

  final List<WelcomeItem> welcomeItems = [
    WelcomeItem(
      title: "Smart Study Planning",
      description:
          "Create personalized study schedules that adapt to your learning pace and goals",
      icon: Icons.schedule,
      color: const Color(0xFF6C63FF),
    ),
    WelcomeItem(
      title: "Track Your Progress",
      description:
          "Monitor your study sessions, achievements, and stay motivated with detailed analytics",
      icon: Icons.trending_up,
      color: const Color(0xFF00D4AA),
    ),
    WelcomeItem(
      title: "Study Together",
      description:
          "Join study groups, collaborate with peers, and chat with friends seamlessly",
      icon: Icons.group,
      color: const Color(0xFFFF6B6B),
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    
    // Initialize PageController
    pageController = PageController();
    
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    animationController.forward();
  }

  @override
  void onClose() {
    animationController.dispose();
    pageController.dispose(); // Dispose PageController
    super.onClose();
  }

  void nextPage() {
    if (currentIndex.value < welcomeItems.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToEnd() {
    Get.to(Login());
  }

  void getStarted() {
    Get.to(Login()); 
  }
}