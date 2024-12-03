import 'package:flutter/material.dart';
import '/screens/login_screen.dart';
import '/screens/setup_screen.dart';
import '/screens/leaderboard_screen.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Style Quiz App',
      theme: ThemeData(
        primaryColor: Color(0xFF075E54), // WhatsApp primary color
        secondaryHeaderColor: Color(0xFF25D366), // WhatsApp accent color
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: LoginScreen(),
      routes: {
        //'/setup': (context) => SetupScreen(),
        '/leaderboard': (context) => LeaderboardScreen(),
      },
    );
  }
}
