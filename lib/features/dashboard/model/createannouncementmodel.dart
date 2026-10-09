class Announcement {
  final String title;
  final String message;
  final String priorityLevel;
  final List<String> departments;

  Announcement({
    required this.title,
    required this.message,
    required this.priorityLevel,
    required this.departments,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "message": message,
      "priority_level": priorityLevel,
      "departments": departments,
    };
  }
}
