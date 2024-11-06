import 'package:email_validator/email_validator.dart';

class OtpRequest {
  final String email;
  final String otp;

  OtpRequest({required this.email, required this.otp});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
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
  final String accessToken;
  final String refreshToken;
  final int userId;

  SuccessResponse({
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });

  factory SuccessResponse.fromJson(Map<String, dynamic> json) {
    return SuccessResponse(
      message: json['message'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      userId: json['user_id'],
    );
  }
}

