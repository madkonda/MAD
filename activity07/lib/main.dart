import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InteractiveAnimations(),
    );
  }
}

class InteractiveAnimations extends StatefulWidget {
  @override
  _InteractiveAnimationsState createState() => _InteractiveAnimationsState();
}

class _InteractiveAnimationsState extends State<InteractiveAnimations>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  bool _showFrame = false;
  bool _isFadingImageVisible = true;

  // For rotation animation
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void toggleFrame(bool value) {
    setState(() {
      _showFrame = value;
    });
  }

  void toggleFadingImage() {
    setState(() {
      _isFadingImageVisible = !_isFadingImageVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Animations'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Fading and Rotating Text Animation
          Center(
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: Duration(seconds: 2), // Experiment with duration
              curve: Curves.easeInOut, // Experiment with different curves
              child: const Text(
                'Hello, Luffy GomuGomuNo!',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Toggle Frame for Image
          SwitchListTile(
            title: Text('Show Frame Around Image'),
            value: _showFrame,
            onChanged: toggleFrame,
          ),
          SizedBox(height: 10),

          // Image with Toggleable Frame and Rounded Corners
          Container(
            decoration: _showFrame
                ? BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 5),
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(15), // Even if no frame
                  ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/flutter_logo.png', // Image from assets
                width: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error,
                    size: 100,
                    color: Colors.red,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),

          // Fading and Rotating Image
          Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: toggleFadingImage,
                  child: Text('Toggle Fading Image'),
                ),
                AnimatedOpacity(
                  opacity: _isFadingImageVisible ? 1.0 : 0.0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  child: AnimatedBuilder(
                    animation: _controller,
                    child: Image.asset(
                      'assets/images/flutter_logo.png',
                      width: 150,
                    ),
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.value * 2.0 * math.pi,
                        child: child,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
