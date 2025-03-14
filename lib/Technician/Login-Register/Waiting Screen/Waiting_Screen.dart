import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
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
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play(); // Start confetti animation
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  numberOfParticles: 20,
                  gravity: 0.2,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  numberOfParticles: 20,
                  gravity: 0.2,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  numberOfParticles: 20,
                  gravity: 0.2,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  numberOfParticles: 20,
                  gravity: 0.2,
                ),
              ),
              Center(
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: ApplicationColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
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
                              String personalFileUrl =
                              snapshot.data!.docs.first['personalFileUrl'];
                              return CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(personalFileUrl),
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
                      const SizedBox(height: 15),

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
                              style: GoogleFonts.charisSil(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }
                          return const Text(
                            "Loading...",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          );
                        },
                      ),
                      const SizedBox(height: 40),

                      // ✅ "Thank you" message
                      Padding(
                        padding: const EdgeInsets.only(left: 13, right: 13),
                        child: Text(
                          "Thank you for registering as a technician. Your application is currently under review by our administration team.\n"
                              "This process ensures that all technicians meet our service standards.\n"
                              "You will receive a notification once your account has been approved.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cantataOne(
                            color: Colors.white,
                            fontSize: 15,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
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
