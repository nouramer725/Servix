import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Color(0xFF333739)
          : Colors.white,
      body: Center(
        child: Column(
          children: [
            StreamBuilder(
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
            const SizedBox(height: 10),
            Text(
              userData != null
                  ? " ${userData!['first_name']} ${userData!['last_name']}"
                  : "Welcome".tr(),
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: GoogleFonts.castoro(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
