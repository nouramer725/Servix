import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servix/Member/MemberShip.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeTechnician extends StatefulWidget {
  @override
  _HomeTechnicianState createState() => _HomeTechnicianState();
}

class _HomeTechnicianState extends State<HomeTechnician> {
  Map<String, dynamic>? userData;

  Future<Map<String, dynamic>?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('technician')
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
    if (!mounted) return; // Prevent setState() after widget is disposed
    setState(() {
      userData = data;
    });
  }

  /// Calculates the age from the given date string in "yyyy-MM-dd" format.
  int calculateAge(String dobString) {
    try {
      DateTime dob = DateTime.parse(dobString);
      DateTime today = DateTime.now();
      int age = today.year - dob.year;
      if (today.month < dob.month ||
          (today.month == dob.month && today.day < dob.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0; // Fallback in case of parsing error
    }
  }

  @override
  Widget build(BuildContext context) {
    // If userData is loaded and date_of_birth exists, calculate the age.
    String dobDisplay = "N/A";
    String ageDisplay = "N/A";
    if (userData != null && userData!['date_of_birth'] != null) {
      dobDisplay = userData!['date_of_birth'];
      int age = calculateAge(dobDisplay);
      ageDisplay = age.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 10),
            Text(
              userData != null
                  ? "Welcome".tr() +
                      " ${userData!['first_name']} ${userData!['last_name']}!"
                  : "Welcome".tr(),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MemberShip()),
              );
            },
          )
        ],
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text("First Name: ".tr() +
                      "${userData?['first_name'] ?? 'N/A'}"),
                  Text("Last Name: ".tr() +
                      "${userData?['last_name'] ?? 'N/A'}"),
                  Text("Email: ".tr() + "${userData?['email'] ?? 'N/A'}"),
                  Text("Phone: ".tr() + "${userData?['phone'] ?? 'N/A'}"),
                  Text("Gender: ".tr() + "${userData?['gender'] ?? 'N/A'}"),
                  Text("Main Service: ".tr() +
                      "${userData?['main_service'] ?? 'N/A'}"),
                  Text("Sub Service: ".tr() +
                      "${userData?['sub_service'] ?? 'N/A'}"),
                  Text("Date of Birth: ".tr() + "$dobDisplay"),
                  Text("Age: ".tr() + "$ageDisplay"),
                ],
              ),
            ),
    );
  }
}
