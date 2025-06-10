import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:smart_pace/src/routing/navigation/navigation.dart';
import '../../../../../authentication/auth_repository/auth_repository.dart';
import 'widgets/repo/authentication_repository.dart';

class PhoneLoginController extends GetxController with GetTickerProviderStateMixin {
  // Text Controllers
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Observable variables
  final _isOtpSent = false.obs;
  final _isLoading = false.obs;
  final _isResendingOtp = false.obs;
  final _resendTimer = 0.obs;

  // Animation
  late AnimationController slideController;
  late Animation<Offset> slideAnimation;
  Timer? _timer;

  // Auth repository instance
  final _authRepo = AuthRepository.instance;

  // Getters for reactive variables
  bool get isOtpSent => _isOtpSent.value;
  bool get isLoading => _isLoading.value;
  bool get isResendingOtp => _isResendingOtp.value;
  int get resendTimer => _resendTimer.value;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    _timer?.cancel();
    slideController.dispose();
    super.onClose();
  }

  void _initializeAnimations() {
    slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startResendTimer() {
    _resendTimer.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer.value > 0) {
        _resendTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> sendOtp() async {
    if (!formKey.currentState!.validate()) return;

    _isLoading.value = true;

    try {
      String phoneNumber = _formatPhoneNumber(phoneController.text.trim());

      // Call Firebase phone authentication
      await _authRepo.phoneAuthentication(phoneNumber);

      _isOtpSent.value = true;
      _isLoading.value = false;

      slideController.forward();
      _startResendTimer();

      // Show success message
      _showSnackbar(
        'OTP Sent',
        'Verification code sent to ${phoneController.text}',
        Colors.green,
      );
    } catch (e) {
      _isLoading.value = false;
      _showSnackbar(
        'Error',
        'Failed to send OTP: ${e.toString()}',
        Colors.red,
      );
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.length != 6) {
      _showSnackbar(
        'Invalid OTP',
        'Please enter a valid 6-digit OTP',
        Colors.orange,
      );
      return;
    }

    _isLoading.value = true;

    try {
      // Verify OTP using AuthRepository
      bool isVerified = await _authRepo.verifyOtp(otpController.text.trim());

      _isLoading.value = false;

      if (isVerified) {
        // Navigate to main navigation on successful verification
        Get.offAll(() => MainNavigation());
        _showSnackbar(
          'Success',
          'Phone number verified successfully!',
          Colors.green,
        );
      } else {
        _showSnackbar(
          'Verification Failed',
          'Invalid OTP. Please try again.',
          Colors.red,
        );
      }
    } catch (e) {
      _isLoading.value = false;
      _showSnackbar(
        'Verification Failed',
        'Error verifying OTP: ${e.toString()}',
        Colors.red,
      );
    }
  }

  Future<void> resendOtp() async {
    if (_resendTimer.value > 0) return;

    _isResendingOtp.value = true;

    try {
      // Format phone number and resend OTP using the dedicated resend method
      String phoneNumber = _formatPhoneNumber(phoneController.text.trim());

      // Use the dedicated resendOtp method from AuthRepository
      await _authRepo.resendOtp(phoneNumber);

      _isResendingOtp.value = false;
      _startResendTimer();

      _showSnackbar(
        'OTP Resent',
        'New verification code sent to ${phoneController.text}',
        Colors.green,
      );
    } catch (e) {
      _isResendingOtp.value = false;
      _showSnackbar(
        'Error',
        'Failed to resend OTP: ${e.toString()}',
        Colors.red,
      );
    }
  }

  void phoneAuthentication(String phoneNo) {
    AuthenticationRepository.instance.phoneAuthentication(phoneNo);
  }

  // Helper method to format phone number with country code
  String _formatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (!phoneNumber.startsWith('254') && !phoneNumber.startsWith('+254')) {
      // Remove leading zero if present
      if (phoneNumber.startsWith('0')) {
        phoneNumber = phoneNumber.substring(1);
      }
      phoneNumber = '+254$phoneNumber';
    } else if (phoneNumber.startsWith('254')) {
      phoneNumber = '+$phoneNumber';
    }

    return phoneNumber;
  }

  // Reset the form to initial state
  void resetForm() {
    phoneController.clear();
    otpController.clear();
    _isOtpSent.value = false;
    _isLoading.value = false;
    _isResendingOtp.value = false;
    _resendTimer.value = 0;
    _timer?.cancel();
    slideController.reset();
  }

  void _showSnackbar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Remove non-digit characters for validation
    String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Validate Kenyan phone number format
    if (digitsOnly.length < 9 || digitsOnly.length > 12) {
      return 'Please enter a valid phone number';
    }

    // Check if it's a valid Kenyan number format
    if (digitsOnly.startsWith('254')) {
      if (digitsOnly.length != 12) {
        return 'Please enter a valid phone number';
      }
    } else if (digitsOnly.startsWith('0')) {
      if (digitsOnly.length != 10) {
        return 'Please enter a valid phone number';
      }
    } else if (digitsOnly.length != 9) {
      return 'Please enter a valid phone number';
    }

    return null;
  }
}