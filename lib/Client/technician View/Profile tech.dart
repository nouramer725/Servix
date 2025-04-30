import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';
import 'Profile tech peview _ REPORT.dart';

class TechnicianProfileScreen extends StatefulWidget {
  final String technicianName;
  final String technicianId;
  final String technicianImage;
  final String technicianLocationArea;
  final String technicianLocationStreet;
  final String technicianPhone;
  final String technicianSub;
  final String technicianMain;
  final String technicianDescription;
  final String technicianLinkSocialMedia;

  const TechnicianProfileScreen({
    required this.technicianName,
    required this.technicianId,
    required this.technicianImage,
    required this.technicianLocationArea,
    required this.technicianLocationStreet,
    required this.technicianPhone,
    required this.technicianSub,
    required this.technicianMain,
    required this.technicianDescription,
    required this.technicianLinkSocialMedia,
    super.key,
  });

  @override
  State<TechnicianProfileScreen> createState() =>
      _TechnicianProfileScreenState();
}

class _TechnicianProfileScreenState extends State<TechnicianProfileScreen> {
  int selectedIndex = 0;
  bool isBlocked = false;
  List<Map<String, dynamic>> reviewData = [];
  List<String> products = [];

  void _fetchProducts() async {
    final uid = widget.technicianId;
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
    final uid = widget.technicianId;
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

  Future<void> checkIfTechnicianIsBlocked() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('blocked_technicians')
        .where('technicianId',
            isEqualTo: widget.technicianId) // Pass the technicianId here
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        isBlocked = true;
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
    checkIfTechnicianIsBlocked();
    _fetchRating();
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (isBlocked) {
      return Scaffold(
        appBar: AppBar(
            title: Text(
          "Technician Profile",
          style: GoogleFonts.castoro(
            fontSize: 20,
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        )),
        body: Center(
          child: Text(
            "This User is blocked".tr(),
            style: GoogleFonts.castoro(
              fontSize: 20,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? Color(0xFF333739)
            : Colors.white,
        title: Text("Profile Technician".tr(),
            style: GoogleFonts.castoro(
              fontSize: 20,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            )),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : const Color(0xFF333739)),
            color: themeProvider.themeMode == ThemeMode.dark
                ? const Color(0xFF333739)
                : Colors.white,
            onSelected: (value) async {
              if (value == "Report") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportScreen(
                        technicianId: widget.technicianId,
                        technicianName: widget.technicianName,
                      ),
                    ));
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "Report",
                child: Text("Report".tr(),
                    style: GoogleFonts.castoro(
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18)),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.network(
                    widget.technicianImage,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.technicianName,
                  style: GoogleFonts.castoro(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                FutureBuilder<double>(
                  future: getAverageRating(widget.technicianId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                    } else if (snapshot.hasError) {
                      return const Text('Error loading rating');
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
                            color: ApplicationColor3,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Main Service:'.tr(),
                      style: GoogleFonts.castoro(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : const Color(0xFF626262),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.technicianMain.tr(),
                      style: GoogleFonts.castoro(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : const Color(0xFF626262),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sub Service:',
                      style: GoogleFonts.castoro(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : const Color(0xFF626262),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.technicianSub.tr(),
                      style: GoogleFonts.castoro(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : const Color(0xFF626262),
                      ),
                    )
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.14,
                  margin: const EdgeInsets.all(17),
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.grey[600]
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      widget.technicianDescription,
                      style: TextStyle(
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 18),
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
                      onTap: () async {
                        final url = widget.technicianLinkSocialMedia;
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "This Technician doesn't has a social media link"
                                      .tr(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              backgroundColor: ApplicationColorWithOpacity,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: Icon(
                        Icons.facebook,
                        color: Colors.blue[700],
                        size: 40,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Technician Location".tr(),
                                    style: GoogleFonts.castoro(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      "Area:".tr(),
                                      style: GoogleFonts.castoro(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        widget.technicianLocationArea,
                                        style: GoogleFonts.castoro(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 5,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Street:".tr(),
                                        style: GoogleFonts.castoro(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        widget.technicianLocationStreet,
                                        style: GoogleFonts.castoro(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 5,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.location_on_outlined,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        size: 40,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final Uri phoneUri =
                            Uri(scheme: 'tel', path: widget.technicianPhone);
                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Could not launch phone dialer".tr(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              backgroundColor: ApplicationColorWithOpacity,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: Icon(
                        Icons.phone,
                        color: ApplicationColor,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
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
                            'Products'.tr(),
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
                              decorationColor:
                                  themeProvider.themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                              textBaseline: TextBaseline.alphabetic,
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
                            'Reviews'.tr(),
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
                              decorationColor:
                                  themeProvider.themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
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
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
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
                                  Text(
                                    review['comment'],
                                    style: GoogleFonts.castoro(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
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
      ),
    );
  }
}
