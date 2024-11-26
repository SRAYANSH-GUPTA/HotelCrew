class Task {
  final int id;
  final String title;
  final String? department; // Nullable
  final String description;
  final String status;
  final String deadline;
  final int assignedTo; // Assuming 'assigned_to' is always an integer
  final DateTime lastUpdated;

  Task({
    required this.id,
    required this.title,
    this.department,
    required this.description,
    required this.status,
    required this.deadline,
    required this.assignedTo,
    required this.lastUpdated,
  });

  // Factory method to create a Task object from JSON data
  factory Task.fromJson(Map<String, dynamic> json) {
    // Log all fields to see the exact types and values
    print('Task JSON: ${json.toString()}');
    print('ID: ${json['id']}, Title: ${json['title']}');
    print('Assigned to: ${json['assigned_to']}');
    print('Department: ${json['department']}');
    print('Last Updated: ${json['last_updated']}');
    
    // Parse fields with null-safety and default values
    return Task(
      id: json['id'] as int, // Assume this is always an int
      title: json['title'] as String,
      // Safely handle nullable 'department' field (might be null)
      department: json['department'] as String?,
      description: json['description'] as String,
      status: json['status'] as String,
      deadline: json['deadline'] as String,
      // Ensure 'assigned_to' is a valid integer, use default if null
      assignedTo: json['assigned_to'] != null ? json['assigned_to'] as int : 0,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : DateTime.now(), // Default to now if null
    );
  }

  // Convert a Task object to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'department': department,
      'description': description,
      'status': status,
      'deadline': deadline,
      'assigned_to': assignedTo,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}
