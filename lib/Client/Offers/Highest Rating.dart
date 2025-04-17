import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Components/Buttons.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';
import 'Lowest Price.dart';
import 'Model/Offer.dart';
import 'OfferDetailsScreen.dart';
import 'The Nearest.dart';
import 'offer_card.dart';

class HighestRatingScreen extends StatefulWidget {
  final String orderId;
  const HighestRatingScreen({super.key, required this.orderId});

  @override
  State<HighestRatingScreen> createState() => _HighestRatingScreenState();
}

class _HighestRatingScreenState extends State<HighestRatingScreen> {
  int selectedIndex = 1;
  List<Offer> offers = [];
  bool isLoading = true;

  Future<void> fetchOffers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user logged in");
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
            .doc(serviceId)
            .collection('offers')
            .get();

        if (offerSnapshot.docs.isNotEmpty) {
          final fetchedOffers = offerSnapshot.docs.map((offerDoc) {
            return Offer.fromFirestore(offerDoc);
          }).toList();

          // Add offers for this service to the list
          allOffers.addAll(fetchedOffers);
        }
      }

      if (allOffers.isNotEmpty) {
        setState(() {
          offers = allOffers; // Update the offers list
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
        print("📭 No user services found.");
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

  // Handle button selection
  void onSelect(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LowestPriceScreen(
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

  // Method to remove an offer from the list
  void removeOffer(String id) {
    setState(() {
      offers.removeWhere((offer) => offer.technicianId == id);
    });
  }

  // Build the buttons for selection
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
          "Offers",
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
            Row(
              children: [
                Expanded(child: buildOptionButton("The Nearest", 0)),
                Expanded(child: buildOptionButton("Highest Rating", 1)),
                Expanded(child: buildOptionButton("Lowest price", 2)),
              ],
            ),
            const SizedBox(height: 20),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(color: ApplicationColor))
                : Expanded(
                    child: offers.isEmpty
                        ? const Center(child: Text('No offers found.'))
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

        print("✅ Offer deleted for technicianId: $technicianId");
      } else {
        print('🚨 No service found for the given orderId');
      }
    } catch (e) {
      print('🚨 Error declining offer: $e');
    }
  }
}
