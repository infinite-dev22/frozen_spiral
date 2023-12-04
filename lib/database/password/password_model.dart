class Password {
  final String oldPassword;
  final String password;
  final String confirmPassword;

  Password({
    required this.oldPassword,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'password': password,
      'password_confirmation': confirmPassword,
    };
  }
}