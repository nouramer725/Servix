import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constents/constent.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: ApplicationColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 10,
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 40.0, bottom: 40, left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✅ Profile Image
                        CircleAvatar(
                          radius: 50,
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("user-files")
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .collection("uploads")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data!.docs.isNotEmpty) {
                                String personalFileUrl = snapshot
                                    .data!.docs.first['personalFileUrl'];
                                return CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(personalFileUrl),
                                );
                              }
                              return const CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                    "assets/images/lang-member/langmem.png"),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),

                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("technician")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.exists) {
                              var userData = snapshot.data!.data();
                              return Text(
                                "${userData?['first_name']} ${userData?['last_name']}",
                                style: GoogleFonts.cantataOne(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }
                            return const Text(
                              "Loading...",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            );
                          },
                        ),
                        const SizedBox(height: 40),

                        // ✅ "Thank you" message
                        Text(
                          "Thank you for registering as a technician. Your application is currently under review by our administration team.This process ensures that all technicians meet our service standards.You will receive a notification once your account has been approved.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cantataOne(
                            color: Colors.white,
                            fontSize: 17,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
