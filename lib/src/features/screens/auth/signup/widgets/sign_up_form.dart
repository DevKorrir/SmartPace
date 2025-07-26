import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/features/screens/auth/signup/widgets/text_field.dart';

import '../../../../authentication/controllers/sign_up_controller.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    //final SignUpController controller = Get.put(SignUpController());
    final SignUpController controller = Get.find<SignUpController>();


    return Column(
      children: [
        // Full Name Field
        Obx(
          () => buildTextField(
            controller: controller.fullNameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            prefixIcon: Icons.person_outline,
            errorText:
                controller.fullNameError.value.isEmpty
                    ? null
                    : controller.fullNameError.value,
            onChanged: controller.validateFullName,
          ),
        ),

        const SizedBox(height: 16),

        // Email Field
        Obx(
          () => buildTextField(
            controller: controller.emailController,
            label: 'Email',
            hint: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            errorText:
                controller.emailError.value.isEmpty
                    ? null
                    : controller.emailError.value,
            onChanged: controller.validateEmail,
          ),
        ),

        const SizedBox(height: 16),

        // Phone Field
        Obx(
          () => buildTextField(
            controller: controller.phoneController,
            label: 'Phone Number',
            hint: 'Enter your phone number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            errorText:
                controller.phoneError.value.isEmpty
                    ? null
                    : controller.phoneError.value,
            onChanged: controller.validatePhone,
          ),
        ),

        const SizedBox(height: 16),

        // Password Field
        Obx(
          () => buildTextField(
            controller: controller.passwordController,
            label: 'Password',
            hint: 'Create a strong password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            obscureText: !controller.isPasswordVisible.value,
            errorText:
                controller.passwordError.value.isEmpty
                    ? null
                    : controller.passwordError.value,
            onChanged: controller.validatePassword,
            suffixIcon: IconButton(
              onPressed: controller.togglePasswordVisibility,
              icon: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Confirm Password Field
        Obx(
          () => buildTextField(
            controller: controller.confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Confirm your password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            obscureText: !controller.isConfirmPasswordVisible.value,
            errorText:
                controller.confirmPasswordError.value.isEmpty
                    ? null
                    : controller.confirmPasswordError.value,
            onChanged: controller.validateConfirmPassword,
            suffixIcon: IconButton(
              onPressed: controller.toggleConfirmPasswordVisibility,
              icon: Icon(
                controller.isConfirmPasswordVisible.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
