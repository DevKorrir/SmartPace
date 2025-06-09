import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'phone_login_controller.dart';

class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
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
                _buildPhoneInput(controller),

                // OTP Input (slide in when needed)
                Obx(() {
                  if (controller.isOtpSent) {
                    return Column(
                      children: [
                        const SizedBox(height: 24),
                        SlideTransition(
                          position: controller.slideAnimation,
                          child: _buildOtpInput(controller),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),

                const SizedBox(height: 32),

                // Action Button
                _buildActionButton(controller),

                // Resend OTP (only show when OTP is sent)
                Obx(() {
                  if (controller.isOtpSent) {
                    return Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildResendButton(controller),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),

                const SizedBox(height: 32),

                // Back to email login
                _buildBackToEmailButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput(PhoneLoginController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() => TextFormField(
        controller: controller.phoneController,
        keyboardType: TextInputType.phone,
        enabled: !controller.isOtpSent,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '+254',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          hintText: '712345678',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        ),
        validator: controller.validatePhone,
      )),
    );
  }

  Widget _buildOtpInput(PhoneLoginController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller.otpController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 8,
        ),
        decoration: InputDecoration(
          hintText: '000000',
          hintStyle: TextStyle(
            color: Colors.grey[300],
            fontSize: 24,
            letterSpacing: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        ),
      ),
    );
  }

  Widget _buildActionButton(PhoneLoginController controller) {
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
              : (controller.isOtpSent ? controller.verifyOtp : controller.sendOtp),
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
        )),
      ),
    );
  }

  Widget _buildResendButton(PhoneLoginController controller) {
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

  Widget _buildBackToEmailButton() {
    return TextButton(
      onPressed: () => Get.back(),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Prefer email login? ',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          children: const [
            TextSpan(
              text: 'Go back',
              style: TextStyle(
                color: Color(0xFF34A853),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}