import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/Language/Language.dart';
import 'package:servix/Member/MemberShip.dart';
import 'package:servix/Settings/About%20US.dart';
import 'package:servix/Settings/Contact%20Us.dart';
import 'package:servix/Settings/Password.dart';
import 'package:servix/Settings/Privacy%20Policy.dart';
import 'package:servix/Settings/Terms%20&%20Conditions.dart';
import 'package:servix/Technician/Home/HomeTechnician.dart';
import 'package:servix/Technician/Profile/Profile.dart';
import 'package:servix/constents/constent.dart';
import 'package:share_plus/share_plus.dart';

import '../../On-Boarding/On_Boarding_Screen.dart';

class HomeTechnicianLayout extends StatefulWidget {
  const HomeTechnicianLayout({super.key});
  @override
  State<HomeTechnicianLayout> createState() => _HomeTechnicianLayoutState();
}

class _HomeTechnicianLayoutState extends State<HomeTechnicianLayout> {
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

  bool isDarkMode = false; // Default mode

  final List<Widget> pages = [
    HomeTechnician(),
    const TermsAndConditions(),
    const Contactus(),
    const AboutUs(),
  ];
  int selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.density_small_sharp, color: ApplicationColor),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Opens the sidebar
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
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
                          radius: 40, // ✅ Adjust size
                          backgroundImage: NetworkImage(
                              personalFileUrl), // ✅ Fetch from Firestore
                        );
                      }
                      return const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                            "assets/images/lang-member/langmem.png"), // ✅ Default image
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
                        fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  _buildMenuItem(Icons.person_outline, "Profile", onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(),
                        ));
                  }),
                  _buildMenuItem(Icons.info_outline, "About Us", onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutUs(),
                        ));
                  }),
                  _buildMenuItem(Icons.article_outlined, "Terms & Conditions",
                      onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsAndConditions(),
                        ));
                  }),
                  _buildMenuItem(Icons.privacy_tip_outlined, "Privacy Policy",
                      onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivacyPolicy(),
                        ));
                  }),
                  _buildMenuItem(Icons.lock_outline, "Password", onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Password(),
                        ));
                  }),
                  // **Language Dropdown**
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.language, color: ApplicationColor),
                        const SizedBox(width: 16),
                        Text(
                          "Language",
                          style: GoogleFonts.castoro(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        DropdownButton<String>(
                          value: "English",
                          onChanged: (String? newValue) {},
                          items: <String>["English", "Arabic", "French"]
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  _buildMenuItem(Icons.share, "Share App", onTap: () {
                    String quoteText = "💡Join the Servix community! Get expert help for any service you need—quick, easy, and hassle-free. Download now!";
                    Share.share(quoteText);
                  }),
                  _buildMenuItem(Icons.phone_outlined, "Contact Us", onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Contactus(),
                        ));
                  }),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.dark_mode, color: ApplicationColor),
                        const SizedBox(width: 16),
                        Text(
                          "Dark Theme",
                          style: GoogleFonts.castoro(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Switch(
                          activeTrackColor: ApplicationColor,
                          value: isDarkMode,
                          onChanged: (bool value) {
                            setState(() {
                              isDarkMode = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildMenuItem(Icons.logout, "Logout", onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemberShip(),
                      ),
                      (route) => false,
                    );
                  }),
                  _buildMenuItem(Icons.delete, "Delete Account", onTap: () {
                    showDialog(
                        barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: Row(
                          children: [
                            Icon(Icons.delete_outlined,
                                size: 25,
                                color: ApplicationColor),
                            SizedBox(width: 8),
                            Text("Delete Account",
                                style: GoogleFonts.charisSil(
                                    color: ApplicationColor3,
                                fontWeight: FontWeight.bold)),
                          ],
                        ),
                        content: Text(
                            "Are you sure you want to delete your account?",
                            style:
                                GoogleFonts.charisSil(color: ApplicationColor3, fontSize: 18)),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel",
                                    style: GoogleFonts.castoro(
                                        fontSize: 20,
                                        color: ApplicationColor3, fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  deleteAccount(context);
                                },
                                child: Text("Delete", style: GoogleFonts.castoro(
                                    fontSize: 20,
                                    color: ApplicationColor, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ApplicationColor,
        unselectedItemColor: ApplicationColor3,
        selectedLabelStyle: const TextStyle(fontSize: 15),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedIconTheme: const IconThemeData(
          size: 30,
        ),
        selectedIconTheme: const IconThemeData(size: 35),
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(
              Icons.home_outlined,
              color: ApplicationColor3,
            ),
            label: "Home",
            activeIcon: Icon(
              Icons.home,
              color: ApplicationColor,
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications_none_outlined,
                color: ApplicationColor3,
              ),
              label: "Notifications",
              activeIcon: Icon(
                Icons.notifications,
                color: ApplicationColor,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.description_outlined,
                color: ApplicationColor3,
              ),
              label: "Orders",
              activeIcon: Icon(
                Icons.description,
                color: ApplicationColor,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.smart_toy_outlined,
                color: ApplicationColor3,
              ),
              label: "Ai Chat",
              activeIcon: Icon(
                Icons.smart_toy,
                color: ApplicationColor,
              )),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: ApplicationColor),
      title: Text(
        title,
        style: GoogleFonts.castoro(fontSize: 20, fontWeight: FontWeight.w500),
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap ?? () {},
    );
  }
  void deleteAccount(BuildContext context) async {
    try {
      // Get current user
      User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;

      if (userId != null && user != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentReference userDoc = firestore.collection('user-files').doc(userId);

        // Reauthenticate the user before deleting their account
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: "USER_PASSWORD", // You must get the user’s password (use a dialog)
        );

        await user.reauthenticateWithCredential(credential);

        // Delete 'uploads' subcollection
        QuerySnapshot uploadsSnapshot = await userDoc.collection('uploads').get();
        for (var doc in uploadsSnapshot.docs) {
          await doc.reference.delete();
        }

        // Delete 'locationDetails' subcollection
        QuerySnapshot locationSnapshot = await userDoc.collection('locationDetails').get();
        for (var doc in locationSnapshot.docs) {
          await doc.reference.delete();
        }

        // Delete user document from 'user-files'
        await userDoc.delete().catchError((error) {
          print("Error deleting user from 'user-files': $error");
        });

        // Delete user document from 'technician'
        await firestore.collection('technician').doc(userId).delete().catchError((error) {
          print("Error deleting user from 'technician': $error");
        });

        // Delete the user from Firebase Authentication
        await user.delete();

        // Sign out the user
        await FirebaseAuth.instance.signOut();

        // Navigate to the login or onboarding screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardingScreen(),
          ),
              (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account deleted successfully")),
        );
      }
    } catch (e) {
      print("Error deleting account: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete account. Please try again.")),
      );
    }
  }

}
