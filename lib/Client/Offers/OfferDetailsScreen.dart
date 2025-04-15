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
          'Offer Details',
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
            Text("Name: ${offer.technicianName}",
                style: GoogleFonts.castoro(fontSize: 18)),
            Text("Rating: ${offer.rating}",
                style: GoogleFonts.castoro(fontSize: 18)),
            Text("Price: ${offer.offer} EGP",
                style: GoogleFonts.castoro(fontSize: 18)),
            Text("Address: ${offer.area}, ${offer.street}",
                style: GoogleFonts.castoro(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
