import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Components/Buttons.dart';

import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';

class RateTechnicianScreen extends StatefulWidget {
  final String technicianId;
  final String serviceId; // Add this line
  const RateTechnicianScreen(
      {required this.technicianId, required this.serviceId});

  @override
  State<RateTechnicianScreen> createState() => _RateTechnicianScreenState();
}

class _RateTechnicianScreenState extends State<RateTechnicianScreen> {
  double _rating = 0.0;
  String _ratingDescription = "";
  final TextEditingController _commentController = TextEditingController();

  String getRatingDescription(double rating) {
    if (rating <= 1.0) {
      return "Very Poor".tr();
    } else if (rating <= 1.5) {
      return "Poor".tr();
    } else if (rating <= 2.5) {
      return "Fair".tr();
    } else if (rating <= 3.5) {
      return "Good".tr();
    } else if (rating <= 4.5) {
      return "Very Good".tr();
    } else {
      return "Excellent".tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF333739) : Colors.white,
        title: Text(
          'Rate Technician'.tr(),
          style: GoogleFonts.castoro(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('How was your service?'.tr(),
                style: GoogleFonts.castoro(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                )),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 0.5,
              allowHalfRating: true,
              unratedColor: Colors.grey,
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: 40,
              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
              wrapAlignment: WrapAlignment.center,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: ApplicationColor,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                  _ratingDescription = getRatingDescription(rating);
                });
              },
            ),
            const SizedBox(height: 10),
            Text(
              _ratingDescription,
              style: GoogleFonts.castoro(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFAEAEAE), width: 1.5),
              ),
              child: TextFormField(
                controller: _commentController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                cursorColor: Colors.black,
                cursorWidth: 2,
                maxLines: 4,
                style: GoogleFonts.castoro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: 'Leave a comment...'.tr(),
                  hintStyle: GoogleFonts.castoro(color: Color(0xFFAEAEAE)),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: WhiteButtonOffer(
                    onPressed: () => Navigator.pop(context),
                    text: 'Cancel'.tr(),
                  ),
                ),
                Expanded(
                  child: GradientButtonOffer(
                      onPressed: () {
                        _submitRating(_rating, _commentController.text);
                      },
                      text: 'Submit'.tr()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating(double ratingValue, String comment) async {
    if (ratingValue == 0.0) {
      Fluttertoast.showToast(
          msg: "Please select a rating before submitting.".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Fetching profile image (profile document in 'personalInformation')
      final imageDoc = await FirebaseFirestore.instance
          .collection("user-files")
          .doc(user.uid)
          .collection("personalInformation")
          .doc("profile")
          .get();

      String? clientImage;

      // Check if the 'profile' document exists
      if (imageDoc.exists) {
        // Check if the 'personalImageUrl' field exists
        if (imageDoc.data() != null &&
            imageDoc.data()!.containsKey('personalImageUrl')) {
          clientImage = imageDoc['personalImageUrl'];
        } else {
          // Handle case where the 'personalImageUrl' field is missing
          clientImage = null;
        }
      }

      // Fetching file data from 'uploads' collection
      final imagetech = await FirebaseFirestore.instance
          .collection("user-files")
          .doc(user.uid)
          .collection("uploads")
          .limit(1)
          .get();

      String? clientimage2;
      if (imagetech.docs.isNotEmpty) {
        final docData = imagetech.docs.first.data();
        clientimage2 = docData[
            'personalFileUrl']; // Access personalFileUrl from the first document
      }

      // Fallback default image
      const defaultImageUrl =
          'https://static.vecteezy.com/system/resources/previews/036/280/651/large_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg';

      final finalClientImage = clientimage2 ?? clientImage ?? defaultImageUrl;
      // Final image to use for technician rating submission

      // Ensure that a valid image URL is available
      if (finalClientImage == null) {
        Fluttertoast.showToast(
          msg: "No image found for the user.".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
        );
        return;
      }

      final clientName = userDoc['first_name'];
      final clientLastName = userDoc['last_name'];

      // Submit rating to Firestore
      await FirebaseFirestore.instance
          .collection('technician')
          .doc(widget.technicianId)
          .set({
        'Ratings': FieldValue.arrayUnion([
          {
            'clientId': user.uid,
            'clientName': clientName,
            'clientLastName': clientLastName,
            'clientImage':
                finalClientImage, // Use the final image (either from 'image' or 'imagetech')
            'rating': ratingValue,
            'comment': comment,
            'serviceId': widget.serviceId,
            'timestamp': Timestamp.now(),
          }
        ])
      }, SetOptions(merge: true));

      Fluttertoast.showToast(
        msg: "Thank you for your rating!".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
      );

      Navigator.pop(context);
    } catch (e) {
      print("Error submitting rating: $e");
      Fluttertoast.showToast(
        msg: "Error submitting rating. Please try again.".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
      );
    }
  }
}
