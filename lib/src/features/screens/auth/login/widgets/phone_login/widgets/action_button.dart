import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../phone_login_controller.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PhoneLoginController());

    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF34A853), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF34A853).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Obx(() => InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: controller.isLoading
              ? null
              : () {
            if (controller.formKey.currentState!.validate()) {
              if (!controller.isOtpSent) {
                // Send OTP and show dropdown section instead of navigating
                controller.sendOtp();
              } else {
                // Verify OTP
                controller.verifyOtp();
              }
            }
          },
          child: Container(
            alignment: Alignment.center,
            child: controller.isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
                : Text(
              controller.isOtpSent ? 'Verify & Login' : 'Send OTP',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),),
      ),
    );
  }
}
