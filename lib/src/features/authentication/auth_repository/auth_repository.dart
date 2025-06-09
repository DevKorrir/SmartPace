import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_pace/src/features/authentication/auth_repository/exceptions/sign_up_email_and_password_failure.dart';
import 'package:smart_pace/src/features/screens/welcome/welcome.dart';
import 'package:smart_pace/src/routing/navigation/navigation.dart';

import '../../screens/splash/splash_screen.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  // variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 5));
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() =>  SplashScreen())
        : Get.offAll(() => MainNavigation());
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
      firebaseUser.value != null ? Get.offAll(MainNavigation()) : Get.offAll(Welcome());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch (_) {
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
    } catch (_) {}
  }

  Future<void> logOut() async => await _auth.signOut();
}
