import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  final String technicianId;
  final String technicianName;
  final String technicianImage;
  final String offer;
  final String street;
  final String area;
  final String rating;

  Offer({
    required this.technicianId,
    required this.technicianName,
    required this.technicianImage,
    required this.offer,
    required this.street,
    required this.area,
    required this.rating,
  });

  factory Offer.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Offer(
      technicianId: data['technicianId'],
      technicianName: data['technicianName'],
      technicianImage: data['technicianImage'] ?? '',
      offer: data['technicianOffer'],
      street: data['technicianLocationStreet'] ?? '',
      area: data['technicianLocationArea'] ?? '',
      rating: data['technicianRating'] ?? '0.0',
    );
  }
}
