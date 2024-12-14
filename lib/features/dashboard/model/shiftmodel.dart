class StaffSchedule {
  String staffName;
  String department;
  String shiftType;
  int id;

  StaffSchedule({
    required this.staffName,
    required this.department,
    required this.shiftType,
    required this.id,
  });

  // Factory constructor to create a StaffSchedule from the API response
  factory StaffSchedule.fromApiResponse(Map<String, dynamic> shiftData) {
    String staffName = shiftData['user_name'] ?? 'Unknown';
    int id = shiftData['id'] ?? 0;
    print(staffName);

    // Define shift type based on the start time (before 18:00 is Day, else Night)
    String shiftType = shiftData['shift'] ?? 'Unknown';

    // Department can be mapped similarly or fetched from another field in the API response
    String department = shiftData['department'] ?? 'Unknown';

    return StaffSchedule(
      staffName: staffName,
      department: department,
      shiftType: shiftType,
      id: id,
    );
  }

  // Method to convert the StaffSchedule object into a map for JSON output
  Map<String, dynamic> toMap() {
    return {
      'Staff': staffName,
      'Department': department,
      'Shift': shiftType,
      'id': id.toString(),
    };
  }
}