import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerMenu extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    if (user == null) {
      return Center(child: Text("No user found"));
    }

    return Drawer(
      child: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("User data not found"));
          }

          var userData = snapshot.data!;
          String firstName = userData['firstName'] ?? '';
          String lastName = userData['lastName'] ?? '';
          String email = userData['email'] ?? '';
          String role = userData['role'] ?? 'User';

          return ListView(
            children: [
              DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                          'assets/profile_placeholder.png'), // Placeholder image
                    ),
                    SizedBox(height: 10),
                    Text(
                      "$firstName $lastName",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      email,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      role,
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading:
                    Icon(Icons.home, color: Theme.of(context).primaryColor),
                title: Text("Message Boards"),
                onTap: () => Navigator.pushNamed(context, '/home'),
              ),
              ListTile(
                leading:
                    Icon(Icons.person, color: Theme.of(context).primaryColor),
                title: Text("Profile"),
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
              ListTile(
                leading:
                    Icon(Icons.settings, color: Theme.of(context).primaryColor),
                title: Text("Settings"),
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.red),
                title: Text("Logout"),
                onTap: () async {
                  await _auth.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
