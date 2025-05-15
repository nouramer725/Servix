import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:servix/Technician/Profile/Edit%20Profile.dart';
import 'package:servix/constents/constent.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Theme/Theme_Provider.dart';
import 'Profile save screen (ison location).dart';

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
  String facebookUrl = '';
  String phoneNumber = '';
  String street = "Street not available";
  String building = "Building not available";
  String apartment = "Apartment not available";
  String floor = "Floor not available";
  String directions = "Directions not available";
  String label = "Label not available";
  String area = "Area not available";
  LatLng? userLocation;

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
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('technician')
        .doc(uid)
        .get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        description = data.containsKey('description')
            ? data['description']
            : "No Description Available".tr();
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

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not call $phoneNumber';
    }
  }

  void fetchContactInfo() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('technician')
        .doc(uid)
        .get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;

      setState(() {
        facebookUrl = data['LinkSocialMedia'] ?? '';
        phoneNumber = data['phone'] ?? '';
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
        final comment = rating['comment'];
        final clientImage = rating['clientImage'];

        ratingsWithClient.add({
          'clientId': clientId,
          'clientName': clientNamee,
          'clientLastName': clientLastName,
          'rating': ratingg,
          'clientImage': clientImage,
          'comment': comment,
        });
      }

      setState(() {
        reviewData = ratingsWithClient;
      });
    }
  }

  Future<void> _deleteImage(String imageUrl) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = FirebaseFirestore.instance.collection('technician').doc(uid);

    try {
      await docRef.update({
        'Products': FieldValue.arrayRemove([imageUrl]),
      });

      setState(() {
        products.remove(imageUrl);
      });

      Fluttertoast.showToast(
        msg: "Image deleted successfully".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to delete image".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _fetchLocationDetails() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("user-files")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("locationDetails")
        .orderBy("timestamp", descending: true) // Get latest entry
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs.first.data() as Map<String, dynamic>;

      setState(() {
        street = data['street'] ?? "Street not available";
        area = data['area'] ?? "Area not available";
        building = data['building'] ?? "Building not available";
        apartment = data['apartment'] ?? "Apartment not available";
        floor = data['floor'] ?? "Floor not available";
        directions = data['directions'] ?? "Directions not available";
        label = data['label'] ?? "Label not available";
        userLocation = LatLng(data['latitude'], data['longitude']);
      });
    } else {
      setState(() {
        street = "Street not available";
        area = "Area not available";
        building = "Building not available";
        apartment = "Apartment not available";
        floor = "Floor not available";
        directions = "Directions not available";
        label = "Label not available";
        userLocation = null;
      });
    }
  }

  Future<double> getAverageRating(String technicianId) async {
    try {
      // Fetch the technician's document
      DocumentSnapshot technicianSnapshot = await FirebaseFirestore.instance
          .collection('technician')
          .doc(technicianId)
          .get();

      if (!technicianSnapshot.exists) {
        return 0.0; // Return 0 if technician document doesn't exist
      }

      // Get the Ratings array from the document
      List<dynamic> ratings = technicianSnapshot['Ratings'] ?? [];

      if (ratings.isEmpty) {
        return 0.0; // Return 0 if there are no ratings
      }

      // Calculate the sum of all ratings
      double total = 0.0;
      for (var rating in ratings) {
        total += rating['rating']; // Assuming the field name is 'rating'
      }

      // Return the average rating
      return total / ratings.length;
    } catch (e) {
      print("Error calculating average rating: $e");
      return 0.0; // Return 0 if an error occurs
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchDescription();
    _fetchProducts();
    _fetchRating();
    fetchContactInfo();
    _fetchLocationDetails();
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
          "Profile".tr(),
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
                "Edit".tr(),
                style: GoogleFonts.castoro(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : ApplicationColor,
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    backgroundImage: NetworkImage(
                        "https://static.vecteezy.com/system/resources/previews/036/280/651/large_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg"),
                  );
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      userData != null
                          ? " ${userData!['first_name']} ${userData!['last_name']}"
                          : "Welcome".tr(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.castoro(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              FutureBuilder<double>(
                future:
                    getAverageRating(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                  } else if (snapshot.hasError) {
                    return Text("Error loading rating".tr());
                  }

                  final avgRating = snapshot.data ?? 0.0;

                  // Determine how many full, half, and empty stars to show
                  int fullStars = avgRating.floor();
                  bool hasHalfStar = (avgRating - fullStars) >= 0.5;
                  int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Full stars
                      for (int i = 0; i < fullStars; i++)
                        Icon(
                          Icons.star,
                          color: ApplicationColor,
                          size: 25,
                        ),
                      // Half star (if necessary)
                      if (hasHalfStar)
                        Icon(
                          Icons.star_half,
                          color: ApplicationColor,
                          size: 25,
                        ),
                      // Empty stars
                      for (int i = 0; i < emptyStars; i++)
                        const Icon(
                          Icons.star_border,
                          color: Colors.grey,
                          size: 25,
                        ),
                      const SizedBox(width: 10),
                      // Display the numeric rating value
                      Text(
                        avgRating.toStringAsFixed(1),
                        style: GoogleFonts.castoro(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              userData == null
                  ? SizedBox
                      .shrink() // No content to display when userData is null
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Main Service:".tr(),
                              style: GoogleFonts.castoro(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : const Color(0xFF676767)),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "${userData!['main_service'] ?? 'N/A'}",
                              style: GoogleFonts.castoro(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : const Color(0xFF676767)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sub Service:".tr(),
                              style: GoogleFonts.castoro(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : const Color(0xFF676767)),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "${userData!['sub_service'] ?? 'N/A'}",
                              style: GoogleFonts.castoro(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : const Color(0xFF676767)),
                            ),
                          ],
                        ),
                      ],
                    ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.19,
                margin: const EdgeInsets.all(17),
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? const Color(0xFF333739)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.grey[500]!,
                    )),
                child: Center(
                  child: Text(
                    description,
                    style: GoogleFonts.castoro(
                        color: Colors.grey[600], fontSize: 18),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 20,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _launchURL(facebookUrl),
                    child: FaIcon(
                      FontAwesomeIcons.facebook,
                      color: Colors.blue[700],
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SaveNewAddressIconLocationInProfile(
                          areaName: area,
                          streetName: street,
                          latitude: userLocation!.latitude,
                          longitude: userLocation!.longitude,
                          building: building,
                          apt: apartment,
                          floor: floor,
                          directions: directions,
                          label: label,
                        ),
                      ),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.locationDot,
                      color: ApplicationColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _makePhoneCall(phoneNumber),
                    child: const FaIcon(
                      FontAwesomeIcons.phone,
                      color: Colors.green,
                      size: 30,
                    ),
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
                          "Products".tr(),
                          style: GoogleFonts.castoro(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: selectedIndex == 0
                                ? themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black
                                : Colors.grey[600],
                            decoration: selectedIndex == 0
                                ? TextDecoration.underline
                                : null,
                            decorationStyle: selectedIndex == 0
                                ? TextDecorationStyle.solid
                                : null,
                            decorationColor: selectedIndex == 0
                                ? themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black
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
                          "Reviews".tr(),
                          style: GoogleFonts.castoro(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: selectedIndex == 1
                                ? themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black
                                : Colors.grey[600],
                            decoration: selectedIndex == 1
                                ? TextDecoration.underline
                                : null,
                            decorationStyle: selectedIndex == 1
                                ? TextDecorationStyle.solid
                                : null,
                            decorationColor: selectedIndex == 1
                                ? themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black
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
                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor:
                                themeProvider.themeMode == ThemeMode.dark
                                    ? const Color(0xFF333739)
                                    : Colors.white,
                            title: Row(
                              children: [
                                Icon(Icons.delete_outlined,
                                    size: 25, color: ApplicationColor),
                                const SizedBox(width: 8),
                                Text("Delete Image".tr(),
                                    style: GoogleFonts.charisSil(
                                        color: ApplicationColor3,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            content: Text(
                                "Are you sure you want to delete this image?"
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
                                    onPressed: () async {
                                      Navigator.pop(context); // Close dialog
                                      await _deleteImage(products[
                                          index]); // Delete from Firestore
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
                      },
                      child: Container(
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
                    final hasComment =
                        (review['comment'] ?? '').trim().isNotEmpty;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                (review['clientImage'] != null &&
                                        review['clientImage']
                                            .toString()
                                            .trim()
                                            .isNotEmpty)
                                    ? review['clientImage']
                                    : 'https://static.vecteezy.com/system/resources/previews/036/280/651/large_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${review['clientName']} ${review['clientLastName']}",
                                    style: GoogleFonts.castoro(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.themeMode ==
                                              ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  if (hasComment) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      review['comment'],
                                      style: GoogleFonts.castoro(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: themeProvider.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white
                                            : Colors.grey[600],
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                  Row(
                                    children: [
                                      Row(
                                        children: List.generate(
                                          5,
                                          (index) {
                                            if (index < review['rating']) {
                                              return Icon(
                                                Icons.star,
                                                color: ApplicationColor,
                                                size: 20,
                                              );
                                            } else {
                                              return const Icon(
                                                Icons.star_border,
                                                color: Colors.grey,
                                                size: 20,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        review['rating'].toString(),
                                        style: GoogleFonts.castoro(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: themeProvider.themeMode ==
                                                  ThemeMode.dark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
