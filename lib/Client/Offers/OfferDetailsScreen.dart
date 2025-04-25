import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Model/Offer.dart';

class OfferDetailsScreen extends StatelessWidget {
  final Offer offer;

  const OfferDetailsScreen({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Offer Details'.tr(),
          style:
              GoogleFonts.cantataOne(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: CircleAvatar(
                    backgroundImage: NetworkImage(offer.technicianImage),
                    radius: 50)),
            const SizedBox(height: 20),
            Row(
              children: [
                Text("Name:".tr(), style: GoogleFonts.castoro(fontSize: 18)),
                const SizedBox(width: 10),
                Text(offer.technicianName,
                    style: GoogleFonts.castoro(fontSize: 18)),
              ],
            ),
            Row(
              children: [
                Text("Rating:".tr(), style: GoogleFonts.castoro(fontSize: 18)),
                const SizedBox(width: 10),
                Text(offer.rating.toString(),
                    style: GoogleFonts.castoro(fontSize: 18)),
              ],
            ),
            Row(
              children: [
                Text("Price:".tr(), style: GoogleFonts.castoro(fontSize: 18)),
                const SizedBox(width: 10),
                Text(offer.offer.toString(),
                    style: GoogleFonts.castoro(fontSize: 18)),
                const SizedBox(width: 10),
                Text("EGP".tr(), style: GoogleFonts.castoro(fontSize: 18)),
              ],
            ),
            Row(
              children: [
                Text("Address:".tr(), style: GoogleFonts.castoro(fontSize: 18)),
                const SizedBox(width: 10),
                Text("${offer.area} ${offer.street}",
                    style: GoogleFonts.castoro(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
