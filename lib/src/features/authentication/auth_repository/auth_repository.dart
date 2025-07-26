import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_pace/src/features/authentication/auth_repository/exceptions/sign_up_email_and_password_failure.dart';
import 'package:smart_pace/src/routing/navigation/navigation.dart';
import 'package:flutter/material.dart';

import '../../screens/auth/login/login.dart';
import '../../screens/welcome_screen/welcome_screen.dart';
import '../domain/model/signup_request.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  // Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;
  final resendToken = Rx<int?>(null);

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 5));
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    //ever(firebaseUser, _setInitialScreen);
  }

  // _setInitialScreen(User? user) {
  //   user == null
  //       ? Get.offAll(() => Login())
  //       : Get.offAll(() => MainNavigation());
  // }

  Future<void> phoneAuthentication(String phoneNo) async {
    try {
      print('=== Starting phone authentication ===');
      print('Phone number: $phoneNo');

      await Future.delayed(const Duration(milliseconds: 500));
      await _verifyPhoneNumber(phoneNo, null);
      print('=== verifyPhoneNumber call completed ===');
    } catch (e) {
      print('=== Exception in phoneAuthentication ===');
      print('Error: $e');
      throw e.toString();
    }
  }

  Future<void> resendOtp(String phoneNo) async {
    try {
      await _verifyPhoneNumber(phoneNo, resendToken.value);
    } catch (e) {
      throw e.toString();
    }
  }

  // Common method for phone verification to avoid repetition
  Future<void> _verifyPhoneNumber(String phoneNo, int? forceResendingToken) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      timeout: Duration(seconds: forceResendingToken != null ? 60 : 120),
      forceResendingToken: forceResendingToken,

      verificationCompleted: (PhoneAuthCredential credential) async {
        print('=== AUTO VERIFICATION COMPLETED ===');
        try {
          await _auth.signInWithCredential(credential);
          _showSnackbar(
            "Success",
            "Phone number verified automatically",
            Colors.green,
          );
        } catch (e) {
          print('Auto-verification error: $e');
          _showSnackbar(
            "Error",
            "Auto-verification failed: ${e.toString()}",
            Colors.red,
          );
        }
      },

      codeSent: (String verificationId, int? resendToken) {
        print('=== CODE SENT CALLBACK TRIGGERED ===');
        print('Verification ID: $verificationId');
        print('SMS should be sent now');

        this.verificationId.value = verificationId;
        this.resendToken.value = resendToken;

        String message = forceResendingToken != null
            ? "New verification code sent successfully"
            : "Verification code sent successfully";

        _showSnackbar("OTP Sent", message, Colors.green);
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        print('=== AUTO RETRIEVAL TIMEOUT ===');
        print('Verification ID: $verificationId');
        this.verificationId.value = verificationId;
      },

      verificationFailed: (FirebaseAuthException e) {
        print('=== VERIFICATION FAILED ===');
        print('Error code: ${e.code}');
        print('Error message: ${e.message}');
        throw _getPhoneAuthErrorMessage(e);
      },
    );
  }

  // Centralized error handling for phone authentication
  String _getPhoneAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'The provided phone number is not valid.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      case 'app-not-authorized':
        return 'App not authorized. Please check Firebase configuration.';
      case 'captcha-check-failed':
        return 'reCAPTCHA verification failed. Please try again.';
      case 'web-context-already-presented':
        return 'Please close the previous verification window and try again.';
      case 'web-context-cancelled':
        return 'Verification cancelled. Please try again.';
      case 'unknown':
        if (e.message?.contains('BILLING_NOT_ENABLED') == true) {
          return 'SMS service requires a paid Firebase plan. Please upgrade to Blaze plan or use test phone numbers.';
        }
        return 'Verification failed: ${e.message ?? 'Unknown error'}';
      default:
        return 'Verification failed: ${e.message ?? 'Unknown error'}';
    }
  }

  Future<bool> verifyOtp(String otp) async {
    try {
      if (verificationId.value.isEmpty) {
        throw 'Verification ID is missing. Please request OTP again.';
      }

      if (otp.length != 6) {
        throw 'Please enter a valid 6-digit OTP.';
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        print('OTP verification successful. User: ${userCredential.user!.uid}');
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print('OTP verification failed: ${e.code} - ${e.message}');
      throw _getOtpVerificationErrorMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  // Centralized error handling for OTP verification
  String _getOtpVerificationErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-verification-code':
        return 'The verification code is invalid. Please try again.';
      case 'invalid-verification-id':
        return 'The verification session has expired. Please request a new OTP.';
      case 'session-expired':
        return 'The verification session has expired. Please request a new OTP.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      default:
        return 'OTP verification failed: ${e.message ?? 'Unknown error'}';
    }
  }

  Future<void> createUserWithEmailAndPassword(
      SignUpRequest req
      ) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: req.email,
        password: req.password,
      );

      // Check if user was created
      if (userCredential.user == null) {
        throw 'User creation failed - no user returned';
      }

      // // Send verification email
      // await _auth.currentUser!.sendEmailVerification();

      // Send verification email with detailed logging
      print('=== SENDING VERIFICATION EMAIL ===');
      await _sendVerificationEmailWithRetry(userCredential.user!);
      print('=== VERIFICATION EMAIL SENT ===');

      // Clear verification data
      clearVerificationData();

      // Show success message instead
      _showSnackbar(
          "Account Created",
          "Please check your email to verify your account",
          Colors.green
      );

      // Sign out the user until they verify their email
      await _auth.signOut();

      // firebaseUser.value != null
      //     ? Get.offAll(() => MainNavigation())
      //     : Get.offAll(() => Login());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex; // from controller
    } catch (e) {
      const ex = SignUpWithEmailAndPasswordFailure();
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    }
  }







  Future<void> loginUserWithEmailAndPassword(
      String email,
      String password,
      ) async {

    try {

      // sign in the user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      // CRITICAL: Reload user to get latest email verification status
      await userCredential.user!.reload();
      User? refreshedUser = _auth.currentUser;

      bool isEmailVerified = refreshedUser?.emailVerified ?? false;
      print('Email verified status: $isEmailVerified');

      // FIX: Check if email is verified before proceeding
      if (!isEmailVerified) {
        print('=== EMAIL NOT VERIFIED - SIGNING OUT USER ===');
        await _auth.signOut();
        throw SignUpWithEmailAndPasswordFailure.code('email-not-verified');
      }

    } on FirebaseAuthException catch (e) {

      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('LOGIN EXCEPTION - ${ex.message}');
      throw ex;

    } catch (e) {

      if (e is SignUpWithEmailAndPasswordFailure) {
        throw e;
      }

      const ex = SignUpWithEmailAndPasswordFailure();
      throw ex;
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
      clearVerificationData();
    } catch (e) {
      print('Logout failed: ${e.toString()}');
      throw 'Logout failed: ${e.toString()}';
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
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }

  // Utility getters and methods
  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => _auth.currentUser != null;
  String? get currentUserPhone => _auth.currentUser?.phoneNumber;
  String? get currentUserEmail => _auth.currentUser?.email;

  void clearVerificationData() {
    verificationId.value = '';
    resendToken.value = null;
  }


  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSnackbar(
          "Reset Email Sent",
          "Password reset instructions sent to your email",
          Colors.green
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getPasswordResetErrorMessage(e.code);
      _showSnackbar("Reset Failed", errorMessage, Colors.red);
      throw SignUpWithEmailAndPasswordFailure.code(e.code);
    } catch (e) {
      _showSnackbar("Error", "Failed to send reset email", Colors.red);
      throw 'Failed to send password reset email: ${e.toString()}';
    }
  }

