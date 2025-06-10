import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_pace/src/features/authentication/auth_repository/exceptions/sign_up_email_and_password_failure.dart';
import 'package:smart_pace/src/features/screens/welcome/welcome.dart';
import 'package:smart_pace/src/routing/navigation/navigation.dart';
import '../../screens/splash/splash_screen.dart';

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
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => SplashScreen())
        : Get.offAll(() => MainNavigation());
  }

  Future<void> phoneAuthentication(String phoneNo) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            Get.snackbar(
              "Success",
              "Phone number verified automatically",
              snackPosition: SnackPosition.TOP,
            );
          } catch (e) {
            Get.snackbar(
              "Error",
              "Auto-verification failed: ${e.toString()}",
              snackPosition: SnackPosition.TOP,
            );
          }
        },

        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;
          this.resendToken.value = resendToken;
          print('OTP sent successfully. Verification ID: $verificationId');
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
          print('Auto-retrieval timeout. Verification ID: $verificationId');
        },

        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.code} - ${e.message}');

          switch (e.code) {
            case 'invalid-phone-number':
              throw 'The provided phone number is not valid.';
            case 'too-many-requests':
              throw 'Too many requests. Please try again later.';
            case 'quota-exceeded':
              throw 'SMS quota exceeded. Please try again later.';
            case 'network-request-failed':
              throw 'Network error. Please check your connection.';
            default:
              throw 'Verification failed: ${e.message ?? 'Unknown error'}';
          }
        },
      );
    } catch (e) {
      throw e.toString();
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

      switch (e.code) {
        case 'invalid-verification-code':
          throw 'The verification code is invalid. Please try again.';
        case 'invalid-verification-id':
          throw 'The verification session has expired. Please request a new OTP.';
        case 'session-expired':
          throw 'The verification session has expired. Please request a new OTP.';
        case 'too-many-requests':
          throw 'Too many failed attempts. Please try again later.';
        default:
          throw 'OTP verification failed: ${e.message ?? 'Unknown error'}';
      }
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  // Enhanced resend OTP method
  Future<void> resendOtp(String phoneNo) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 60),
        forceResendingToken: resendToken.value,

        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            Get.snackbar(
              "Success",
              "Phone number verified automatically",
              snackPosition: SnackPosition.TOP,
            );
          } catch (e) {
            Get.snackbar(
              "Error",
              "Auto-verification failed: ${e.toString()}",
              snackPosition: SnackPosition.TOP,
            );
          }
        },

        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;
          this.resendToken.value = resendToken;
          print('OTP resent successfully. New Verification ID: $verificationId');
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
        },

        verificationFailed: (FirebaseAuthException e) {
          print('Resend failed: ${e.code} - ${e.message}');

          switch (e.code) {
            case 'invalid-phone-number':
              throw 'The provided phone number is not valid.';
            case 'too-many-requests':
              throw 'Too many requests. Please try again later.';
            case 'quota-exceeded':
              throw 'SMS quota exceeded. Please try again later.';
            default:
              throw 'Resend failed: ${e.message ?? 'Unknown error'}';
          }
        },
      );
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseUser.value != null
          ? Get.offAll(() => MainNavigation())
          : Get.offAll(() => Welcome());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
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
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('LOGIN EXCEPTION - ${ex.message}');
      throw ex;
    } catch (e) {
      const ex = SignUpWithEmailAndPasswordFailure();
      print('LOGIN EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
      // Clear verification data on logout
      verificationId.value = '';
      resendToken.value = null;
    } catch (e) {
      print('Logout failed: ${e.toString()}');
      throw 'Logout failed: ${e.toString()}';
    }
  }

  // Additional utility methods
  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => _auth.currentUser != null;
  String? get currentUserPhone => _auth.currentUser?.phoneNumber;
  String? get currentUserEmail => _auth.currentUser?.email;

  void clearVerificationData() {
    verificationId.value = '';
    resendToken.value = null;
  }
}