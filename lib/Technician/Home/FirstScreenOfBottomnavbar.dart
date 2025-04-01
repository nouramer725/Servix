import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Technician/Profile/Profile.dart';
import '../../../../Theme/Theme_Provider.dart';

class HomeTechFirstScreen extends StatefulWidget {
  const HomeTechFirstScreen({super.key});

  @override
  State<HomeTechFirstScreen> createState() => _HomeTechFirstScreenState();
}

class _HomeTechFirstScreenState extends State<HomeTechFirstScreen> {
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

  void _loadUserData() async {
    var data = await getUserData();
    if (!mounted) return;
    setState(() {
      userData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileTechnician()));
                },
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("user-files")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("uploads")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      String personalFileUrl =
                          snapshot.data!.docs.first['personalFileUrl'];
                      return CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 70, // ✅ Adjust size
                        backgroundImage: NetworkImage(
                            personalFileUrl), // ✅ Fetch from Firestore
                      );
                    }
                    return const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 70,
                      child: Icon(Icons.person, size: 100),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(
                userData != null
                    ? " ${userData!['first_name']} ${userData!['last_name']}"
                    : "Welcome".tr(),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: GoogleFonts.castoro(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black),
              ),
              const SizedBox(
                height: 40,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.grey.shade700
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 0.5,
                            blurRadius: 5,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text(
                              "0",
                              style: GoogleFonts.castoro(
                                  fontSize: 40, color: const Color(0xFF9A9A9A)),
                            ),
                            const SizedBox(height: 10),
                            Text("Total Jobs",
                                style: GoogleFonts.castoro(
                                    fontSize: 16, color: const Color(0xFF9A9A9A))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.grey.shade700
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 0.5,
                            blurRadius: 5,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text(
                              "3.2",
                              style: GoogleFonts.castoro(
                                  fontSize: 40, color: const Color(0xFF9A9A9A)),
                            ),
                            const SizedBox(height: 10),
                            Text("Review",
                                style: GoogleFonts.castoro(
                                    fontSize: 16, color: const Color(0xFF9A9A9A))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white.withOpacity(0.5)
                    : const Color(0xFFD0D0D0),
                indent: 40,
                endIndent: 40,
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pending Orders",
                    style: GoogleFonts.castoro(
                        fontSize: 22,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFF9A9A9A),
                        fontWeight: FontWeight.w500,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : const Color(0xFF7B7B7B)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
