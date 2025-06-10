import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/features/screens/auth/login/widgets/phone_login/widgets/phone_input.dart';

import 'phone_login_controller.dart';
import 'widgets/action_button.dart';
import 'widgets/back_email_button.dart';
import 'widgets/otp_input.dart';
import 'widgets/resend_button.dart';

class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PhoneLoginController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
          controller.isOtpSent ? 'Verify OTP' : 'Phone Login',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        )),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Header Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF34A853).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.phone_android_rounded,
                    size: 40,
                    color: Color(0xFF34A853),
                  ),
                ),

                const SizedBox(height: 32),

                // Title and Subtitle
                Obx(() => Text(
                  controller.isOtpSent ? 'Enter Verification Code' : 'Enter Your Phone Number',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                )),

                const SizedBox(height: 12),

                Obx(() => Text(
                  controller.isOtpSent
                      ? 'We sent a 6-digit code to ${controller.phoneController.text}'
                      : 'We\'ll send you a verification code via SMS',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                )),

                const SizedBox(height: 48),

                // Phone Input (always visible)
                PhoneInput(),

                // OTP Input (slide in when needed)
                Obx(() {
                  if (controller.isOtpSent) {
                    return Column(
                      children: [
                        const SizedBox(height: 24),
                        SlideTransition(
                          position: controller.slideAnimation,
                          child: OtpInput(),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),

                const SizedBox(height: 32),

                // Action Button
                ActionButton(),

                // Resend OTP
                Obx(() {
                  if (controller.isOtpSent) {
                    return Column(
                      children: [
                        const SizedBox(height: 24),
                        ResendButton(),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),

                const SizedBox(height: 32),

                // Back to email login
                BackEmailButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






