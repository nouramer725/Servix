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
                  const SizedBox(height: 100),
                  _buildFilesOfImages()
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

  Widget _buildFilesOfImages() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("user-files")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("uploads")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List userUploadedFiles = snapshot.data!.docs;
          if (userUploadedFiles.isEmpty) {
            return Center(
              child: Text("No files uploaded"),
            );
          } else {
            return GridView.builder(
              shrinkWrap: true, // ✅ Allows GridView to fit inside another scrollable widget
              physics: NeverScrollableScrollPhysics(), // ✅ Prevents nested scrolling issues
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // ✅ Ensures 2 images per row
                childAspectRatio: 3, // ✅ Adjust this to control height-to-width ratio
                crossAxisSpacing: 10, // ✅ Spacing between columns
                mainAxisSpacing: 10, // ✅ Spacing between rows
              ),
              itemCount: userUploadedFiles.length,
              itemBuilder: (context, index) {
                String backIDUrl = userUploadedFiles[index]['backIDUrl'];
                String criminalRecordUrl = userUploadedFiles[index]['criminalRecordUrl'];
                String frontIDUrl = userUploadedFiles[index]['frontIDUrl'];
                String personalFileUrl = userUploadedFiles[index]['personalFileUrl'];
                String nationalId = userUploadedFiles[index]['nationalId'];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.network(
                        personalFileUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Image.network(
                      frontIDUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Image.network(
                        backIDUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Image.network(
                        criminalRecordUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              },
            );

          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
