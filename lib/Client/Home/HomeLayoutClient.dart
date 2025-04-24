import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:servix/Client/AIClient/Intro.dart';
import 'package:servix/Client/Home/List%20Of%20Pages_Clients/HomeClientFirstScreen.dart';
import 'package:servix/Client/Orders/OrdersPage.dart';
import 'package:servix/Client/Profile/profile.dart';
import 'package:servix/Member/MemberShip.dart';
import 'package:servix/Settings/About%20US.dart';
import 'package:servix/Settings/Contact%20Us.dart';
import 'package:servix/Settings/Password.dart';
import 'package:servix/Settings/Privacy%20Policy.dart';
import 'package:servix/Settings/Terms%20&%20Conditions.dart';
import 'package:servix/constents/constent.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Language/Local_Provider.dart';
import '../../On-Boarding/On_Boarding_Screen.dart';
import '../../Theme/Theme_Provider.dart';
import '../Notification/notifaction really.dart';
import '../community forum/community_feed_screen.dart';

class HomeClientLayout extends StatefulWidget {
  const HomeClientLayout({super.key});

  @override
  State<HomeClientLayout> createState() => _HomeClientLayoutState();
}

class _HomeClientLayoutState extends State<HomeClientLayout> {
  Map<String, dynamic>? userData;
  bool isTechnician = false;
  bool isClient = false;

  Future<void> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // First, check if user exists in the technicians collection
      DocumentSnapshot technicianDoc = await FirebaseFirestore.instance
          .collection('technician')
          .doc(user.uid)
          .get();

