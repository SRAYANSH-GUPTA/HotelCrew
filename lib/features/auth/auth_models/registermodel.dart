class RegistrationResponse {
  final String status;
  final String message;
  final User user;
  final Tokens tokens;

  RegistrationResponse({
    required this.status,
    required this.message,
    required this.user,
    required this.tokens,
  });

  
  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      status: json['status'],
      message: json['message'],
      user: User.fromJson(json['user']),
      tokens: Tokens.fromJson(json['tokens']),
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'user': user.toJson(),
      'tokens': tokens.toJson(),
    };
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
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    };
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
      access: json['access'],
      refresh: json['refresh'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access': access,
      'refresh': refresh,
    };
  }
}
