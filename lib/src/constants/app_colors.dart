import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Light Blue Theme
  static const Color primary = Color(0xFF2196F3);          // Light Blue
  static const Color primaryDark = Color(0xFF1976D2);      // Darker Blue
  static const Color primaryLight = Color(0xFFBBDEFB);     // Very Light Blue
  static const Color accent = Color(0xFF03DAC6);           // Teal Accent
  
  // Background Colors
  static const Color background = Color(0xFFF8FAFE);       // Very Light Blue-White
  static const Color surface = Color(0xFFFFFFFF);          // Pure White
  static const Color cardBackground = Color(0xFFFFFFFF);   // White for cards
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);      // Dark Gray
  static const Color textSecondary = Color(0xFF666666);    // Medium Gray
  static const Color textHint = Color(0xFF9E9E9E);         // Light Gray
  static const Color textOnPrimary = Color(0xFFFFFFFF);    // White text on primary
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);          // Green
  static const Color warning = Color(0xFFFFC107);          // Amber
  static const Color error = Color(0xFFF44336);            // Red
  static const Color online = Color(0xFF4CAF50);           // Green for online status
  
  // Message Bubble Colors
  static const Color myMessageBubble = Color(0xFF2196F3);  // Primary blue for my messages
  static const Color otherMessageBubble = Color(0xFFE3F2FD); // Very light blue for others
  static const Color myMessageText = Color(0xFFFFFFFF);     // White text for my messages
  static const Color otherMessageText = Color(0xFF1A1A1A);  // Dark text for other messages
  
  // Border and Shadow Colors
  static const Color border = Color(0xFFE0E0E0);           // Light gray border
  static const Color shadow = Color(0x1A000000);           // Subtle shadow
  static const Color divider = Color(0xFFEEEEEE);          // Divider color
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8FAFE), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}