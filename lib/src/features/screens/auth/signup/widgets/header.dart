import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/constants/text_string.dart';

import '../../../../../constants/colors.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Logo/Icon
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: tSecondaryColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: tSecondaryColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_add_rounded,
            color: Colors.white,
            size: 35,
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Welcome Text
        Text(
          tSignUpTitle,
          style: Get.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          tSignUpnSubtitle,
          style: Get.textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}