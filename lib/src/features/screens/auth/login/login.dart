import 'package:flutter/material.dart';

import 'widgets/google_signin.dart';
import 'widgets/header.dart';
import 'widgets/login_button.dart';
import 'widgets/login_form.dart';
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

              // Google Sign In
              GoogleSignin(),

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
}
