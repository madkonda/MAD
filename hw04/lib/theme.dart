import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF075E54); // WhatsApp green
  static const Color secondaryColor =
      Color(0xFF25D366); // WhatsApp lighter green
  static const Color backgroundColor = Color(0xFFECE5DD); // WhatsApp background

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondaryColor),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
      ),
    );
  }
}
