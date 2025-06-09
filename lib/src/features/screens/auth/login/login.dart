import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/google_signin.dart';
import 'widgets/header.dart';
import 'widgets/login_button.dart';
import 'widgets/login_form.dart';
import 'widgets/phone_login/phone_login_screen.dart';
import 'widgets/sign_up_link.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Logo Section
              Header(),

              const SizedBox(height: 48),

              // Login Form
              LoginForm(),

              const SizedBox(height: 24),

              // Login Button
              LoginButton(),

              const SizedBox(height: 32),

              // Divider
              _buildDivider(),

              const SizedBox(height: 24),

              // Social Login Options Row
              Row(
                children: [
                  // Google Sign In (Half width)
                  Expanded(
                    child: GoogleSignin(),
                  ),

                  const SizedBox(width: 12),

                  // Phone Sign In (Half width)
                  Expanded(
                    child: _buildPhoneSignInButton(context),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Sign Up Link
              SignUpLink(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildPhoneSignInButton(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Get.to(() => const PhoneLoginScreen(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 300),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFF34A853).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.phone_android_rounded,
                    size: 16,
                    color: Color(0xFF34A853),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Phone',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
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
