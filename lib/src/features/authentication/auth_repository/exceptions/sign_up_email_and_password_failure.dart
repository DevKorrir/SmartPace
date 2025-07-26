class SignUpWithEmailAndPasswordFailure {
  final String message;

  const SignUpWithEmailAndPasswordFailure([
    this.message = "An Unknown Error occurred!",
  ]);

  factory SignUpWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak password':
        return SignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password',
        );
      case 'invalid-email':
        return SignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted',
        );
      case 'email already in use':
        return SignUpWithEmailAndPasswordFailure(
          'An account already exists for that email',
        );
      case 'operation not allowed':
        return SignUpWithEmailAndPasswordFailure(
          'Operation is not allowed. Please contact support.',
        );
      case 'user-disabled':
        return SignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );

    // Login specific errors
      case 'user-not-found':
        return const SignUpWithEmailAndPasswordFailure('No account found with this email. Please sign up first.');
      case 'wrong-password':
        return const SignUpWithEmailAndPasswordFailure('Incorrect password. Please try again.');
      case 'invalid-credential':
        return const SignUpWithEmailAndPasswordFailure('Invalid email or password. Please check your credentials.');

    // Session and token errors
      case 'requires-recent-login':
        return const SignUpWithEmailAndPasswordFailure('Please log in again to complete this action.');
      case 'account-exists-with-different-credential':
        return const SignUpWithEmailAndPasswordFailure('An account already exists with this email but different sign-in method.');



      default:
        return SignUpWithEmailAndPasswordFailure('');
    }
  }
}
