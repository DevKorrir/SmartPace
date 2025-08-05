import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/colors.dart';
import '../login_controller.dart';

class SignUpLink extends StatelessWidget {
  const SignUpLink({super.key});

  @override
  Widget build(BuildContext context) {
            final LoginController controller = Get.put(LoginController());

    return Center(
      child: TextButton(
        onPressed: controller.navigateToSignUp,
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: Get.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
            children: [
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: tSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}