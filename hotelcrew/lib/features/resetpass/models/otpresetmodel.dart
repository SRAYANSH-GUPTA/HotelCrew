
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

  SuccessResponse({required this.message});

  factory SuccessResponse.fromJson(Map<String, dynamic> json) {
    return SuccessResponse(
      message: json['message'],
    );
  }
}
