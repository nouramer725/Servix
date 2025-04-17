import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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

  String description = "Description";
  int selectedIndex = 0;
  List<String> products = [];
  List<Map<String, dynamic>> reviewData = [];

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
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (doc.exists) {
      setState(() {
        description = doc['description'] ?? "No Description Available";
      });
    }
  }

  void _fetchProducts() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('technician')
        .doc(uid)
        .get();

    if (doc.exists && doc.data()!.containsKey('Products')) {
      setState(() {
        final productList = doc['Products'] as List<dynamic>;
        products = productList.cast<String>();
      });
    }
  }

  void _fetchRating() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('technician')
        .doc(uid)
        .get();

    if (doc.exists && doc.data()!.containsKey('Ratings')) {
      final ratingList = doc['Ratings'] as List<dynamic>;
      final List<Map<String, dynamic>> ratingsWithClient = [];

      for (var rating in ratingList) {
        final clientId = rating['clientId'];
        final clientNamee = rating['clientName'];
        final clientLastName = rating['clientLastName'];
        final ratingg = rating['rating'];
        final clientImage = rating['clientImage'];

        ratingsWithClient.add({
          'clientId': clientId,
          'clientName': clientNamee,
          'clientLastName': clientLastName,
          'rating': ratingg,
          'clientImage': clientImage,
        });
      }

      setState(() {
        reviewData = ratingsWithClient;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchDescription();
    _fetchProducts();
    _fetchRating();
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
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileTechnicianEdit(),
                    ));
              },
              child: Text(
                "Edit",
                style: GoogleFonts.castoro(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ApplicationColor,
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
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
              const SizedBox(height: 10),
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
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.19,
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
                  const SizedBox(width: 10),
                  FaIcon(
                    FontAwesomeIcons.locationDot,
                    color: ApplicationColor,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  const FaIcon(
                    FontAwesomeIcons.phone,
                    color: Colors.green,
                    size: 30,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.grey[500],
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        child: Text(
                          'Products',
                          style: GoogleFonts.castoro(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: selectedIndex == 0
                                ? Colors.black
                                : Colors.grey[600],
                            decoration: selectedIndex == 0
                                ? TextDecoration.underline
                                : null,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        child: Text(
                          'Reviews',
                          style: GoogleFonts.castoro(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: selectedIndex == 1
                                ? Colors.black
                                : Colors.grey[600],
                            decoration: selectedIndex == 1
                                ? TextDecoration.underline
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (selectedIndex == 0) ...[
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevent scroll conflict
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 2,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        image: DecorationImage(
                          image: NetworkImage(products[index]),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              if (selectedIndex == 1) ...[
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviewData.length,
                  itemBuilder: (context, index) {
                    final review = reviewData[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(review['clientImage']),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${review['clientName']} ${review['clientLastName']}",
                                  style: GoogleFonts.castoro(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) {
                                      if (index < review['rating']) {
                                        return const Icon(Icons.star,
                                            color: Colors.black, size: 22);
                                      } else {
                                        return const Icon(Icons.star_border,
                                            color: Colors.black, size: 22);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
