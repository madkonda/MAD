import 'package:firebase_auth/firebase_auth.dart';

class Task {
  String id;
  String name;
  bool isCompleted;
  String priority;
  DateTime dueDate;
  String userId; // New field to identify the user

  Task({
    required this.id,
    required this.name,
    this.isCompleted = false,
    this.priority = 'Medium',
    required this.dueDate,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted,
      'priority': priority,
      'dueDate': dueDate.toIso8601String(),
      'userId': userId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> data, String id) {
    return Task(
      id: id,
      name: data['name'],
      isCompleted: data['isCompleted'] ?? false,
      priority: data['priority'] ?? 'Medium',
      dueDate: DateTime.parse(data['dueDate']),
      userId: data['userId'], // Map userId from Firestore
    );
  }
}
