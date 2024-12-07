class Announcement {
  final int id;
  final String title;
  final String description;
  final String createdAt;
  final List<String> assignedTo;
  final String assignedBy;
  final String department;
  final String hotel;
  final String urgency;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.assignedTo,
    required this.assignedBy,
    required this.department,
    required this.hotel,
    required this.urgency,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'],
      assignedTo: List<String>.from(json['assigned_to'] ?? []), // Ensure it's a list of strings
      assignedBy: json['assigned_by'],
      department: json['department'],
      hotel: json['hotel'],
      urgency: json['urgency'],
    );
  }
}
