import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Settings/Service%20Fees.dart';
import 'package:servix/Technician/Profile/Profile.dart';
import '../../../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';
import '../Orders/model/modelTech.dart';
import '../Orders/Pending card tech.dart';

class HomeTechFirstScreen extends StatefulWidget {
  const HomeTechFirstScreen({super.key});

  @override
  State<HomeTechFirstScreen> createState() => _HomeTechFirstScreenState();
}

class _HomeTechFirstScreenState extends State<HomeTechFirstScreen> {
  Map<String, dynamic>? userData;
  int selectedIndex = 0;

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
    });
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

  Future<int> getServiceCount(String technicianId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('technician')
          .doc(technicianId)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data()?['serviceCount'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error fetching service count: $e');
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    getServiceCount(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileTechnician()));
                },
                child: StreamBuilder(
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
                        radius: 70, // ✅ Adjust size
                        backgroundImage: NetworkImage(
                            personalFileUrl), // ✅ Fetch from Firestore
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
              ),
              const SizedBox(height: 10),
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
                        : Colors.black),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ServiceFees(),
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.grey.shade700
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 0.5,
                              blurRadius: 5,
                              offset: const Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            FutureBuilder<int>(
                              future: getServiceCount(
                                  FirebaseAuth.instance.currentUser!.uid),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Error loading data".tr());
                                } else if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.toString(),
                                    style: GoogleFonts.castoro(
                                      fontSize: 40,
                                      color: const Color(0xFF9A9A9A),
                                    ),
                                  );
                                } else {
                                  // Fallback value if no data or loading
                                  return Text("0",
                                      style: GoogleFonts.castoro(
                                        fontSize: 40,
                                        color: const Color(0xFF9A9A9A),
                                      ));
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            Text("Total Jobs".tr(),
                                style: GoogleFonts.castoro(
                                    fontSize: 16,
                                    color: const Color(0xFF9A9A9A))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.grey.shade700
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 0.5,
                            blurRadius: 5,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          FutureBuilder<double>(
                            future: getAverageRating(
                                FirebaseAuth.instance.currentUser!.uid),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                // return const Text("Error loading rating").tr();
                              }
                              final avgRating = snapshot.data ?? 0.0;
                              return Text(
                                avgRating.toStringAsFixed(1),
                                style: GoogleFonts.castoro(
                                    fontSize: 40,
                                    color: const Color(0xFF9A9A9A)),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Text("Rating".tr(),
                              style: GoogleFonts.castoro(
                                  fontSize: 16,
                                  color: const Color(0xFF9A9A9A))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white.withOpacity(0.5)
                    : const Color(0xFFD0D0D0),
                indent: 40,
                endIndent: 40,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Pending Orders".tr(),
                style: GoogleFonts.castoro(
                    fontSize: 25,
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFF9A9A9A),
                    fontWeight: FontWeight.w500,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : const Color(0xFF7B7B7B)),
              ),
              if (selectedIndex == 0) ...[
                const SizedBox(height: 10),
                FutureBuilder<String>(
                  future: getTechnicianSubservice(),
                  builder: (context, subserviceSnapshot) {
                    if (subserviceSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      // Show loading indicator while waiting for data
                      return Center(
                          child: CircularProgressIndicator(
                        color: ApplicationColor,
                      ));
                    }

                    if (subserviceSnapshot.hasError ||
                        !subserviceSnapshot.hasData) {
                      // Handle error and no data case
                      return Center(
                          child: Text("Error fetching subservice".tr()));
                    }

                    final technicianSubservice = subserviceSnapshot
                        .data!; // Ensure that data is non-null here
                    final uid = FirebaseAuth.instance.currentUser!.uid;

                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collectionGroup('user-services')
                          .where('Status', isEqualTo: 'Pending')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Show loading indicator while waiting for orders data
                          // return Center(child: CircularProgressIndicator(
                          //   color: ApplicationColor,
                          // ));
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          // Handle error or no data in orders
                          return Center(child: Text("loading orders...".tr()));
                        }

                        final docs = snapshot.data!.docs;

                        // Filter by localized service title
                        final filteredDocs = docs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final serviceTitle = data['serviceTitle'];
                          if (serviceTitle is Map<String, dynamic>) {
                            return serviceTitle.values.any(
                              (val) =>
                                  val.toString().toLowerCase().trim() ==
                                  technicianSubservice.toLowerCase().trim(),
                            );
                          }
                          return false;
                        }).toList();

                        return FutureBuilder<List<OrderModelTech>>(
                          future: _filterOrdersWithOffers(filteredDocs, uid),
                          builder: (context, filteredSnapshot) {
                            if (filteredSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Show loading indicator while filtering orders
                              // return Center(
                              //     child: CircularProgressIndicator(
                              //   color: ApplicationColor,
                              // ));
                            }

                            if (filteredSnapshot.hasError ||
                                !filteredSnapshot.hasData) {
                              return Center(
                                  child: Text("loading orders...".tr()));
                            }

                            final orders = filteredSnapshot.data!;
                            if (orders.isEmpty) {
                              return Center(
                                child: Text(
                                  "No Offers Made".tr(),
                                  style: GoogleFonts.castoro(
                                      fontSize: 12,
                                      color: themeProvider.themeMode ==
                                              ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              );
                            }

                            return SizedBox(
                              height: 250,
                              child: ListView.builder(
                                itemCount: orders.length,
                                itemBuilder: (context, index) {
                                  return PreviousOrderCard(
                                      orders: orders[index]);
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                )
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getTechnicianSubservice() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('technician')
        .doc(uid)
        .get();
    return doc['sub_service'];
  }

  Future<List<OrderModelTech>> _filterOrdersWithOffers(
      List<QueryDocumentSnapshot> docs, String uid) async {
    List<OrderModelTech> orders = [];

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;

      // Log data to check if it contains offers
      print("Processing Order: ${data['serviceTitle']}");

      // Fetch offers for this order where the technicianId matches the provided uid
      final offersSnapshot = await doc.reference
          .collection('offers')
          .where('technicianId', isEqualTo: uid)
          .limit(1)
          .get();

      // Log offers snapshot data
      if (offersSnapshot.docs.isEmpty) {
        print("No offers for this order.");
      } else {
        print("Found offers for this order.");
      }

      // If offers are found, process them
      if (offersSnapshot.docs.isNotEmpty) {
        final offerData = offersSnapshot.docs.first.data();
        final offerValue =
            offerData['technicianOffer']?.toString() ?? 'Not Available';

        final serviceTitleMap = data['serviceTitle'];
        Map<String, String> serviceTitleMapChecked = {};
        if (serviceTitleMap is Map<String, dynamic>) {
          serviceTitleMapChecked = Map<String, String>.from(serviceTitleMap);
        }

        final localizedServiceTitle = getServiceTitle(serviceTitleMapChecked);

        // Create an OrderModelTech object with the filtered data
        orders.add(OrderModelTech(
          ServiceType: localizedServiceTitle,
          Description: data['description'] ?? 'No Description',
          Date: data['selectedDate'] ?? 'No Date',
          Time: data['selectedTime'] ?? 'No Time',
          Location: data['area'] ?? 'No Location',
          apartment: data['apartment'] ?? 'No Apartment',
          ServiceImage: data['serviceImage']?.toString() ?? '',
          building: data['building'] ?? 'No building',
          street: data['street'] ?? 'No street',
          fileUrls: List<String>.from(data['fileUrls'] ?? []),
          image: data['profileImageUrl'] ??
              "https://static.vecteezy.com/system/resources/previews/036/280/651/large_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg",
          FName: data['firstName'] ?? 'Unknown',
          LName: data['lastName'] ?? 'Unknown',
          docPath: doc.reference.path,
          Status: data['Status'] ?? 'Unknown',
          previousOffer: offerValue, // assign offer value here
        ));
      }
    }

    return orders;
  }

  String getServiceTitle(Map<String, String> serviceTitleMap) {
    final locale = context.locale.languageCode;
    return serviceTitleMap[locale] ?? serviceTitleMap['en'] ?? '';
  }
}
