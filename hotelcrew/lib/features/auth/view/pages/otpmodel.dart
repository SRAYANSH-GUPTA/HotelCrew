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
    // Check if json['error'] is not null and is of type List
    var errorList = json['error'] is List 
        ? List<String>.from(json['error']) 
        : <String>[]; // Provide an empty list if it's null or not a list
    
    return ApiError(
      error: errorList,
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'error': error,
    };
  }
}

