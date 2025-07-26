
class SignUpRequest {
  final String fullName;
  final String email;
  final String phone;
  final String password;

  SignUpRequest({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });
}