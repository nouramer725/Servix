import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servix/Member/MemberShip.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? userData;
  bool isTechnician = false; // Default to client
  bool isClient = false; // Track if the user is in the users collection


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


  Future<void> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // First, check if user exists in the technicians collection
      DocumentSnapshot technicianDoc = await FirebaseFirestore.instance
          .collection('technician')
          .doc(user.uid)
          .get();

      if (technicianDoc.exists) {
        setState(() {
          isTechnician = true; // Mark user as technician
          userData = technicianDoc.data() as Map<String, dynamic>?;
          isClient = false; // Not a client
        });
      } else {
        // If not found in technicians, check users collection
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            isTechnician = false; // Mark user as client
            isClient = true; // Mark user as existing in users collection
            userData = userDoc.data() as Map<String, dynamic>?;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
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
            if(isTechnician) ...{
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("user-files")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("uploads")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.docs.isNotEmpty) {
                      String personalFileUrl =
                      snapshot.data!.docs.first['personalFileUrl'];
                      return CircleAvatar(
                        radius: 25, // ✅ Adjust size
                        backgroundImage: NetworkImage(
                            personalFileUrl), // ✅ Fetch from Firestore
                      );
                    }
                    return CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(
                          "assets/images/lang-member/langmem.png"), // ✅ Default image
                    );
                  }),
            },
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MemberShip()),
              );
            },
          )
        ],
      ),
      body: userData == null
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loader until data loads
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  // Display user information
                  Text("First Name: ${userData?['first_name'] ?? 'N/A'}"),
                  Text("Last Name: ${userData?['last_name'] ?? 'N/A'}"),
                  Text("Email: ${userData?['email'] ?? 'N/A'}"),
                  Text("Phone: ${userData?['phone'] ?? 'N/A'}"),
                  Text("Gender: ${userData?['gender'] ?? 'N/A'}"),

                  SizedBox(height: 16),

                  if (isTechnician) ...[

                    Text("Date of Birth: ${userData?['date_of_birth'] ?? 'N/A'}"),
                    Text("Age: ${ageDisplay} "),
                    Text("Role: Technnician"),
                    Text("Main Service: ${userData?['main_service'] ?? 'N/A'}"),
                    Text("Sub Service: ${userData?['sub_service'] ?? 'N/A'}"),

                  ],
                ],
              ),
            ),
    );
  }
}
