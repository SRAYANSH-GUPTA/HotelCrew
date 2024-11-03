

// Request model for registration
class RegisterRequest {
  final String email;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }
}

// Response model for registration
class RegisterResponse {
  final List<String>? otp;

  RegisterResponse({this.otp});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      otp: json['otp'] != null ? List<String>.from(json['otp']) : null,
    );
  }
}