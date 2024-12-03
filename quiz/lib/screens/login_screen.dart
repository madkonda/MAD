import 'package:flutter/material.dart';
import '../screens/setup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();

  void _navigateToSetup() {
    if (_nameController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SetupScreen(
            playerName: _nameController.text,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff128C7E), // WhatsApp background color
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome to Quiz App',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.white70),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToSetup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff25D366), // WhatsApp button color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Start Quiz',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