// Get error messages for password reset
  String _getPasswordResetErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Failed to send password reset email. Please try again.';
    }
  }

// // Updated resendEmailVerification method (if you don't have it)
//   Future<void> resendEmailVerification() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null && !user.emailVerified) {
//         await user.sendEmailVerification();
//         _showSnackbar(
//             "Email Sent",
//             "Verification email sent successfully",
//             Colors.green
//         );
//       } else {
//         throw 'No user signed in or email already verified';
//       }
//     } on FirebaseAuthException catch (e) {
//       _showSnackbar("Error", "Failed to send verification email", Colors.red);
//       throw SignUpWithEmailAndPasswordFailure.code(e.code);
//     } catch (e) {
//       _showSnackbar("Error", "Failed to send verification email", Colors.red);
//       throw e.toString();
//     }
//   }

  // Improved resend verification email method
  Future<void> resendEmailVerification() async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        throw 'No user is currently signed in';
      }

      // Reload user to get latest verification status
      await user.reload();
      user = _auth.currentUser; // Get refreshed user

      if (user?.emailVerified == true) {
        _showSnackbar(
            "Already Verified",
            "Your email is already verified. You can sign in now.",
            Colors.green
        );
        return;
      }

      await _sendVerificationEmailWithRetry(user!, 0);

    } catch (e) {
      print('Resend verification error: $e');
      _showSnackbar(
          "Resend Failed",
          "Could not resend verification email. Please try again later.",
          Colors.red
      );
      throw e.toString();
    }
  }


  // Send verification email with retry logic
  Future<void> _sendVerificationEmailWithRetry(User user, [int retryCount = 0]) async {
    try {
      print('Attempting to send verification email (attempt ${retryCount + 1})');

      // Reload user to get latest state
      await user.reload();
      User? refreshedUser = _auth.currentUser;

      if (refreshedUser == null) {
        throw 'User not found after reload';
      }

      // Check if already verified (shouldn't be for new accounts)
      if (refreshedUser.emailVerified) {
        print('Email already verified, skipping verification email');
        return;
      }

      // Send the verification email
      await refreshedUser.sendEmailVerification();
      print('=== VERIFICATION EMAIL SENT SUCCESSFULLY ===');

      // Show additional helpful message
      Get.dialog(
        AlertDialog(
          title: const Text('Check Your Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('We sent a verification email to:'),
              const SizedBox(height: 8),
              Text(
                refreshedUser.email ?? 'your email',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Please:'),
              const Text('• Check your inbox'),
              const Text('• Check your spam/junk folder'),
              const Text('• Click the verification link'),
              const SizedBox(height: 16),
              const Text('Then return to sign in.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                await _sendVerificationEmailWithRetry(refreshedUser!, 0);
              },
              child: const Text('Resend Email'),
            ),
          ],
        ),
      );

    } on FirebaseAuthException catch (e) {
      print('=== EMAIL VERIFICATION ERROR ===');
      print('Error Code: ${e.code}');
      print('Error Message: ${e.message}');

      // Handle specific email sending errors
      if (e.code == 'too-many-requests' && retryCount < 2) {
        print('Too many requests, waiting before retry...');
        await Future.delayed(Duration(seconds: 5 * (retryCount + 1)));
        return _sendVerificationEmailWithRetry(user, retryCount + 1);
      }

      // Show user-friendly error
      String errorMessage = _getEmailVerificationErrorMessage(e.code);
      _showSnackbar("Email Send Failed", errorMessage, Colors.orange);

      // Don't throw - account was created successfully, just email failed
      print('Continuing despite email error - user can request resend later');

    } catch (e) {
      print('=== UNEXPECTED EMAIL ERROR ===');
      print('Error: $e');

      if (retryCount < 1) {
        print('Retrying email send...');
        await Future.delayed(const Duration(seconds: 3));
        return _sendVerificationEmailWithRetry(user, retryCount + 1);
      }

      _showSnackbar(
          "Email Issue",
          "Account created but verification email may be delayed. Check your email shortly.",
          Colors.orange
      );
    }
  }

  // Get user-friendly error messages for email verification
  String _getEmailVerificationErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'too-many-requests':
        return 'Too many email requests. Please wait a few minutes before requesting another verification email.';
      case 'invalid-email':
        return 'Invalid email address. Please check your email and try again.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      case 'internal-error':
        return 'Internal error sending email. Please try again in a few minutes.';
      default:
        return 'Failed to send verification email. You can request a new one from the login screen.';
    }
  }






}