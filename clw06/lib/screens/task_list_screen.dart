import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';
import 'auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String selectedPriorityFilter = 'All';
  String selectedSortOption = 'Due Date';
  bool showCompletedOnly = false;
  bool showIncompleteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterAndSortOptions(),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _firebaseService.getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                var tasks = snapshot.data ?? [];
                tasks = _applyFiltersAndSorting(tasks);

                // Show a popup if there are no tasks for the current user
                if (tasks.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showNoTasksDialog();
                  });
                  return Center(child: Text('No tasks available'));
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (ctx, index) => TaskItem(task: tasks[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  // Method to show the "No Tasks" dialog for new users
  void _showNoTasksDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Welcome!"),
        content: Text(
            "It looks like you don't have any tasks yet. Add your first task to get started!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  // Method to show the add task dialog
  void _showAddTaskDialog() {
    final TextEditingController nameController = TextEditingController();
    String priority = 'Medium';
    DateTime dueDate = DateTime.now().add(Duration(days: 1));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            DropdownButtonFormField<String>(
              value: priority,
              items: ['High', 'Medium', 'Low'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  priority = value;
                }
              },
              decoration: InputDecoration(labelText: 'Priority'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (pickedDate != null) {
                  dueDate = pickedDate;
                }
              },
              child: Text("Select Due Date"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final task = Task(
                  id: DateTime.now().toString(),
                  name: nameController.text,
                  priority: priority,
                  dueDate: dueDate,
                  userId: FirebaseAuth
                      .instance.currentUser!.uid, // Assign userId to the task
                );
                _firebaseService.addTask(task);
                Navigator.of(ctx).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterAndSortOptions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          DropdownButton<String>(
            value: selectedPriorityFilter,
            items: ['All', 'High', 'Medium', 'Low']
                .map((priority) => DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedPriorityFilter = value!;
              });
            },
          ),
          Spacer(),
          DropdownButton<String>(
            value: selectedSortOption,
            items: ['Priority', 'Due Date', 'Completion Status']
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedSortOption = value!;
              });
            },
          ),
          Spacer(),
          Row(
            children: [
              Text("Completed Only"),
              Switch(
                value: showCompletedOnly,
                onChanged: (value) {
                  setState(() {
                    showCompletedOnly = value;
                    showIncompleteOnly = !value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              Text("Incomplete Only"),
              Switch(
                value: showIncompleteOnly,
                onChanged: (value) {
                  setState(() {
                    showIncompleteOnly = value;
                    showCompletedOnly = !value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Task> _applyFiltersAndSorting(List<Task> tasks) {
    if (selectedPriorityFilter != 'All') {
      tasks = tasks
          .where((task) => task.priority == selectedPriorityFilter)
          .toList();
    }

    if (showCompletedOnly) {
      tasks = tasks.where((task) => task.isCompleted).toList();
    } else if (showIncompleteOnly) {
      tasks = tasks.where((task) => !task.isCompleted).toList();
    }

    if (selectedSortOption == 'Priority') {
      tasks.sort((a, b) => a.priority.compareTo(b.priority));
    } else if (selectedSortOption == 'Due Date') {
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (selectedSortOption == 'Completion Status') {
      tasks.sort((a, b) => a.isCompleted ? 1 : -1);
    }

    return tasks;
  }
}
