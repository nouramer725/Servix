import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servix/Member/MemberShip.dart';
import 'Login-Register/Sign_In_Client.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? userData;

  Future<Map<String, dynamic>?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    var data = await getUserData();
    if (!mounted) return; // ✅ Prevent setState() after widget is disposed
    setState(() {
      userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 10),
            Text(userData != null
                ? "Welcome ${userData!['first_name']} ${userData!['last_name']}!"
                : "Welcome"),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemberShip()));
            },
          )
        ],
      ),
      body: userData == null
          ? const Center(
          child: CircularProgressIndicator()
      ) // Show loader until data loads
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),

            Text("First Name: ${userData?['first_name'] ?? 'N/A'}"),
            Text("Last Name: ${userData?['last_name'] ?? 'N/A'}"),
            Text("Email: ${userData?['email'] ?? 'N/A'}"),
            Text("Phone: ${userData?['phone'] ?? 'N/A'}"),
            Text("Gender: ${userData?['gender'] ?? 'N/A'}"),
          ],
        ),
      ),
    );
  }
}