import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int timeLeft;

  TimerWidget({required this.timeLeft});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: timeLeft / 15,
            strokeWidth: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff25D366)),
          ),
        ),
        Text(
          '$timeLeft',
          style: TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}
