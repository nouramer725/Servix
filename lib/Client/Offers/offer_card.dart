import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/constents/constent.dart';
import '../../Components/Buttons.dart';
import '../../Theme/Theme_Provider.dart';
import 'Model/Offer.dart';

class OfferCard extends StatefulWidget {
  final Offer offer;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const OfferCard({
    super.key,
    required this.offer,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
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
    getAverageRating(widget.offer.technicianId);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        color: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xff979292)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.offer.technicianImage),
                    radius: 25,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.offer.technicianName,
                        style: GoogleFonts.castoro(
                          fontSize: 20,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FutureBuilder<double>(
                        future: getAverageRating(widget.offer.technicianId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                          } else if (snapshot.hasError) {
                            print('Error loading rating');
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
                                  size: 20,
                                ),
                              // Half star (if necessary)
                              if (hasHalfStar)
                                Icon(
                                  Icons.star_half,
                                  color: ApplicationColor,
                                  size: 20,
                                ),
                              // Empty stars
                              for (int i = 0; i < emptyStars; i++)
                                const Icon(
                                  Icons.star_border,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              const SizedBox(width: 10),
                              // Display the numeric rating value
                              Text(
                                avgRating.toStringAsFixed(1),
                                style: GoogleFonts.castoro(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ApplicationColor3,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "EGP".tr(),
                    style: GoogleFonts.castoro(
                        fontSize: 20,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                  const SizedBox(width: 5,),
                  Text(
                    "${widget.offer.offer}",
                    style: GoogleFonts.castoro(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on_sharp,
                      size: 16, color: ApplicationColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "${widget.offer.area} , ${widget.offer.street}",
                      style: GoogleFonts.castoro(
                          fontSize: 14,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GradientButtonOffer(
                      text: "Accept".tr(),
                      font: 18,
                      onPressed: widget.onAccept,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: WhiteButtonOffer(
                      text: "Reject".tr(),
                      font: 18,
                      onPressed: widget.onDecline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
