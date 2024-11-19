class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String role;
  final UserData userData;
  final User? user; // Added user parameter

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.userData,
    this.user, // Optional user field
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      refreshToken: json['refress_token'] ?? '', // Handle possible typo in the response
      role: json['role'],
      userData: UserData.fromJson(json['user_data']),
      user: json['user'] != null ? User.fromJson(json['user']) : null, // Optional user field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refress_token': refreshToken,
      'role': role,
      'user_data': userData.toJson(),
      'user': user?.toJson(),
    };
  }
}
class User {
  final String fullName;
  final String email;
  final String role;

  User({
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['full_name'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'role': role,
    };
  }
}

class UserData {
  final String fullName;
  final String email;
  final String role;

  UserData({
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      fullName: json['full_name'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'role': role,
    };
  }
}
