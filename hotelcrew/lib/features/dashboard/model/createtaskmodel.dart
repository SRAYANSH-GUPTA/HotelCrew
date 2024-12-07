class Task {
  final String title;
  final String department;
  final String? deadline;
  final String description;

  Task({
    required this.title,
    required this.department,
    this.deadline,
    required this.description,
  });

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'department': department,
      'deadline': deadline,
      'description': description,
    };
  }
}
