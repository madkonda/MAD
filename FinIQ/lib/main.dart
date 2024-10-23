import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dashboard.dart'; // Assuming Dashboard class is defined in dashboard.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isLoggedIn = false; // Track login state

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Set animation duration
    );

    // Define slide animation from top to original position
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1), // Start from above
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Define fade animation
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller
    super.dispose();
  }

  void _login() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username == 'madhu' && password == 'konda') {
      setState(() {
        _isLoggedIn = true;
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Incorrect username or password.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // WhatsApp style white background
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color(0xFF075E54), // WhatsApp green color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50.0), // Add space at the top

              // WhatsApp styled logo/text
              Center(
                child: Text(
                  'FinIQ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF075E54),
                  ),
                ),
              ),
              SizedBox(height: 40.0),

              // Animated username field
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Phone number or email',
                      labelStyle: TextStyle(color: Color(0xFF075E54)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF075E54), width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              // Animated password field
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Color(0xFF075E54)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF075E54), width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              // Animated login button
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF25D366), // WhatsApp green button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 16.0), // Larger button
                    ),
                    onPressed: _login,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              // Optional: Register or Forgot Password links
              FadeTransition(
                opacity: _fadeAnimation,
                child: TextButton(
                  onPressed: () {
                    // Add forgot password logic
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Color(0xFF075E54)),
                  ),
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: TextButton(
                  onPressed: () {
                    // Add registration logic
                  },
                  child: Text(
                    'New to App? Register now',
                    style: TextStyle(color: Color(0xFF075E54)),
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
