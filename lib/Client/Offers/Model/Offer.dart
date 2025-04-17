import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  final String technicianId;
  final String technicianName;
  final String technicianImage;
  final double offer;
  final String street;
  final String area;
  final List<dynamic> rating;
  final String id;

  Offer({
    required this.technicianId,
    required this.technicianName,
    required this.technicianImage,
    required this.offer,
    required this.street,
    required this.area,
    required this.rating,
    required this.id,
  });

  factory Offer.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    double parsedOffer;
    final offerRaw = data['technicianOffer'];

    if (offerRaw is String) {
      parsedOffer = double.tryParse(offerRaw) ?? 0.0;
    } else if (offerRaw is int) {
      parsedOffer = offerRaw.toDouble();
    } else if (offerRaw is double) {
      parsedOffer = offerRaw;
    } else {
      parsedOffer = 0.0;
    }

    return Offer(
      id: doc.id,
      technicianId: data['technicianId'] ?? '',
      technicianName: data['technicianName'] ?? '',
      technicianImage: data['technicianImage'] ?? '',
      offer: parsedOffer,
      street: data['technicianLocationStreet'] ?? '',
      area: data['technicianLocationArea'] ?? '',
      rating: data['technicianRating'] ?? [],
    );
  }
}
