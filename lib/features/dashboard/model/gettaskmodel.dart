// Task Model
class Task {
  final String title;
  final int id;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deadline;
  final String department;
  final String status;
  final String? completedAt;
  final String assignedBy;
  final String assignedTo;

  Task({
    required this.title,
    required this.id,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.deadline,
    required this.department,
    required this.status,
    this.completedAt,
    required this.assignedBy,
    required this.assignedTo,
  });

  // Factory constructor to create a Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      department: json['department'],
      status: json['status'],
      completedAt: json['completed_at'],
      assignedBy: json['assigned_by'],
      assignedTo: json['assigned_to'],
    );
  }

  // Method to convert Task to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'department': department,
      'status': status,
      'completed_at': completedAt,
      'assigned_by': assignedBy,
      'assigned_to': assignedTo,
    };
  }
}

// Response Model
class TaskResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Task> results;

  TaskResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  // Factory constructor to create a TaskResponse from JSON
  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((taskJson) => Task.fromJson(taskJson as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method to convert TaskResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((task) => task.toJson()).toList(),
    };
  }
}
