import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Components/Buttons.dart';
import 'Model/Offer.dart';

class OfferCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
                  backgroundImage: AssetImage(offer.image),
                  radius: 25,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.name,
                      style: GoogleFonts.castoro(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          offer.rating.toString(),
                          style: GoogleFonts.castoro(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < offer.rating.floor()
                                  ? Icons.star_rate_rounded
                                  : Icons.star_outline_rounded,
                              size: 20,
                              color: Colors.black,
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "EGP ${offer.price}",
              style: GoogleFonts.castoro(fontSize: 20),
            ),
            Row(
              children: [
                const Icon(Icons.location_on_sharp,
                    size: 16, color: Color(0xFF821717)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "${offer.address1} , ${offer.address2}",
                    style: GoogleFonts.castoro(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GradientButtonOffer(
                    text: "Accept",
                    font: 18,
                    onPressed: onAccept,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: WhiteButtonOffer(
                    text: "Decline",
                    font: 18,
                    onPressed: onDecline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
