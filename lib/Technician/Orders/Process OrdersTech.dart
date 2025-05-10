import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Technician/Orders/model/modelTech.dart';
import 'package:servix/constents/constent.dart';
import '../../Theme/Theme_Provider.dart';
import 'ProcessCardTech.dart';

class ProcessOrderTechPage extends StatefulWidget {
  const ProcessOrderTechPage({super.key});

  @override
  State<ProcessOrderTechPage> createState() => _ProcessOrderTechPageState();
}

class _ProcessOrderTechPageState extends State<ProcessOrderTechPage> {
  late Future<List<OrderModelTech>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _futureOrders = _loadOrders();
  }

  Future<List<OrderModelTech>> _loadOrders() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    final technicianSubservice = await getTechnicianSubservice();
    final snapshot = await FirebaseFirestore.instance
        .collectionGroup('user-services')
        .where('Status', isEqualTo: 'In Progress')
        .get();

    final docs = snapshot.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final serviceTitle = data['serviceTitle'];
      if (serviceTitle is Map<String, dynamic>) {
        return serviceTitle.values.any((val) =>
            val.toString().toLowerCase().trim() ==
            technicianSubservice.toLowerCase().trim());
      }
      return false;
    }).toList();

    return await _filterOrdersWithOffers(docs, uid, context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder<List<OrderModelTech>>(
      future: _futureOrders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: ApplicationColor));
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text("Error loading orders".tr()));
        }

        final orders = snapshot.data!;
        if (orders.isEmpty) {
          return RefreshIndicator(
            color: ApplicationColor,
            backgroundColor: Colors.white,
            onRefresh: () async {
              setState(() {
                _futureOrders = _loadOrders(); // when orders exist
              });
            },
            child: ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "No Processing orders available".tr(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.castoro(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: ApplicationColor,
          backgroundColor: Colors.white,
          onRefresh: () async {
            setState(() {
              _futureOrders = _loadOrders(); // Reload orders on refresh
            });
          },
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return ProcessOrderCardTech(orders: orders[index]);
            },
          ),
        );
      },
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
      List<QueryDocumentSnapshot> docs,
      String uid,
      BuildContext context) async {
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

        final localizedServiceTitle =
            getServiceTitle(serviceTitleMapChecked, context);

        // Create an OrderModelTech object with the filtered data
        orders.add(OrderModelTech(
          ServiceType: localizedServiceTitle,
          Description: data['description'] ?? 'No Description',
          Date: data['selectedDate'] ?? 'No Date',
          Time: data['selectedTime'] ?? 'No Time',
          Location: data['area'] ?? 'No Location',
          apartment: data['apartment'] ?? 'No Apartment',
          building: data['building'] ?? 'No building',
          street: data['street'] ?? 'No street',
          fileUrls: List<String>.from(data['fileUrls'] ?? []),
          image: data['profileImageUrl'] ??
              "https://static.vecteezy.com/system/resources/previews/036/280/651/large_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg",
          FName: data['firstName'] ?? 'Unknown',
          ServiceImage: data['serviceImage']?.toString() ?? '',

          LName: data['lastName'] ?? 'Unknown',
          docPath: doc.reference.path,
          Status: data['Status'] ?? 'Unknown',
          userId: data['userId'] ?? 'Unknown',
          previousOffer: offerValue, // assign offer value here
        ));
      }
    }

    return orders;
  }

  String getServiceTitle(
      Map<String, String> serviceTitleMap, BuildContext context) {
    final locale = context.locale.languageCode;
    return serviceTitleMap[locale] ?? serviceTitleMap['en'] ?? '';
  }
}
