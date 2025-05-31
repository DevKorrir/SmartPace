import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/image_string.dart';
import '../../../../authentication/controllers/sign_up_controller.dart'
    show SignUpController;

class GoogleSignUp extends StatelessWidget {
  const GoogleSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController());

    return Obx(
      () => Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: OutlinedButton.icon(
          onPressed:
              controller.isLoading.value ? null : controller.handleGoogleSignUp,
          icon:
              controller.isLoading.value
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Image.asset(tGoogleLogoImage, height: 24, width: 24),
          label: Text(
            'Continue with Google',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
