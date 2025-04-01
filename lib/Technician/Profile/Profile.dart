import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Components/Buttons.dart';
import 'package:servix/Technician/Profile/Edit%20Profile.dart';
import 'package:servix/constents/constent.dart';
import '../../Theme/Theme_Provider.dart';

class ProfileTechnician extends StatefulWidget {
  const ProfileTechnician({super.key});

  @override
  State<ProfileTechnician> createState() => _ProfileTechnicianState();
}

class _ProfileTechnicianState extends State<ProfileTechnician> {
  Map<String, dynamic>? userData;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  TextEditingController mainServiceController = TextEditingController();
  TextEditingController subServiceController = TextEditingController();

  double? userRating;
  double averageRating = 0.0;
  int totalRatings = 0;
  String description = "Description";
  bool showReview = false;

  Future<void> _fetchAverageRating() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    QuerySnapshot ratingsSnapshot = await FirebaseFirestore.instance
        .collection('technician')
        .doc(user.uid)
        .collection('ratings')
        .get();

    if (ratingsSnapshot.docs.isNotEmpty) {
      double sum = 0;
      for (var doc in ratingsSnapshot.docs) {
        sum += (doc.data() as Map<String, dynamic>)['rating'];
      }
      setState(() {
        totalRatings = ratingsSnapshot.docs.length;
        averageRating = sum / totalRatings;
      });
    }
  }

  Future<void> _submitRating(double rating) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    await FirebaseFirestore.instance
        .collection('technician')
        .doc(currentUser.uid)
        .collection('ratings')
        .doc(currentUser.uid)
        .set({'rating': rating});

    _fetchAverageRating();
  }

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
      if (userData != null) {
        _firstNameController.text = userData!['first_name'] ?? '';
        _lastNameController.text = userData!['last_name'] ?? '';
      }
    });
  }

  void _fetchDescription() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('technician')
        .doc(FirebaseAuth.instance.currentUser!.uid) // Use actual UID
        .get();
    if (doc.exists) {
      setState(() {
        description = doc['description'] ?? "No Description Available";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchAverageRating();
    _fetchDescription();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeProvider.themeMode == ThemeMode.dark
              ? const Color(0xFF333739)
              : Colors.white,
          title: Text(
            "Profile",
            style: GoogleFonts.castoro(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const ProfileTechnicianEdit(),
                            ));
                      },
                      child: Text(
                        "Edit Profile",
                        style: GoogleFonts.castoro(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: ApplicationColor,
                          decoration: TextDecoration.underline,
                          decorationColor: ApplicationColor,
                        ),
                      ))
                ],
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
                      backgroundColor: Colors.white,
                      radius: 70,
                      backgroundImage: NetworkImage(personalFileUrl),
                    );
                  }
                  return const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 70,
                    child: Icon(Icons.person, size: 100),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                          : Colors.black,
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${averageRating.toStringAsFixed(1)}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 5),
                    RatingBar.builder(
                      initialRating: userRating ?? 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 25,
                      itemBuilder: (context, _) =>
                      const Icon(
                        Icons.star,
                        color: Colors.amberAccent,
                      ),
                      onRatingUpdate: (rating) {
                        _submitRating(rating);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              userData == null
                  ? CircularProgressIndicator(color: ApplicationColor)
                  : Column(
                children: [
                  Text(
                    "Main Service: ${userData!['main_service'] ?? 'N/A'}",
                    style: GoogleFonts.castoro(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF676767)),
                  ),
                  Text(
                    "Sub Service: ${userData!['sub_service'] ?? 'N/A'}",
                    style: GoogleFonts.castoro(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF676767)),
                  ),
                ],
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.19,
                margin: const EdgeInsets.all(17),
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 20,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.facebook,
                    color: Colors.blue[700],
                    size: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  FaIcon(
                    FontAwesomeIcons.locationDot,
                    color: ApplicationColor,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const FaIcon(
                    FontAwesomeIcons.phone,
                    color: Colors.green,
                    size: 30,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.grey[300],
                thickness: 1,
                indent: 40,
                endIndent: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Product Section
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showReview = false; // Switch to Product
                          });
                        },
                        child: Text(
                          "Product",
                          style: GoogleFonts.castoro(
                            fontWeight: showReview
                                ? FontWeight.normal
                                : FontWeight.bold,
                            fontSize: 16,
                            decoration: showReview
                                ? TextDecoration.none
                                : TextDecoration.underline,
                            color: showReview ? Colors.grey : ApplicationColor,
                            decorationColor:
                            showReview ? Colors.grey : ApplicationColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Image.asset(
                        "assets/Application/congratulations.png",
                        width: 120,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      Image.asset(
                        "assets/Application/congratulations.png",
                        width: 120,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  const SizedBox(width: 20), // Spacing
                  // Review Section (Now Clickable & Styled)
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showReview = true; // Switch to Review
                          });
                        },
                        child: Text(
                          "Review",
                          style: GoogleFonts.castoro(
                            fontWeight: showReview
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16,
                            decoration: showReview
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            color: showReview ? ApplicationColor : Colors.grey,
                            decorationColor:
                            showReview ? ApplicationColor : Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 120,
                        height: 90,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/Application/Servix.png",
                            width: 120,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Add Button (For adding a review)
                      GestureDetector(
                        onTap: () {
                          print("Add Review Clicked");
                        },
                        child: Container(
                          width: 120,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child:
                            Icon(Icons.add, size: 30, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GradientButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileTechnicianEdit(),
                        ));
                  },
                  text: "Edit Profile")
            ]),
          ),
        ));
  }
}
