class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String role;
  final UserData userData;
  final User? user; // User data added

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
      refreshToken: json['refress_token'], // Note: typo in the JSON key, should be 'refresh_token'
      role: json['role'],
      userData: UserData.fromJson(json['user_data']),
      user: json['user'] != null ? User.fromJson(json['user']) : null, // Conditional user parsing
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refress_token': refreshToken, // Same typo issue
      'role': role,
      'user_data': userData.toJson(),
      'user': user?.toJson(), // Optional user field in JSON
    };
  }
}

class UserData {
  final String fullName;
  final String email;

  UserData({
    required this.fullName,
    required this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      fullName: json['full_name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
    };
  }
}

class User {
  final int id;
  final String userName;
  final String email;

  User({
    required this.id,
    required this.userName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['user_name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'email': email,
    };
  }
}
