import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String firstName = '';
  String lastName = '';
  String email = '';
  String role = 'User';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Get the currently signed-in user
      User? user = _auth.currentUser;
      if (user != null) {
        setState(() {
          email = user.email ?? 'No Email';
        });

        // Fetch user details from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            firstName = userDoc['firstName'] ?? '';
            lastName = userDoc['lastName'] ?? '';
            role = userDoc['role'] ?? 'User';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'assets/profile_placeholder.png'), // Placeholder image
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Name: $firstName $lastName",
                      style: Theme.of(context).textTheme.bodyLarge),
                  SizedBox(height: 10),
                  Text("Email: $email",
                      style: Theme.of(context).textTheme.bodyLarge),
                  SizedBox(height: 10),
                  Text("Role: $role",
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
    );
  }
}
