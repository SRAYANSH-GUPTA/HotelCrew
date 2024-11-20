class Task {
  final int id;
  final String title;
  final int assignedTo;
  final String status;
  final String description;
  final String deadline;
  final String department;

  Task({
    required this.id,
    required this.title,
    required this.assignedTo,
    required this.status,
    required this.description,
    required this.deadline,
    required this.department,
  });

  // Factory method to parse from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      assignedTo: json['assigned_to'],
      status: json['status'],
      description: json['description'] ?? 'No description available',
      deadline: json['deadline'],
      department: json['department'] ?? 'No department available',
    );
  }
}
