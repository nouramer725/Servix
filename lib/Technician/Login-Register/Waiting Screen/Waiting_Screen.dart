import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Technician/AITechnician/Welcome%20AI.dart';
import '../../../constents/constent.dart';

class WaitingScreen extends StatefulWidget {
  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final String adminEmail = "servixcomp5@gmail.com"; // Change this
  final String senderEmail = "servixcomp5@gmail.com"; // Your email
  final String senderPassword = "mqjg cbsx lypp repw"; // Use an app password

  @override
  void initState() {
    super.initState();
    _checkApprovalStatus();
    _sendEmailToAdmin();
  }

  Future<void> _checkApprovalStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection("technician")
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        String status = snapshot.data()?['status'] ?? 'pending';
        if (status == "approved") {
          // ✅ Check if the widget is still mounted before navigation
          if (mounted) {
            Future.microtask(() {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => WelcomeAiTech()),
                (route) => false,
              );
            });
          }
        }
      }
    });
  }

  Future<void> _sendEmailToAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDocRef =
        FirebaseFirestore.instance.collection('technician').doc(user.uid);
    final userDoc = await userDocRef.get();
    final userData = userDoc.data();

    if (userData == null) {
      print("User data not found.");
      return;
    }

    // ✅ Check if email was already sent
    if (userData.containsKey('emailSent') && userData['emailSent'] == true) {
      print("Email already sent, skipping...");
      return;
    }

    try {
      final smtpServer = gmail(senderEmail, senderPassword);
      final String firestoreLink =
          "https://console.firebase.google.com/project/chat-app-ea642/firestore/databases/-default-/data/~2Ftechnician~2F${user.uid}";

      final message = Message()
        ..from = Address(senderEmail, "Servix")
        ..recipients.add(adminEmail)
        ..subject = "New Technician Approval Needed"
        ..html = """
      <h3>New Technician Registration</h3>
      <p>Name: ${userData['first_name']} ${userData['last_name']}</p>
      <p>User ID: ${user.uid}</p>
      <p>Click below to approve/reject:</p>
      <a href="$firestoreLink">🔗 Open in Firestore</a>
      """;

      await send(message, smtpServer);
      print("Email sent successfully!");

      // ✅ Update Firestore to prevent duplicate emails
      await userDocRef.update({'emailSent': true});
    } catch (e) {
      print("Error sending email: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("technician")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text("User data not found.".tr()));
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String status = userData['status'] ?? 'pending';

            return Padding(
              padding: const EdgeInsets.all(20.0),
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
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 40, horizontal: 10),
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
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
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
                              // ✅ User Name
                              Text(
                                "${userData['first_name']} ${userData['last_name']}",
                                style: GoogleFonts.cantataOne(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 40),

                              // ✅ Status Message
                              if (status == "approved") ...[
                                Text(
                                  "🎉 Congratulations! You’re officially approved! 🚀 Enjoy full access to our platform and start your journey today!"
                                      .tr(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cantataOne(
                                    color: Colors.green,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ] else if (status == "rejected") ...[
                                Text(
                                  "❌ Unfortunately, your application was not approved. If you believe this is a mistake, please contact support for further assistance."
                                      .tr(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cantataOne(
                                    color: Colors.red,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  "Thank you for registering as a technician. Your application is currently under review by our administration team. You will receive a notification once your account has been approved."
                                      .tr(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cantataOne(
                                    color: Colors.white,
                                    fontSize: 17,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
