import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../phone_login_controller.dart';

class ResendButton extends StatelessWidget {
  const ResendButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PhoneLoginController());

    return Center(
      child: Obx(() => TextButton(
        onPressed: controller.resendTimer > 0 || controller.isResendingOtp
            ? null
            : controller.resendOtp,
        child: controller.isResendingOtp
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : Text(
          controller.resendTimer > 0
              ? 'Resend OTP in ${controller.resendTimer}s'
              : 'Resend OTP',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: controller.resendTimer > 0
                ? Colors.grey[500]
                : const Color(0xFF34A853),
          ),
        ),
      )),
    );
  }
}
