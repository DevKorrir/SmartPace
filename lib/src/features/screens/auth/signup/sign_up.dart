import 'package:flutter/material.dart';
import 'package:smart_pace/src/features/screens/auth/signup/widgets/login_link.dart';
import 'package:smart_pace/src/features/screens/auth/signup/widgets/terms_checkbox.dart';

import 'widgets/google_sign_up.dart';
import 'widgets/header.dart';
import 'widgets/sign_up_button.dart';
import 'widgets/sign_up_form.dart';


class SignUp extends StatelessWidget {
  const SignUp({super.key});

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
              const SizedBox(height: 20),

              // Header Section
              SignUpHeader(),

              const SizedBox(height: 32),

              // Sign Up Form
              SignUpForm(),

              const SizedBox(height: 16),

              // Terms and Conditions
              TermsCheckbox(),

              const SizedBox(height: 24),

              // Sign Up Button
              SignUpButton(),

              const SizedBox(height: 24),

              // Divider
              _buildDivider(),

              const SizedBox(height: 20),

              // Google Sign Up
              GoogleSignUp(),

              const SizedBox(height: 24),

              // Login Link
              LoginLink(),

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
}
