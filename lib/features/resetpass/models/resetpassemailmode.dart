// Request Model
class ForgetPasswordRequest {
  final String email;

  ForgetPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {
        "email": email,
      };
}


class ForgetPasswordSuccessResponse {
  final String message;

  ForgetPasswordSuccessResponse({required this.message});

  factory ForgetPasswordSuccessResponse.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordSuccessResponse(
      message: json['message'][0], 
    );
  }
}


class ForgetPasswordErrorResponse {
  final List<String> errors;

  ForgetPasswordErrorResponse({required this.errors});

  factory ForgetPasswordErrorResponse.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordErrorResponse(
      errors: List<String>.from(json['error']),
    );
  }
}
