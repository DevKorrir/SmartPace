import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  final _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  //final _googleSignIn = GoogleSignIn();
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

      // Store the user's name temporarily in Firebase Auth displayName
      // We'll use this during login to save to Firestore
      await userCredential.user!.updateDisplayName(req.fullName);

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

      // SUCCESS: User is verified and logged in
      // ONLY NOW create user in Firestore (not during signup)
      await _createUserInFirestore(refreshedUser!);

      print('=== LOGIN SUCCESSFUL - USER SAVED TO FIRESTORE ===');

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













  // Create user document in Firestore .. only called during successfull login
  Future<void> _createUserInFirestore(User user) async {

    try {
      // Get the name from Firebase Auth displayName (set during signup)
      String userName = user.displayName ?? _extractNameFromEmail(user.email ?? '');

      // Check if user already exists in Firestore
      DocumentSnapshot existingUser = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (existingUser.exists) {
        print('User already exists in Firestore, updating lastSignIn...');
        // User exists, just update last sign in
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update({
          'lastSignIn': FieldValue.serverTimestamp(),
          'emailVerified': user.emailVerified,
        });
        return;
      }


      Map<String, dynamic> userData = {
        'uid': user.uid,
        'email': user.email,
        'fullName': userName,
        'phoneNumber': user.phoneNumber,
        'photoURL': user.photoURL,
        'emailVerified': user.emailVerified,
        'createdAt': FieldValue.serverTimestamp(),
        'lastSignIn': FieldValue.serverTimestamp(),
        'authProvider': 'email', // Track how user signed up
      };


      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));



    } catch (e) {
      print('=== ERROR CREATING USER IN FIRESTORE ===');
      print('Error: $e');
      // Don't throw - authentication was successful, Firestore is secondary
    }
  }




  // Handle Google Sign In with phone number collection
  Future<UserCredential> signInWithGoogle() async {

    await _googleSignIn.initialize();

    try {
      print('=== STARTING GOOGLE SIGN IN ===');

      // Step 1: trigger auth flow
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

      if (googleUser == null) {
        // User cancelled the sign-in
        throw 'Google sign-in was cancelled';
      }

      print('Google user signed in: ${googleUser.email}');

      // Step 2: Get Google authentication credentials
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      //creaye fire credetial
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Step 3: Check if user already exists in Firebase Auth
      User? existingUser;
      bool hasPhoneNumber = false;
      try {
        // Try to link the credential to see if user exists
        List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(googleUser.email);

        if (signInMethods.isNotEmpty) {
          // User exists, sign them in
          UserCredential userCredential = await _auth.signInWithCredential(credential);
          existingUser = userCredential.user;

          if (existingUser != null) {
          // Check if they already have phone number in Firestore
          DocumentSnapshot userDoc = await _firestore
              .collection('users')
              .doc(existingUser.uid)
              .get();

          if (userDoc.exists) {
            Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
            String? phoneNumber = userData?['phoneNumber']?.toString();

            if (phoneNumber != null && phoneNumber.isNotEmpty && phoneNumber != 'null') {
              hasPhoneNumber = true;
              print('Existing user found with phone number: $phoneNumber');
            }
            // if (userData != null && userData['phoneNumber'] != null && userData['phoneNumber'].toString().isNotEmpty) {
            //   // User has phone number, just update last sign in and proceed
            //   await _updateGoogleUserInFirestore(existingUser);
            //   print('=== EXISTING GOOGLE USER SIGNED IN SUCCESSFULLY ===');
             }
          }
        }
      } catch (e) {
        print('Error checking existing user: $e');
      }

      // Step 4: If existing user has phone number, just update and proceed
      if (existingUser != null && hasPhoneNumber) {
        await _updateGoogleUserInFirestore(existingUser);
        print('=== EXISTING GOOGLE USER SIGNED IN SUCCESSFULLY ===');
        return await _auth.signInWithCredential(credential);
      }

      // Step 5: Show phone number dialog
      String? phoneNumber = await _showPhoneNumberDialog(googleUser.displayName ?? 'User');

      if (phoneNumber == null || phoneNumber.isEmpty) {

        // User cancelled phone number input, sign out from Google
        await _googleSignIn.signOut();

        if (_auth.currentUser != null) {
          await _auth.signOut();
        }

        throw 'Phone number is required to complete registration';
      }

      // Step 6: Sign in with Firebase using Google credentials
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user == null) {
        throw 'Failed to sign in with Google';
      }

      // Step 7: Create/update user in Firestore with phone number
      await _createGoogleUserInFirestore(user, phoneNumber);

      print('=== GOOGLE SIGN IN COMPLETED SUCCESSFULLY ===');
      return userCredential;

    } catch (e) {
      print('=== GOOGLE SIGN IN ERROR ===');
      print('Error: $e');

      // Clean up on error
      try {
        await _googleSignIn.signOut();
        if (_auth.currentUser != null) {
          await _auth.signOut();
        }
      } catch (cleanupError) {
        print('Error during cleanup: $cleanupError');
      }

      throw e.toString();
    }
  }

  // Show phone number input dialog
  Future<String?> _showPhoneNumberDialog(String userName) async {
    final phoneController = TextEditingController();
    String? result;

    await Get.dialog(
      AlertDialog(
        title: Text('Welcome, $userName!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'To complete your registration, please provide your phone number:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+254712345678',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // You can add phone number validation here
              },
            ),
            const SizedBox(height: 8),
            const Text(
              'Include country code (e.g., +254 for Kenya)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              result = null;
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              String phone = phoneController.text.trim();
              if (phone.isNotEmpty && phone.length >= 10) {
                // Ensure phone number starts with +
                if (!phone.startsWith('+')) {
                  phone = '+254$phone'; // Default to Kenya code, adjust as needed
                }
                result = phone;
                Get.back();
              } else {
                Get.snackbar(
                  'Invalid Phone',
                  'Please enter a valid phone number',
                  backgroundColor: Colors.red[100],
                  colorText: Colors.red[800],
                );
              }
            },
            child: const Text('Continue'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return result;
  }






  // Create Google user in Firestore with phone number
  Future<void> _createGoogleUserInFirestore(User user, String phoneNumber) async {
    try {
      print('=== CREATING GOOGLE USER IN FIRESTORE ===');
      print('User ID: ${user.uid}');
      print('Email: ${user.email}');
      print('Phone: $phoneNumber');

      Map<String, dynamic> userData = {
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? _extractNameFromEmail(user.email ?? ''),
        'phoneNumber': phoneNumber,
        'photoURL': user.photoURL,
        'emailVerified': user.emailVerified,
        'createdAt': FieldValue.serverTimestamp(),
        'lastSignIn': FieldValue.serverTimestamp(),
        'authProvider': 'google', // Track how user signed up
      };

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));

      print('=== GOOGLE USER CREATED IN FIRESTORE SUCCESSFULLY ===');

    } catch (e) {
      print('=== ERROR CREATING GOOGLE USER IN FIRESTORE ===');
      print('Error: $e');
      throw 'Failed to save user data: $e';
    }
  }




  // Update existing Google user in Firestore
  Future<void> _updateGoogleUserInFirestore(User user) async {
    try {
      print('=== UPDATING GOOGLE USER IN FIRESTORE ===');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({
        'lastSignIn': FieldValue.serverTimestamp(),
        'emailVerified': user.emailVerified,
        'photoURL': user.photoURL, // Update in case it changed
      });

      print('=== GOOGLE USER UPDATED IN FIRESTORE SUCCESSFULLY ===');

    } catch (e) {
      print('=== ERROR UPDATING GOOGLE USER IN FIRESTORE ===');
      print('Error: $e');
      // Don't throw - authentication was successful
    }
  }





  // Extract first name from email
  String _extractNameFromEmail(String email) {
    if (email.isEmpty) return 'User';

    String localPart = email.split('@').first;

    // Remove numbers and special characters, capitalize first letter
    String cleanName = localPart.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    if (cleanName.isEmpty) return 'User';

    return cleanName[0].toUpperCase() + cleanName.substring(1).toLowerCase();
  }

  // // Ensure user exists in Firestore (for login)
  // Future<void> _ensureUserInFirestore(User user) async {
  //   try {
  //
  //     DocumentSnapshot userDoc = await _firestore
  //         .collection('users')
  //         .doc(user.uid)
  //         .get();
  //
  //     if (!userDoc.exists) {
  //       // User doesn't exist in Firestore, create them
  //       print('User not found in Firestore, creating...');
  //       await _createUserInFirestore(user);
  //     } else {
  //       // User exists, update last sign in
  //       print('User found in Firestore, updating last sign in...');
  //       await _firestore
  //           .collection('users')
  //           .doc(user.uid)
  //           .update({
  //         'lastSignIn': FieldValue.serverTimestamp(),
  //         'emailVerified': user.emailVerified,
  //       });
  //     }
  //
  //     print('=== USER FIRESTORE OPERATIONS COMPLETED ===');
  //
  //   } catch (e) {
  //     print('=== ERROR WITH FIRESTORE USER OPERATIONS ===');
  //     print('Error: $e');
  //     // Don't throw - authentication was successful
  //   }
  // }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = currentUser;
      if (user == null) return null;

      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData(Map<String, dynamic> data) async {
    try {
      User? user = currentUser;
      if (user == null) throw 'No user logged in';

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(data);

      print('User data updated successfully');
    } catch (e) {
      print('Error updating user data: $e');
      throw 'Failed to update user data: $e';
    }
  }


  Future<void> logOut() async {
    try {
      // Sign out from both Firebase Auth and Google Sign In
      await _auth.signOut();
      await _googleSignIn.signOut();
      clearVerificationData();
      print('=== LOGOUT SUCCESSFUL ===');
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