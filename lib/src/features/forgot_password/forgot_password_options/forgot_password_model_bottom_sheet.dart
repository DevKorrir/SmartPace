import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/features/forgot_password/forgot_password_mail/forgot_password_mail.dart';
import 'package:smart_pace/src/features/forgot_password/forgot_password_phone/forgot_password_phone.dart';

import '../../../constants/sizes.dart';
import '../../../constants/text_string.dart';
import 'modern_forgot_password_option.dart';

class ForgotPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ModernForgotPasswordBottomSheet(),
    );
  }
}

class ModernForgotPasswordBottomSheet extends StatefulWidget {
  const ModernForgotPasswordBottomSheet({Key? key}) : super(key: key);

  @override
  State<ModernForgotPasswordBottomSheet> createState() =>
      _ModernForgotPasswordBottomSheetState();
}

class _ModernForgotPasswordBottomSheetState
    extends State<ModernForgotPasswordBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: const EdgeInsets.only(top: 100),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(tDefaultSize),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

                        // Header Section
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.lock_reset_rounded,
                                color: theme.primaryColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tForgotPasswordTitle,
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tForgotPasswordSubTitle,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Options Section
                        Text(
                          "Choose recovery method:",
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Email Option
                        ModernForgotPasswordOption(
                          icon: Icons.email_rounded,
                          iconColor: const Color(0xFF4285F4),
                          iconBackground: const Color(0xFF4285F4).withOpacity(0.1),
                          title: tEmail,
                          subtitle: tResetViaEmail,
                          onTap: () {
                            _closeWithAnimation(() {
                              Get.to(() => ForgotPasswordMailScreen());
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        // Phone Option
                        ModernForgotPasswordOption(
                          icon: Icons.phone_android_rounded,
                          iconColor: const Color(0xFF34A853),
                          iconBackground: const Color(0xFF34A853).withOpacity(0.1),
                          title: tPhoneNo,
                          subtitle: tResetViaPhone,
                          onTap: () {
                            _closeWithAnimation(() {
                              Get.to(() => ForgotPasswordPhoneScreen());
                            });
                          },
                        ),

                        const SizedBox(height: 24),

                        // Cancel Button
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),

                        // Safe area padding for bottom
                        SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _closeWithAnimation(VoidCallback onComplete) {
    _animationController.reverse().then((_) {
      Navigator.pop(context);
      onComplete();
    });
  }
}


