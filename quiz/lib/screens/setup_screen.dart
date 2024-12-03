import 'package:flutter/material.dart';
import '/screens/quiz_screen.dart';
import '/screens/leaderboard_screen.dart';
import '/services/api_service.dart';

class SetupScreen extends StatefulWidget {
  final String playerName;

  SetupScreen({required this.playerName});

  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _selectedNumber = 10;
  String? _selectedCategory;
  String _selectedDifficulty = 'easy';
  String _selectedType = 'multiple';
  List<dynamic> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() async {
    List<dynamic> categories = await ApiService.getCategories();
    setState(() {
      _categories = categories;
    });
  }

  void _startQuiz() {
    if (_selectedCategory != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            playerName: widget.playerName,
            numberOfQuestions: _selectedNumber,
            category: _selectedCategory!,
            difficulty: _selectedDifficulty,
            type: _selectedType,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')),
      );
    }
  }

  void _viewLeaderboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeaderboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize Your Quiz'),
        backgroundColor: Color(0xff075E54),
      ),
      body: _categories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  Text(
                    'Welcome, ${widget.playerName}!',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  // Number of Questions
                  Text(
                    'Select Number of Questions',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<int>(
                    value: _selectedNumber,
                    items: [5, 10, 15]
                        .map((num) => DropdownMenuItem<int>(
                              value: num,
                              child: Text(num.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedNumber = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  // Category
                  Text(
                    'Select Category',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    hint: Text('Choose a category'),
                    value: _selectedCategory,
                    items: _categories
                        .map((cat) => DropdownMenuItem<String>(
                              value: cat['id'].toString(),
                              child: Text(cat['name']),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  // Difficulty
                  Text(
                    'Select Difficulty',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: _selectedDifficulty,
                    items: ['easy', 'medium', 'hard']
                        .map((level) => DropdownMenuItem<String>(
                              value: level,
                              child: Text(level),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDifficulty = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  // Type
                  Text(
                    'Select Question Type',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: _selectedType,
                    items: [
                      {'value': 'multiple', 'text': 'Multiple Choice'},
                      {'value': 'boolean', 'text': 'True / False'}
                    ]
                        .map((type) => DropdownMenuItem<String>(
                              value: type['value'],
                              child: Text(type['text']!),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _startQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff25D366),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      'Start Quiz',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _viewLeaderboard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff128C7E),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      'View Leaderboard',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
