import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servix/Member/MemberShip.dart';
import 'package:easy_localization/easy_localization.dart';
import '../Login-Register/Database for personal information.dart';

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
    if (!mounted) return;
    setState(() {
      userData = data;
    });
  }

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
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    String dobDisplay = "N/A";
    String ageDisplay = "N/A";
    if (userData != null && userData!['date_of_birth'] != null) {
      dobDisplay = userData!['date_of_birth'];
      int age = calculateAge(dobDisplay);
      ageDisplay = age.toString();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                userData != null
                    ? "Welcome".tr() +
                        " ${userData!['first_name']} ${userData!['last_name']}!"
                    : "Welcome".tr(),
                overflow: TextOverflow.ellipsis,
              ),
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(userData!, dobDisplay, ageDisplay),
                  const SizedBox(height: 20),
                  _buildUserImages(),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> data, String dob, String age) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("First Name", data['first_name']),
            _buildInfoRow("Last Name", data['last_name']),
            _buildInfoRow("Email", data['email']),
            _buildInfoRow("Phone", data['phone']),
            _buildInfoRow("Gender", data['gender']),
            _buildInfoRow("Main Service", data['main_service']),
            _buildInfoRow("Sub Service", data['sub_service']),
            _buildInfoRow("Date of Birth", dob),
            _buildInfoRow("Age", age),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
          Text(value ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildUserImages() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getUserData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final userData = snapshot.data!.isNotEmpty ? snapshot.data!.last : null;
        if (userData == null)
          return const Center(child: Text("No data available"));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "National ID: ${userData['nationalID']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ).tr(),
            ),
            _buildLabeledImage("Personal Image", userData['personalImage']),
            _buildLabeledImage("Front ID", userData['frontID']),
            _buildLabeledImage("Back ID", userData['backID']),
            _buildLabeledImage("Criminal Record", userData['criminalRecord']),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget _buildLabeledImage(String label, String imagePath) {
    return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold))
                  .tr(),
              const SizedBox(height: 5),
              Container(
                width: double.infinity, // Full width
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imagePath.isNotEmpty
                    ? Image.file(
                        File(imagePath),
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image,
                                size: 50, color: Colors.grey),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.image_not_supported,
                            size: 50, color: Colors.grey)),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ));
  }
}
