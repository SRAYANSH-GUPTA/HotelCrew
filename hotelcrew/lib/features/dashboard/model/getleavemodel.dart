class LeaveRequest {
  final int id;
  final String userName;
  final String fromDate;
  final String toDate;
  final String leaveType;
  final String reason;
  final int duration;
  final String status;

  LeaveRequest({
    required this.id,
    required this.userName,
    required this.fromDate,
    required this.toDate,
    required this.leaveType,
    required this.reason,
    required this.duration,
    required this.status,
  });

  // Factory method to parse JSON
  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'] as int,
      userName: json['user_name'] as String,
      fromDate: json['from_date'] as String,
      toDate: json['to_date'] as String,
      leaveType: json['leave_type'] as String,
      reason: json['reason'] as String,
      duration: json['duration'] as int,
      status: json['status'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'name': userName,
      'type': leaveType,
      'department': "Placeholder Department", // Add real data if available
      'duration': "$duration days",
      'reason': reason,
      'dates': "$fromDate - $toDate",
      'status': status,
    };
  }
}
