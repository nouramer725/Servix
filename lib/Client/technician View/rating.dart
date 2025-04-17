import 'package:cloud_firestore/cloud_firestore.dart';
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
  const RateTechnicianScreen({required this.technicianId});

  @override
  State<RateTechnicianScreen> createState() => _RateTechnicianScreenState();
}

class _RateTechnicianScreenState extends State<RateTechnicianScreen> {
  double _rating = 1.5;
  String _ratingDescription = "Average";
  final TextEditingController _commentController = TextEditingController();

  String getRatingDescription(double rating) {
    if (rating <= 1.0) {
      return "Very Poor";
    } else if (rating <= 1.5)
      return "Poor";
    else if (rating <= 2.5)
      return "Fair";
    else if (rating <= 3.5)
      return "Good";
    else if (rating <= 4.5)
      return "Very Good";
    else
      return "Excellent";
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF333739) : Colors.white,
        title: Text(
          'Rate Technician',
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
            Text('How was your service?',
                style: GoogleFonts.castoro(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                )),
            RatingBar.builder(
              initialRating: _rating,
              unratedColor: Colors.grey,
              minRating: 1,
              allowHalfRating: true,
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
                maxLines: 4,
                style: GoogleFonts.castoro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: const InputDecoration(
                  hintText: 'Leave a comment...',
                  hintStyle: TextStyle(color: Color(0xFFAEAEAE)),
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
                    font: 20,
                    text: 'Cancel',
                  ),
                ),
                Expanded(
                  child: GradientButtonOffer(
                      onPressed: () {
                        _submitRating(_rating, _commentController.text);
                      },
                      font: 20,
                      text: 'Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating(double ratingValue, String comment) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final image = await FirebaseFirestore.instance
          .collection("user-files")
          .doc(user.uid)
          .collection("personalInformation")
          .doc("profile")
          .get();

      final clientName = userDoc['first_name'];
      final clientLastName = userDoc['last_name'];
      final clientImage = image['personalImageUrl'];

      await FirebaseFirestore.instance
          .collection('technician')
          .doc(widget.technicianId)
          .set({
        'Ratings': FieldValue.arrayUnion([
          {
            'clientId': user.uid,
            'clientName': clientName,
            'clientLastName': clientLastName,
            'clientImage': clientImage,
            'rating': ratingValue,
            'comment': comment,
            'timestamp': Timestamp.now(), // 👈 Replace this
          }
        ])
      }, SetOptions(merge: true));

      Fluttertoast.showToast(
        msg: "Thank you for your rating!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor:ApplicationColorWithOpacity,
        textColor: Colors.white,
      );

      Navigator.pop(context);
    } catch (e) {
      print("Error submitting rating: $e");
      Fluttertoast.showToast(
        msg: "Error submitting rating. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
      );
    }
  }
}
