class StaffSchedule {
  String staffName;
  String department;
  String shiftType;

  StaffSchedule({
    required this.staffName,
    required this.department,
    required this.shiftType,
  });

  // Factory constructor to create a StaffSchedule from the API response
  factory StaffSchedule.fromApiResponse(Map<String, dynamic> shiftData) {
    
    String staffName = shiftData['user_name'] ?? 'Unknown';
    String shiftTime = shiftData['start_time'] ?? '00:00';
    print(staffName);

    // Define shift type based on the start time (before 18:00 is Day, else Night)
    String shiftType = (int.parse(shiftTime.split(':')[0]) < 18) ? 'Day' : 'Night';

    // Department can be mapped similarly or fetched from another field in the API response
    String department = shiftData['department'] ?? 'Unknown';

    return StaffSchedule(
      staffName: staffName,
      department: department,
      shiftType: shiftType,
    );
  }

  // Method to convert the StaffSchedule object into a map for JSON output
  Map<String, String> toMap() {
    return {
      'Staff': staffName,
      'Department': department,
      'Shift': shiftType,
    };
  }
}
