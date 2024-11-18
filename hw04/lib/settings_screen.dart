import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  Future<void> editProfile(BuildContext context) async {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();

    // Show a dialog for editing profile
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => isLoading = true);

              try {
                User? user = _auth.currentUser;
                if (user != null) {
                  await _firestore.collection('users').doc(user.uid).update({
                    'firstName': firstNameController.text,
                    'lastName': lastNameController.text,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Profile updated successfully!")),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error updating profile: $e")),
                );
              } finally {
                setState(() => isLoading = false);
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> changePassword(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();

    // Show a dialog for changing the password
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Change Password"),
        content: TextField(
          controller: passwordController,
          decoration: InputDecoration(labelText: 'New Password'),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => isLoading = true);

              try {
                User? user = _auth.currentUser;
                if (user != null) {
                  await user.updatePassword(passwordController.text);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Password changed successfully!")),
                  );
                }
              } on FirebaseAuthException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${e.message}")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Unexpected error: $e")),
                );
              } finally {
                setState(() => isLoading = false);
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading:
                        Icon(Icons.edit, color: Theme.of(context).primaryColor),
                    title: Text("Edit Profile"),
                    onTap: () => editProfile(context),
                  ),
                  Divider(),
                  ListTile(
                    leading:
                        Icon(Icons.lock, color: Theme.of(context).primaryColor),
                    title: Text("Change Password"),
                    onTap: () => changePassword(context),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.red),
                    title: Text("Logout"),
                    onTap: () async {
                      await _auth.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
