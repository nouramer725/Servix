import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  final String technicianId;
  final String technicianName;
  final String technicianImage;
  final String technicianLocationArea;
  final String technicianLocationStreet;
  final String technicianPhone;
  final String technicianSub;
  final String technicianMain;
  final String technicianDescription;
  final String technicianOffer;
  final String technicianLinkSocialMedia;
  final double offer;
  final String street;
  final String area;
  final List<dynamic> rating;
  final String id;
  final double averageRating; // Add averageRating field

  Offer({
    required this.technicianId,
    required this.technicianName,
    required this.technicianImage,
    required this.technicianLocationArea,
    required this.technicianLocationStreet,
    required this.technicianPhone,
    required this.technicianSub,
    required this.technicianMain,
    required this.technicianDescription,
    required this.technicianOffer,
    required this.technicianLinkSocialMedia,
    required this.offer,
    required this.street,
    required this.area,
    required this.rating,
    required this.id,
    required this.averageRating, // Initialize averageRating in constructor
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

    // Fetch technician rating based on technicianId
    double averageRating = 0.0;
    if (data['technicianId'] != null) {
      final technicianId = data['technicianId'];
      FirebaseFirestore.instance
          .collection('technician')
          .doc(technicianId)
          .get()
          .then((technicianDoc) {
        if (technicianDoc.exists) {
          final technicianData = technicianDoc.data() as Map<String, dynamic>;

          if (technicianData['Ratings'] != null &&
              technicianData['Ratings'].isNotEmpty) {
            double total = 0.0;
            List<dynamic> ratings = technicianData['Ratings'];
            for (var rating in ratings) {
              total += rating['rating']; // Assuming the field name is 'rating'
            }
            averageRating = total / ratings.length;
          }
        }
      }).catchError((error) {
        print("Error fetching technician's rating: $error");
      });
    }

    return Offer(
      id: doc.id,
      technicianId: data['technicianId'] ?? '',
      technicianLocationArea: data['technicianLocationArea'] ?? '',
      technicianLocationStreet: data['technicianLocationStreet'] ?? '',
      technicianPhone: data['technicianPhone'] ?? '',
      technicianSub: data['technicianSubService'] ?? '',
      technicianMain: data['technicianMainService'] ?? '',
      technicianDescription: data['technicianDescription'] ?? '',
      technicianOffer: data['technicianOffer'] ?? '',
      technicianLinkSocialMedia: data['technicianLinkSocialMedia'] ?? '',
      technicianName: data['technicianName'] ?? '',
      technicianImage: data['technicianImage'] ??
          'https://static.vecteezy.com/system/resources/previews/036/280/651/large_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg',
      offer: parsedOffer,
      street: data['technicianLocationStreet'] ?? '',
      area: data['technicianLocationArea'] ?? '',
      rating: data['technicianRating'] ?? [],
      averageRating: averageRating, // Store calculated averageRating
    );
  }
}
