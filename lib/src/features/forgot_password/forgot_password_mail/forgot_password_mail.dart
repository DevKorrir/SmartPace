import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/common_widgets/forgot_password/form_header_widget.dart';
import 'package:smart_pace/src/constants/image_string.dart';
import 'package:smart_pace/src/constants/sizes.dart';
import 'package:smart_pace/src/constants/text_string.dart';
import 'package:smart_pace/src/features/forgot_password/forgot_password_otp/otp_screen.dart';

import '../../../constants/colors.dart';
import 'ForgotPasswordController.dart';

class ForgotPasswordMailScreen extends StatelessWidget {
  const ForgotPasswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordController controller = Get.find<ForgotPasswordController>();

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(tDefaultSize),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: tDefaultSize * 3),
                FormHeaderWidget(
                  image: tForgotImage,
                  title: tForgotPassword,
                  subTitle: tForgotMailSubtitle,
                  heightBetween: tDefaultSize,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: tFormHeight),
                Form(
                  child: Column(
                    children: [
                      Obx(
                        () => TextFormField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !controller.isLoading.value,
                          onChanged: controller.validateEmail,
                          decoration: InputDecoration(
                            label: Text(tEmail),
                            hintText: tEmail,
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorText:
                                controller.emailError.value.isEmpty
                                    ? null
                                    : controller.emailError.value,
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed:
                          controller.isLoading.value
                              ? null
                              : controller.handlePasswordReset,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: tWhiteColor,
                        backgroundColor: tSecondaryColor,
                        side: BorderSide(color: tSecondaryColor),
                        padding: EdgeInsets.symmetric(vertical: tButtonHeight),
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child:
                          controller.isLoading.value
                              ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    tWhiteColor,
                                  ),
                                ),
                              )
                              : Text(tResetPassword.toUpperCase()),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                // Back to login button
                Obx(
                  () => TextButton(
                    onPressed:
                        controller.isLoading.value ? null : () => Get.back(),
                    child: Text(
                      'Back to Login',
                      style: TextStyle(
                        color: tSecondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
