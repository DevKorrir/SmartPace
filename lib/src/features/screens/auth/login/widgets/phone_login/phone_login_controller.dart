import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

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
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual OTP sending logic here
      // Example: await FirebaseAuth.instance.verifyPhoneNumber(...)

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
        'Failed to send OTP. Please try again.',
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
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual OTP verification logic here
      // Example: await credential.signInWithCredential(...)

      // Navigate to home screen or dashboard
      Get.offAllNamed('/home'); // Replace with your home route

    } catch (e) {
      _isLoading.value = false;
      _showSnackbar(
        'Verification Failed',
        'Invalid OTP. Please try again.',
        Colors.red,
      );
    }
  }

  Future<void> resendOtp() async {
    if (_resendTimer.value > 0) return;

    _isResendingOtp.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Implement actual OTP resending logic here

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
        'Failed to resend OTP. Please try again.',
        Colors.red,
      );
    }
  }

  void _showSnackbar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < 9) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}