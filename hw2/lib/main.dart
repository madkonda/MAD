import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = ''; // To hold the user input
  String result = ''; // To hold the calculated result
  String operator = ''; // To store the operator
  double operand1 = 0; // First operand
  double operand2 = 0; // Second operand

  // Function to handle button press
  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '';
        operator = '';
        operand1 = 0;
        operand2 = 0;
      } else if (value == '+' || value == '-' || value == '*' || value == '/') {
        operand1 = double.parse(input);
        operator = value;
        input = '';
      } else if (value == '=') {
        operand2 = double.parse(input);
        switch (operator) {
          case '+':
            result = (operand1 + operand2).toString();
            break;
          case '-':
            result = (operand1 - operand2).toString();
            break;
          case '*':
            result = (operand1 * operand2).toString();
            break;
          case '/':
            result = operand2 != 0 ? (operand1 / operand2).toString() : 'Error';
            break;
        }
        input = result;
      } else {
        input += value; // Append the number or decimal point
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Text(
                input,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          buildButtons(),
        ],
      ),
    );
  }

  // Function to build the calculator buttons
  Widget buildButtons() {
    return Column(
      children: [
        Row(
          children: [
            buildButton('7'),
            buildButton('8'),
            buildButton('9'),
            buildButton('/'),
          ],
        ),
        Row(
          children: [
            buildButton('4'),
            buildButton('5'),
            buildButton('6'),
            buildButton('*'),
          ],
        ),
        Row(
          children: [
            buildButton('1'),
            buildButton('2'),
            buildButton('3'),
            buildButton('-'),
          ],
        ),
        Row(
          children: [
            buildButton('0'),
            buildButton('.'),
            buildButton('='),
            buildButton('+'),
          ],
        ),
        Row(
          children: [
            buildButton('C'), // Clear button
          ],
        ),
      ],
    );
  }

  Widget buildButton(String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(value),
          child: Text(
            value,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
