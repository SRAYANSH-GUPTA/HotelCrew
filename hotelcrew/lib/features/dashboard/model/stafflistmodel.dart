class Staff {
  final int id;
  final String userName;
  final String email;
  final String role;
  final String? department;
  final double salary;
  final String upiId;
  final String shift;

  Staff({
    required this.id,
    required this.userName,
    required this.email,
    required this.role,
    required this.salary,
    required this.upiId,
    required this.shift,
    this.department,
  });

  // Convert the staff list response to a list of maps
  static List<Map<String, String>> toListMap(List<Staff> staffList) {
    return staffList.map((staff) {
      return {
        'name': staff.userName,
        'staffId': staff.id.toString(),
        'email': staff.email,
        'role': staff.role,
        'department': staff.department ?? 'N/A', // Handling null department
        'salary': staff.salary.toString(),
        'upiId': staff.upiId,
        'shift': staff.shift,
      };
    }).toList();
  }

  // Convert JSON response to list of Staff objects
  static List<Staff> fromJson(List<dynamic> json) {
    return json.map((data) {
      return Staff(
        id: data['id'],
        userName: data['user_name'],
        email: data['email'],
        role: data['role'],
        department: data['department'],
        salary: data['salary'],
        upiId: data['upi_id'],
        shift: data['shift'],
      );
    }).toList();
  }
}
