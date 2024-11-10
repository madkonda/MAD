import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/firebase_service.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final FirebaseService _firebaseService = FirebaseService();

  TaskItem({required this.task});

  void toggleComplete() {
    task.isCompleted = !task.isCompleted;
    _firebaseService.updateTask(task);
  }

  void deleteTask() {
    _firebaseService.deleteTask(task.id);
  }

  @override
  Widget build(BuildContext context) {
    // Set color based on priority level
    Color priorityColor;
    switch (task.priority) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.yellow;
        break;
      case 'Low':
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: priorityColor
            .withOpacity(0.2), // Background color with slight opacity
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: priorityColor, width: 1.5),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: priorityColor,
          child: Text(task.priority[0]), // Display first letter of priority
        ),
        title: Text(
          task.name,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: priorityColor,
          ),
        ),
        trailing: Wrap(
          spacing: 12,
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (val) => toggleComplete(),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: priorityColor),
              onPressed: deleteTask,
            ),
          ],
        ),
      ),
    );
  }
}
