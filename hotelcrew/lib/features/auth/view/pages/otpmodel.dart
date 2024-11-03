class OtpRequest {
  final String email;
  final int otp;

  OtpRequest({required this.email, required this.otp});

  // Factory constructor to create an instance from JSON
  factory OtpRequest.fromJson(Map<String, dynamic> json) {
    return OtpRequest(
      email: json['email'],
      otp: json['otp'],
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}
class ApiError {
  final List<String> error;

  ApiError({required this.error});

  // Factory constructor to create an instance from JSON
  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      error: List<String>.from(json['error']),
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'error': error,
    };
  }
}
