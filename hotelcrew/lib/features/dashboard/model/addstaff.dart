class Staff {
  final int id;
  final String name;
  final String email;
  final String department;
  final double salary;

  Staff({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.salary,
  });

  // From JSON
  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      department: json['department'],
      salary: json['salary']?.toDouble() ?? 0.0,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department': department,
      'salary': salary,
    };
  }
}
