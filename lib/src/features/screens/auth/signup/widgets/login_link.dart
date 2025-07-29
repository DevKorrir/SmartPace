import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/colors.dart';
import '../../../../authentication/controllers/sign_up_controller.dart';

class LoginLink extends StatelessWidget {
  const LoginLink({super.key});

  @override
  Widget build(BuildContext context) {
  //final SignUpController controller = Get.put(SignUpController());
    final SignUpController controller = Get.find<SignUpController>();


    return Center(
      child: TextButton(
        onPressed: controller.navigateToLogin,
        child: RichText(
          text: TextSpan(
            text: 'Already have an account? ',
            style: Get.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
            children: [
              TextSpan(
                text: 'Sign In',
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