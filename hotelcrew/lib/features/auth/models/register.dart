class UserRegistrationRequest {
  final String userName;
  final String email;
  final String password;
  final String confirmPassword;

  UserRegistrationRequest({
    required this.userName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  factory UserRegistrationRequest.fromJson(Map<String, dynamic> json) {
    return UserRegistrationRequest(
      userName: json['user_name'],
      email: json['email'],
      password: json['password'],
      confirmPassword: json['confirm_password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }
}

class UserRegistrationResponse {
  final String message;

  UserRegistrationResponse({required this.message});

  factory UserRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return UserRegistrationResponse(
      message: json['message'],
    );
  }
}
class ApiError {
  final String message;

  ApiError(this.message);
}
