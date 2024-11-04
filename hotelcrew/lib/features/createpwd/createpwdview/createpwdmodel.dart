class ResetPasswordRequest {
  final String email;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequest({
    required this.email,
    required this.newPassword,
    required this.confirmPassword,
  });

  // Convert JSON to ResetPasswordRequest
  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequest(
      email: json['email'],
      newPassword: json['new_password'],
      confirmPassword: json['confirm_password'],
    );
  }

  // Convert ResetPasswordRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    };
  }
}
class ErrorResponse {
  final List<String> error;

  ErrorResponse({required this.error});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      error: List<String>.from(json['error']),
    );
  }
}

class SuccessResponse {
  final String message;

  SuccessResponse({required this.message});

  factory SuccessResponse.fromJson(Map<String, dynamic> json) {
    return SuccessResponse(
      message: json['message'],
    );
  }
}
