class LoginResponse {
  final String status;
  final String message;
  final User user;
  final Tokens tokens;

  LoginResponse({
    required this.status,
    required this.message,
    required this.user,
    required this.tokens,
  });


  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      tokens: Tokens.fromJson(json['tokens'] as Map<String, dynamic>),
    );
  }
}

class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
    );
  }
}

class Tokens {
  final String access;
  final String refresh;

  Tokens({
    required this.access,
    required this.refresh,
  });

  
  factory Tokens.fromJson(Map<String, dynamic> json) {
    return Tokens(
      access: json['access'] as String,
      refresh: json['refresh'] as String,
    );
  }
}
