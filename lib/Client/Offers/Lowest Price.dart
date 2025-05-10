import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Components/Buttons.dart';
import '../../Notification/notification_send_to_tech.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';
import 'Highest Rating.dart';
import 'The Nearest.dart';
import 'Model/Offer.dart';
import 'offer_card.dart';

class LowestPriceScreen extends StatefulWidget {
  final String orderId;
  const LowestPriceScreen({super.key, required this.orderId});

  @override
  State<LowestPriceScreen> createState() => _LowestPriceScreenState();
}

class _LowestPriceScreenState extends State<LowestPriceScreen> {
  int selectedIndex = 2;
  List<Offer> offers = [];
  bool isLoading = true;

  Future<void> fetchOffers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user logged in".tr());
      }

      final userUid = user.uid;

      // Get the orderId from Firestore if it's not passed via widget
      final orderId = widget.orderId ?? await fetchOrderId();

      if (orderId == null) {
        print("⚠️ No orderId found.");
        return;
      }

      print("🔍 Fetching offers for orderId: $orderId");

      final snapshot = await FirebaseFirestore.instance
          .collection('Services Requests')
          .doc(userUid)
          .collection('user-services')
          .where('orderId', isEqualTo: orderId)
          .get();

      List<Offer> allOffers = [];

      // Loop through all the services and fetch offers for each one
      for (var doc in snapshot.docs) {
        final serviceId = doc.id;

        // Fetch the offers for the specific service
        final offerSnapshot = await FirebaseFirestore.instance
            .collection('Services Requests')
            .doc(userUid)
            .collection('user-services')
            .doc(
                serviceId) // Make sure to fetch offers for this specific service
            .collection('offers')
            .get();

        if (offerSnapshot.docs.isNotEmpty) {
          final fetchedOffers = offerSnapshot.docs.map((offerDoc) {
            return Offer.fromFirestore(offerDoc);
          }).toList();
          allOffers.addAll(fetchedOffers);
        }
      }

      if (allOffers.isNotEmpty) {
        allOffers.sort((a, b) => a.offer.compareTo(b.offer));
        setState(() {
          offers = allOffers;
        });
      } else {
        print("📭 No offers found for orderId: $orderId");
      }
    } catch (e) {
      print('🚨 Error fetching offers: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String?> fetchOrderId() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("❌ No user logged in.");
        return null;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('Services Requests')
          .doc(user.uid)
          .collection('user-services')
          .get();

      if (snapshot.docs.isEmpty) {
        print("📭 No user services found.".tr());
        return null;
      }

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final orderId = data['orderId'] ?? doc.id;
        print("✅ Found orderId: $orderId");
        return orderId;
      }

      return null;
    } catch (e) {
      print("🚨 Error fetching orderId: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOffers();
    fetchOrderId();
  }

  // Method to handle button selection
  void onSelect(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HighestRatingScreen(
                  orderId: widget.orderId,
                )),
      );
    } else if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TheNearestScreen(
                  orderId: widget.orderId,
                )),
      );
    }
  }

  void removeOffer(String id) {
    setState(() {
      offers.removeWhere((offer) => offer.technicianId == id);
    });
  }

  // Method to build buttons
  Widget buildOptionButton(String text, int index) {
    final isSelected = selectedIndex == index;
    return SizedBox(
      height: 50,
      child: isSelected
          ? GradientButtonOffer(
              text: text,
              font: 14,
              onPressed: () => onSelect(index),
            )
          : WhiteButtonOffer(
              text: text,
              font: 14,
              onPressed: () => onSelect(index),
            ),
    );
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
          "Offers".tr(),
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
        child: Column(
          children: [
            // Buttons for selection
            Row(
              children: [
                Expanded(child: buildOptionButton("The Nearest".tr(), 0)),
                Expanded(child: buildOptionButton("Highest Rating".tr(), 1)),
                Expanded(child: buildOptionButton("Lowest price".tr(), 2)),
              ],
            ),
            const SizedBox(height: 20),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(color: ApplicationColor))
                : Expanded(
                    child: offers.isEmpty
                        ? Center(
                            child: Text(
                            'No offers found.'.tr(),
                            style: GoogleFonts.castoro(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ))
                        : ListView.builder(
                            itemCount: offers.length,
                            itemBuilder: (context, index) {
                              final offer = offers[index];
                              return OfferCard(
                                offer: offer,
                                onDecline: () => onDecline(offer.technicianId),
                                onAccept: () =>
                                    onAccept(offer), // Accept the offer
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }

  void onAccept(Offer offer) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user logged in");
      }

      final userUid = user.uid;
      final orderId = widget.orderId;

      // Step 1: Update the order status to "In Progress"
      final snapshot = await FirebaseFirestore.instance
          .collection('Services Requests')
          .doc(userUid)
          .collection('user-services')
          .where('orderId', isEqualTo: orderId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final serviceId = snapshot.docs.first.id;

        // Update the status of the order to "In Progress"
        await FirebaseFirestore.instance
            .collection('Services Requests')
            .doc(userUid)
            .collection('user-services')
            .doc(serviceId)
            .update({'Status': 'In Progress'});

        // Step 2: Remove all offers related to the order except the accepted one
        final offerSnapshot = await FirebaseFirestore.instance
            .collection('Services Requests')
            .doc(userUid)
            .collection('user-services')
            .doc(serviceId)
            .collection('offers')
            .get();

        // Remove all offers except the accepted one
        for (var offerDoc in offerSnapshot.docs) {
          if (offerDoc.id != offer.id) {
            await offerDoc.reference.delete();
          }
        }
        // Step 3: Send notification to the technician whose offer was accepted
        await sendOfferAcceptedNotification(offer);
        Fluttertoast.showToast(
          msg: "Offer accepted successfully",
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );

        Navigator.pop(context);
        Navigator.pop(context);

        setState(() {
          offers.removeWhere((item) => item.id != offer.id);
        });

        print(
            "✅ All offers removed for orderId: $orderId, except the accepted one.");
      }
    } catch (e) {
      print('🚨 Error accepting offer and removing offers: $e');
    }
  }

  void onDecline(String technicianId) async {
    try {
      // 1. Get the current logged-in user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user logged in");
      }

      final userUid = user.uid;

      // 2. Get the orderId from the widget (the current order's ID)
      final orderId = widget.orderId;

      // 3. Fetch the service ID by querying the 'user-services' collection based on the orderId
      final snapshot = await FirebaseFirestore.instance
          .collection('Services Requests')
          .doc(userUid)
          .collection('user-services')
          .where('orderId', isEqualTo: orderId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final serviceId =
            snapshot.docs.first.id; // Get the serviceId from the document

        // 4. Delete the offer for the technician with the given technicianId
        print(
            "🗑️ Deleting offer for technicianId: $technicianId in serviceId: $serviceId");

        await FirebaseFirestore.instance
            .collection('Services Requests')
            .doc(userUid)
            .collection('user-services')
            .doc(serviceId)
            .collection('offers')
            .doc(technicianId)
            .delete();

        // Step 5: Send notification to the technician whose offer was rejected
        await sendOfferRejectedNotification(technicianId);
        Fluttertoast.showToast(
          msg: "Offer rejected successfully",
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );

        print("✅ Offer deleted for technicianId: $technicianId");
        fetchOffers(); // Refresh the list of offers
        setState(() {
          offers.removeWhere((offer) => offer.technicianId == technicianId);
        });
        print("✅ Offers list updated after deletion.");

        // final NotificationServiceTechniciann =
        //     NotificationServiceTechnician(flutterLocalNotificationsPlugin);
        // NotificationServiceTechniciann.showAndSaveNotificationTech(
        //   title: 'Offer Updates!',
        //   preview: 'Client Rejected your offer',
        // );
      } else {
        print('🚨 No service found for the given orderId');
      }
    } catch (e) {
      print('🚨 Error declining offer: $e');
    }
  }
}
