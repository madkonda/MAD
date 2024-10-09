import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Book',
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary:
              Colors.white, // Replace accentColor with colorScheme.secondary
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              color: Colors.black, fontSize: 18), // Replaces bodyText1
          bodyMedium: TextStyle(
              color: Colors.black, fontSize: 16), // Replaces bodyText2
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
