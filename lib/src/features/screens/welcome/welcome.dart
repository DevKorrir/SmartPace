import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/constants/colors.dart';
import 'package:smart_pace/src/features/screens/auth/sign_up.dart';
import 'package:smart_pace/src/features/screens/auth/login.dart';

import '../../../common_widgets/buttons/modern_button.dart';
import '../../../constants/text_string.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
            isDark
                ? [
              const Color(0xFF0D1117),
              const Color(0xFF161B22),
              const Color(0xFF21262D),
            ]
                : [
              Colors.white,
              const Color(0xFFF8FAFC),
              const Color(0xFFF1F5F9),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.08,
              vertical: size.height * 0.05,
            ),
            child: Column(
              children: [
                // Header with animated logo
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo container with glassmorphism effect
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                isDark
                                    ? Colors.black.withOpacity(0.3)
                                    : Colors.grey.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/welcome.png",
                              height: size.height * 0.3,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content section
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title with modern typography
                      ShaderMask(
                        shaderCallback:
                            (bounds) => LinearGradient(
                          colors: [
                            tSecondaryColor,
                            tSecondaryColor.withOpacity(0.8),
                          ],
                        ).createShader(bounds),
                        child: Text(
                          tWelcomeTitle,
                          style: TextStyle(
                            fontSize: size.width * 0.08,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Subtitle with better spacing
                      Text(
                        tWelcomeSubtitle,
                        style: TextStyle(
                          fontSize: size.width * 0.042,
                          fontWeight: FontWeight.w400,
                          color: isDark ? Colors.grey[300] : Colors.grey[600],
                          height: 1.5,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Button section with modern design
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Primary button (Sign Up)
                      ModernButton(
                        text: tSignup,
                        isPrimary: true,
                        onPressed: () => Get.to(() => SignUp()),
                        color: tSecondaryColor,
                      ),

                      const SizedBox(height: 16),

                      // Secondary button (Login)
                      ModernButton(
                        text: tLogin,
                        isPrimary: false,
                        onPressed: () => Get.to(() => Login()),
                        color: tSecondaryColor,
                      ),

                      const SizedBox(height: 20),
                    ],
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
