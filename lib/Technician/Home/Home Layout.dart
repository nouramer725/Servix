import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Member/MemberShip.dart';
import 'package:servix/Settings/About%20US.dart';
import 'package:servix/Settings/Contact%20Us.dart';
import 'package:servix/Settings/Password.dart';
import 'package:servix/Settings/Privacy%20Policy.dart';
import 'package:servix/Settings/Terms%20&%20Conditions.dart';
import 'package:servix/Technician/AITechnician/Intro.dart';
import 'package:servix/Technician/Home/FirstScreenOfBottomnavbar.dart';
import 'package:servix/Technician/Profile/Profile.dart';
import 'package:servix/constents/constent.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Language/Local_Provider.dart';
import '../../On-Boarding/On_Boarding_Screen.dart';
import '../../Theme/Theme_Provider.dart';
import 'FourthScreenOfBottomnavbar.dart';
import 'SecondScreenOfBottomnavbar.dart';
import 'ThirdScreenOfBottomnavbar.dart';

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
    const HomeTechFirstScreen(),
    const NotificationSystem(),
    const Orders(),
    const IntroScreenTech(),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : ApplicationColor),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Opens the sidebar
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.light
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () {
              final newTheme = themeProvider.themeMode == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
              themeProvider.setThemeMode(newTheme);
            },
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileTechnician(),
                          ));
                    },
                    child: StreamBuilder(
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
                            backgroundColor: Colors.white,
                            radius: 40, // ✅ Adjust size
                            backgroundImage: NetworkImage(
                                personalFileUrl), // ✅ Fetch from Firestore
                          );
                        }
                        return const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40,
                          child: Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.grey,
                          ),
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
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  _buildMenuItem(Icons.swap_horiz, "Switch to Client".tr(),
                      onTap: () {
                        switchToClient(context);
                      }),
                  _buildMenuItem(Icons.person_outline, "Profile".tr(),
                      onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileTechnician(),
                        ));
                  }),
                  _buildMenuItem(Icons.info_outline, "About Us".tr(),
                      onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutUs(),
                        ));
                  }),
                  _buildMenuItem(
                      Icons.article_outlined, "Terms & Conditions".tr(),
                      onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsAndConditions(),
                        ));
                  }),
                  _buildMenuItem(
                      Icons.privacy_tip_outlined, "Privacy Policy".tr(),
                      onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicy(),
                        ));
                  }),
                  _buildMenuItem(Icons.lock_outline, "Password".tr(),
                      onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen(),
                        ));
                  }),
                  // **Language Dropdown**
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.language,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : ApplicationColor),
                        const SizedBox(width: 16),
                        Text(
                          "Language".tr(),
                          style: GoogleFonts.castoro(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const Spacer(),
                        DropdownButton<Locale>(
                          value:
                              localeProvider.locale, // Get the current locale
                          onChanged: (Locale? locale) async {
                            if (locale != null) {
                              await _saveLocale(
                                  locale); // Save the selected locale in preferences
                              context
                                  .setLocale(locale); // Update the app's locale
                              localeProvider
                                  .setLocale(locale); // Update LocaleProvider
                            }
                          },
                          dropdownColor:
                              themeProvider.themeMode == ThemeMode.dark
                                  ? const Color(0xFF333739)
                                  : Colors.white,
                          style: GoogleFonts.castoro(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: Locale('en'), child: Text('English')),
                            DropdownMenuItem(
                                value: Locale('ar'), child: Text('العربية')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildMenuItem(Icons.share, "Share App".tr(), onTap: () {
                    String quoteText =
                        "💡Join the Servix community! Get expert help for any service you need—quick, easy, and hassle-free. Download now!";
                    Share.share(quoteText);
                  }),
                  _buildMenuItem(Icons.phone_outlined, "Contact Us".tr(),
                      onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Contactus(),
                        ));
                  }),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.dark_mode,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : ApplicationColor),
                        const SizedBox(width: 16),
                        Text(
                          "Dark Theme".tr(),
                          style: GoogleFonts.castoro(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        const Spacer(),
                        Switch(
                          activeTrackColor: ApplicationColor,
                          value: themeProvider.themeMode == ThemeMode.dark,
                          onChanged: (value) {
                            themeProvider.setThemeMode(
                                value ? ThemeMode.dark : ThemeMode.light);
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildMenuItem(Icons.logout, "Logout".tr(), onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MemberShip(),
                      ),
                      (route) => false,
                    );
                  }),
                  _buildMenuItem(Icons.delete, "Delete Account".tr(),
                      onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Row(
                          children: [
                            Icon(Icons.delete_outlined,
                                size: 25, color: ApplicationColor),
                            const SizedBox(width: 8),
                            Text("Delete Account".tr(),
                                style: GoogleFonts.charisSil(
                                    color: ApplicationColor3,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        content: Text(
                            "Are you sure you want to delete your account?"
                                .tr(),
                            style: GoogleFonts.charisSil(
                                color: ApplicationColor3, fontSize: 18)),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel".tr(),
                                    style: GoogleFonts.castoro(
                                        fontSize: 20,
                                        color: ApplicationColor3,
                                        fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  _deleteAccount(context);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OnboardingScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: Text("Delete".tr(),
                                    style: GoogleFonts.castoro(
                                        fontSize: 20,
                                        color: ApplicationColor,
                                        fontWeight: FontWeight.bold)),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white60
                      : ApplicationColor3),
              label: "Home".tr(),
              activeIcon: Icon(Icons.home, color: ApplicationColor),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_outlined,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white60
                      : ApplicationColor3),
              label: "Notifications".tr(),
              activeIcon: Icon(Icons.notifications, color: ApplicationColor),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white60
                      : ApplicationColor3),
              label: "Orders".tr(),
              activeIcon: Icon(Icons.receipt_long, color: ApplicationColor),
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 25, // Set a fixed height for both icons
                child: Image.asset(
                  themeProvider.themeMode == ThemeMode.dark
                      ? 'assets/NavigationBar/robot.png'
                      : 'assets/NavigationBar/robotblack.png',
                ),
              ),
              label: "Ai Chat".tr(),
              activeIcon: SizedBox(
                height: 25, // Ensures alignment
                child: Image.asset(
                  'assets/NavigationBar/robotcolor.png',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ListTile(
      leading: Icon(icon,
          color: themeProvider.themeMode == ThemeMode.dark
              ? Colors.white
              : ApplicationColor),
      title: Text(
        title,
        style: GoogleFonts.castoro(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black),
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap ?? () {},
    );
  }

  void _deleteAccount(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      // Delete user data from Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference userDoc =
          firestore.collection('user-files').doc(userId);
      QuerySnapshot uploadsSnapshot = await userDoc.collection('uploads').get();
      for (var doc in uploadsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete 'locationDetails' subcollection
      QuerySnapshot locationSnapshot =
          await userDoc.collection('locationDetails').get();
      for (var doc in locationSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete user document from 'user-files'
      await userDoc.delete().catchError((error) {
        print("Error deleting user from 'user-files': $error");
      });

      // Delete user document from 'technician'
      await firestore
          .collection('technician')
          .doc(userId)
          .delete()
          .catchError((error) {
        print("Error deleting user from 'technician': $error");
      });

      await firestore
          .collection('ContactUs')
          .doc(userId)
          .delete()
          .catchError((error) {
        print("Error deleting user from 'ContactUs': $error");
      });

      // Delete authentication
      await user.delete();
    }
  }

  Future<void> _saveLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  Future<void> switchToClient(BuildContext context) async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      // Get a reference to the 'technician' document for the current user
      DocumentReference technicianRef = FirebaseFirestore.instance
          .collection('technician')
          .doc(firebaseUser.uid);

      try {
        // Fetch the technician data
        DocumentSnapshot technicianSnapshot = await technicianRef.get();

        if (technicianSnapshot.exists) {
          // Retrieve the technician data
          var technicianData = technicianSnapshot.data() as Map<String, dynamic>;

          String firstName = technicianData['first_name'] ?? 'Updated Name';
          String lastName = technicianData['last_name'] ?? 'Updated Last Name';
          String email = technicianData['email'] ?? 'Updated Email';
          String phone = technicianData['phone'] ?? 'Updated Phone Number';
          String gender = technicianData['gender'] ?? 'Updated Gender';

          // Create a new document in the 'users' collection with the role 'Client'
          await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'phone': phone,
            'gender': gender,
            'role': 'Client', // Switch role to 'Client'
          });

          // Now update the 'role' in the technician document
          await technicianRef.update({
            'role': 'Client', // Assuming there's a 'role' field in the 'technician' document
          }).then((_) async {
            // Optionally, update the Firebase Auth user's email, display name, etc.
            await firebaseUser.updateDisplayName('$firstName $lastName');
            await firebaseUser.updateEmail(email);

            // After the role switch, navigate to the client home screen
            Navigator.pushNamedAndRemoveUntil(
                context, "/clientHome", (route) => false);
          }).catchError((error) {
            print("Failed to update technician role: $error");
          });

        } else {
          print("Technician document not found.");
        }
      } catch (e) {
        print("Failed to update role: $e");
      }
    }
  }

}