      if (technicianDoc.exists) {
        if (mounted) {
          setState(() {
            isTechnician = true; // Mark user as technician
            userData = technicianDoc.data() as Map<String, dynamic>?;
            isClient = false; // Not a client
          });
        }
      } else {
        // If not found in technicians, check users collection
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          if (mounted) {
            setState(() {
              isTechnician = false; // Mark user as client
              isClient = true; // Mark user as existing in users collection
              userData = userDoc.data() as Map<String, dynamic>?;
            });
          }
        }
      }
    }
  }

  Future<String?> _getProfileImageUrl() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final firestore = FirebaseFirestore.instance;

    // Check first path
    final firstDoc = await firestore
        .collection("user-files")
        .doc(uid)
        .collection("personalInformation")
        .doc("profile")
        .get();

    if (firstDoc.exists && firstDoc.data()?['personalImageUrl'] != null) {
      return firstDoc.data()?['personalImageUrl'];
    }

    // Check second path
    final secondDoc = await firestore
        .collection("user-files")
        .doc(uid)
        .collection("personalInformationProvider")
        .doc("profile")
        .get();

    if (secondDoc.exists && secondDoc.data()?['personalImageUrl'] != null) {
      return secondDoc.data()?['personalImageUrl'];
    }

    return null;
  }

  bool isDarkMode = false; // Default mode

  final List<Widget> pages = [
    const NotificationScreenReal(),
    const OrdersPage(),
    const HomeClientFirstScreen(),
    CommunityFeedScreen(),
    const IntroScreenClient(),
  ];
  int selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    getUserData();
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
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<String?>(
                future: _getProfileImageUrl(),
                builder: (context, snapshot) {
                  String? personalImageUrl = snapshot.data;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen()),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: 20,
                      backgroundImage: personalImageUrl != null
                          ? NetworkImage(personalImageUrl)
                          : null,
                      child: personalImageUrl == null
                          ? const Icon(Icons.person,
                              size: 20, color: Colors.grey)
                          : null,
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  userData != null
                      ? "WelcomeUser ".tr(namedArgs: {
                          "first_name": userData!['first_name'],
                        })
                      : "Welcome".tr(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: GoogleFonts.castoro(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.light
                ? Icons.dark_mode
                : Icons.sunny),
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
                            builder: (context) => const ProfileScreen(),
                          ));
                    },
                    child: FutureBuilder<String?>(
                      future: _getProfileImageUrl(),
                      builder: (context, snapshot) {
                        String? personalImageUrl = snapshot.data;

                        return GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            radius: 40,
                            backgroundImage: personalImageUrl != null
                                ? NetworkImage(personalImageUrl)
                                : null,
                            child: personalImageUrl == null
                                ? const Icon(Icons.person,
                                    size: 40, color: Colors.grey)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData != null
                        ? "   ${userData!['first_name']} ${userData!['last_name']} ${userData!['third_name'] ?? ''}"
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
                  _buildMenuItem(Icons.person_outline, "Profile".tr(),
                      onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
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
                          value: localeProvider.locale,
                          onChanged: (Locale? locale) async {
                            if (locale != null) {
                              await _saveLocale(locale);
                              context.setLocale(locale);
                              localeProvider.setLocale(locale);
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
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor:
                            themeProvider.themeMode == ThemeMode.dark
                                ? const Color(0xFF333739)
                                : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10)), // Rounded corners
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min, // Adjusts to content size
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Log out of your account?".tr(),
                                  style: GoogleFonts.castoro(
                                      color: themeProvider.themeMode ==
                                              ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      "CANCEL".tr(),
                                      style: GoogleFonts.castoro(
                                        color: themeProvider.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MemberShip()),
                                        (route) => false,
                                      );
                                    },
                                    child: Text(
                                      "LOG OUT".tr(),
                                      style: GoogleFonts.castoro(
                                        fontSize: 16,
                                        color: ApplicationColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  _buildMenuItem(Icons.delete, "Delete Account".tr(),
                      onTap: () {
                    Navigator.pop(context);
                    _showPasswordDialog(context);
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: CurvedNavigationBar(
          height: 70,
            index: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            backgroundColor: Colors.transparent,
            color: ApplicationColor,
            buttonBackgroundColor: ApplicationColor,
            items: [
              Icon(
                Icons.notifications,
                color: Colors.white,
                size: 35,
              ),
              Icon(
                Icons.receipt_long,
                color: Colors.white,
                size: 35,
              ),
              Icon(
                Icons.home_rounded,
                color: Colors.white,
                size: 35,
              ),
              Icon(
                Icons.groups_rounded,
                color: Colors.white,
                size: 35,
              ),
              Icon(
                Icons.chat,
                color: Colors.white,
                size: 35,
              ),
            ]),
      ),

      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.only(left: 8, right: 8),
      //   child: BottomNavigationBar(
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //     showSelectedLabels: true,
      //     showUnselectedLabels: true,
      //     type: BottomNavigationBarType.fixed,
      //     currentIndex: selectedIndex,
      //     onTap: (index) {
      //       setState(() {
      //         selectedIndex = index;
      //       });
      //     },
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.notifications_none_outlined,
      //             color: themeProvider.themeMode == ThemeMode.dark
      //                 ? Colors.white60
      //                 : ApplicationColor3),
      //         label: "Notifications".tr(),
      //         activeIcon: Icon(Icons.notifications, color: ApplicationColor),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.receipt_long_outlined,
      //             color: themeProvider.themeMode == ThemeMode.dark
      //                 ? Colors.white60
      //                 : ApplicationColor3),
      //         label: "Orders".tr(),
      //         activeIcon: Icon(Icons.receipt_long, color: ApplicationColor),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.home_outlined,
      //             color: themeProvider.themeMode == ThemeMode.dark
      //                 ? Colors.white60
      //                 : ApplicationColor3),
      //         label: "Home".tr(),
      //         activeIcon: Icon(Icons.home, color: ApplicationColor),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.groups,
      //             color: themeProvider.themeMode == ThemeMode.dark
      //                 ? Colors.white60
      //                 : ApplicationColor3),
      //         label: "Community Forum".tr(),
      //         activeIcon: Icon(Icons.groups, color: ApplicationColor),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: SizedBox(
      //           height: 25, // Set a fixed height for both icons
      //           child: Image.asset(
      //             themeProvider.themeMode == ThemeMode.dark
      //                 ? 'assets/NavigationBar/robot.png'
      //                 : 'assets/NavigationBar/robotblack.png',
      //           ),
      //         ),
      //         label: "Ai Chat".tr(),
      //         activeIcon: SizedBox(
      //           height: 25, // Ensures alignment
      //           child: Image.asset(
      //             'assets/NavigationBar/robotcolor.png',
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
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

  void _showPasswordDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Text(
          "Confirm Password",
          style: GoogleFonts.castoro(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Please enter your password to confirm deletion:",
                  style: GoogleFonts.castoro(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ApplicationColor3,
                  )),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                autocorrect: false,
                obscureText: false,
                cursorColor: Colors.grey[100],
                decoration: InputDecoration(
                  labelText: "Password",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  labelStyle: GoogleFonts.castoro(color: Colors.grey),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel",
                style: GoogleFonts.castoro(
                  color: ApplicationColor3,
                  fontSize: 16,
                )),
          ),
          TextButton(
            onPressed: () async {
              final password = passwordController.text.trim();
              final user = FirebaseAuth.instance.currentUser;

              if (user != null && user.email != null) {
                final cred = EmailAuthProvider.credential(
                  email: user.email!,
                  password: password,
                );

                try {
                  await user.reauthenticateWithCredential(cred);
                  Navigator.pop(context);
                  _showFinalDeleteDialog(context, themeProvider);
                  Fluttertoast.showToast(
                    msg: "Correct password",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    backgroundColor: ApplicationColorWithOpacity,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: "Wrong password. Account not deleted.",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    backgroundColor: ApplicationColorWithOpacity,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              }
            },
            child: Text("Confirm",
                style:
                    GoogleFonts.castoro(fontSize: 16, color: ApplicationColor)),
          ),
        ],
      ),
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

      QuerySnapshot personalSnapshot =
          await userDoc.collection('personalInformation').get();
      for (var doc in personalSnapshot.docs) {
        await doc.reference.delete();
      }

      QuerySnapshot NewLocationSnapshot =
          await userDoc.collection('NewLocationDetails').get();
      for (var doc in NewLocationSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete user document fro?m 'user-files'
      await userDoc.delete().catchError((error) {
        print("Error deleting user from 'user-files': $error");
      });

      // Delete user document from 'technician'
      await firestore
          .collection('users')
          .doc(userId)
          .delete()
          .catchError((error) {
        print("Error deleting user from 'Clients': $error");
      });

      await firestore
          .collection('technician')
          .doc(userId)
          .delete()
          .catchError((error) {
        print("Error deleting user from 'technician': $error");
      });

      DocumentReference services =
          firestore.collection('Services Requests').doc(userId);

      QuerySnapshot servicesSnapshot =
          await services.collection('user-services').get();
      for (var doc in servicesSnapshot.docs) {
        await doc.reference.delete();
      }

      await firestore
          .collection('ContactUs')
          .doc(userId)
          .delete()
          .catchError((error) {
        print("Error deleting user from 'ContactUs': $error");
      });

      // Delete authentication
      await FirebaseAuth.instance.currentUser?.delete();
    }
  }

  void _showFinalDeleteDialog(
      BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Row(
          children: [
            Icon(Icons.delete,
                size: 25,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : ApplicationColor),
            const SizedBox(width: 8),
            Text("Delete Account".tr(),
                style: GoogleFonts.castoro(
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text("Are you sure you want to delete your account?".tr(),
            style: GoogleFonts.castoro(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                fontSize: 18)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel".tr(),
                    style: GoogleFonts.castoro(
                        fontSize: 20,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () async {
                  _deleteAccount(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnboardingScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: Text("Delete".tr(),
                    style: GoogleFonts.castoro(
                        fontSize: 20,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.redAccent
                            : ApplicationColor,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _saveLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }
}
