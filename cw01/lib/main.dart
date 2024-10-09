import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter and Image Toggle App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterImageReset(),
    );
  }
}

class CounterImageReset extends StatefulWidget {
  @override
  _CounterImageResetState createState() => _CounterImageResetState();
}

class _CounterImageResetState extends State<CounterImageReset> {
  int _counter = 0;
  bool _isFirstImage = true;
  final String _image1 = 'assets/image1.png';
  final String _image2 = 'assets/image2.png';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _toggleImage() {
    setState(() {
      _isFirstImage = !_isFirstImage;
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
      _isFirstImage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CW1'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                'Task 1: Increment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Column(
                children: <Widget>[
                  Text(
                    'Counter: $_counter',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _incrementCounter,
                    child: Text('Increment'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                'Task 2: Image Toggle',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Column(
                children: <Widget>[
                  Image.asset(
                    _isFirstImage ? _image1 : _image2,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        'Image not found',
                        style: TextStyle(fontSize: 24, color: Colors.red),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _toggleImage,
                    child: Text('Toggle Image'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                'Task 3: Reset',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _reset,
                child: Text('Reset'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
