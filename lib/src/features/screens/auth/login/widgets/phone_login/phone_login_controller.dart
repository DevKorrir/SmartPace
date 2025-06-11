import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:smart_pace/src/routing/navigation/navigation.dart';
import '../../../../../authentication/auth_repository/auth_repository.dart';

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
      await _authRepo.phoneAuthentication(phoneNumber);

      _isOtpSent.value = true;
      slideController.forward();
      _startResendTimer();

      _showSuccessMessage('OTP sent to ${phoneController.text}');
    } catch (e) {
      _showErrorMessage('Failed to send OTP: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.length != 6) {
      _showErrorMessage('Please enter a valid 6-digit OTP');
      return;
    }

    _isLoading.value = true;

    try {
      bool isVerified = await _authRepo.verifyOtp(otpController.text.trim());

      if (isVerified) {
        Get.offAll(() => MainNavigation());
        _showSuccessMessage('Phone number verified successfully!');
      } else {
        _showErrorMessage('Invalid OTP. Please try again.');
      }
    } catch (e) {
      _showErrorMessage('Error verifying OTP: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (_resendTimer.value > 0) return;

    _isResendingOtp.value = true;

    try {
      String phoneNumber = _formatPhoneNumber(phoneController.text.trim());
      await _authRepo.resendOtp(phoneNumber);

      _startResendTimer();
      _showSuccessMessage('New OTP sent to ${phoneController.text}');
    } catch (e) {
      _showErrorMessage('Failed to resend OTP: ${e.toString()}');
    } finally {
      _isResendingOtp.value = false;
    }
  }

  // Helper method to format phone number with country code
  String _formatPhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (!phoneNumber.startsWith('254') && !phoneNumber.startsWith('+254')) {
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

  // Simplified success message helper
  void _showSuccessMessage(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }

  // Simplified error message helper
  void _showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
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

    String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

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