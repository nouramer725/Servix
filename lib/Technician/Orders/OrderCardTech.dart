import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Client/Notification/notification_service.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';
import '../NotificationTech/notification_service_technician.dart';
import 'model/modelTech.dart';

class OrderCardTech extends StatelessWidget {
  const OrderCardTech({required this.orders, super.key});

  final OrderModelTech orders;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final TextEditingController priceController = TextEditingController(
      text: orders.previousOffer ?? "100",
    );
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.attach_money,
                            size: 32, color: ApplicationColor),
                        Text(
                          'Offer to',
                          style: GoogleFonts.judson(
                              fontSize: 28, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${orders.FName}',
                          style: GoogleFonts.judson(
                              fontSize: 28, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Your Offer Price is:',
                          style: GoogleFonts.judson(fontSize: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.judson(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.judson(
                                fontSize: 25, color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Offer',
                            style: GoogleFonts.judson(
                                fontSize: 25, color: ApplicationColor),
                          ),
                          onPressed: () async {
                            String offerPrice = priceController.text;

                            try {
                              final currentUser =
                                  FirebaseAuth.instance.currentUser!;
                              final uid = currentUser.uid;

                              // Fetch technician basic info
                              final technicianDoc = await FirebaseFirestore
                                  .instance
                                  .collection('technician')
                                  .doc(uid)
                                  .get();
                              final techData = technicianDoc.data()!;
                              final fullName =
                                  "${techData['first_name']} ${techData['last_name']}";
                              final phone = techData['phone'];
                              final subService = techData['sub_service'];
                              final mainService = techData['main_service'];
                              final Description = techData['description'];
                              final Reviews = techData['review'];
                              final Products = techData['Products'];
                              final Rating = techData['Ratings'];
                              final LinkSocialMedia =
                                  techData['LinkSocialMedia'];

                              // Fetch profile image from uploads
                              final uploadsSnapshot = await FirebaseFirestore
                                  .instance
                                  .collection("user-files")
                                  .doc(uid)
                                  .collection("uploads")
                                  .limit(1)
                                  .get();
                              String? profileImageUrl;
                              if (uploadsSnapshot.docs.isNotEmpty) {
                                profileImageUrl = uploadsSnapshot
                                    .docs.first['personalFileUrl'];
                              }

                              // Fetch latest location
                              final locationSnapshot = await FirebaseFirestore
                                  .instance
                                  .collection("user-files")
                                  .doc(uid)
                                  .collection("locationDetails")
                                  .orderBy("timestamp", descending: true)
                                  .limit(1)
                                  .get();
                              String street = "Street not available";
                              String area = "Area not available";
                              if (locationSnapshot.docs.isNotEmpty) {
                                final locData =
                                    locationSnapshot.docs.first.data();
                                street = locData['street'] ?? street;
                                area = locData['area'] ?? area;
                              }

                              // Check if an offer already exists for this technician
                              final existingOfferQuery = await FirebaseFirestore
                                  .instance
                                  .doc(orders.docPath!)
                                  .collection("offers")
                                  .where('technicianId', isEqualTo: uid)
                                  .limit(1)
                                  .get();

                              if (existingOfferQuery.docs.isNotEmpty) {
                                final existingOfferDoc =
                                    existingOfferQuery.docs.first;
                                await existingOfferDoc.reference.update({
                                  'technicianOffer': offerPrice,
                                  'timestamp': FieldValue.serverTimestamp(),
                                });

                                Fluttertoast.showToast(
                                    msg: "Offer Updated Successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    backgroundColor:
                                        ApplicationColorWithOpacity,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                // If no offer exists, create a new one
                                await FirebaseFirestore.instance
                                    .doc(orders.docPath!)
                                    .collection("offers")
                                    .add({
                                  'technicianId': uid,
                                  'technicianFirstName': techData['first_name'],
                                  'technicianLastName': techData['last_name'],
                                  'technicianPhone': phone,
                                  'technicianSubService': subService,
                                  'technicianMainService': mainService,
                                  'technicianName': fullName,
                                  'technicianImage': profileImageUrl,
                                  'technicianLocationStreet': street,
                                  'technicianLocationArea': area,
                                  'technicianOffer': offerPrice,
                                  'technicianDescription': Description,
                                  'technicianRating': Rating,
                                  'technicianReviews': Reviews,
                                  'technicianProducts': Products,
                                  'technicianLinkSocialMedia': LinkSocialMedia,
                                  'status': 'offer-made', // ✅ Add this line
                                  'timestamp': FieldValue.serverTimestamp(),
                                });

                                final NotificationServiceTechniciann =
                                    NotificationServiceTechnician(
                                        flutterLocalNotificationsPlugin);
                                NotificationServiceTechniciann
                                    .showAndSaveNotificationTech(
                                  title: 'Offer Submitted',
                                  preview:
                                      'Your offer has been submitted successfully. Be waiting for acceptance or rejection from the client',
                                );


                                Fluttertoast.showToast(
                                    msg: "Offer Submitted Successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    backgroundColor:
                                        ApplicationColorWithOpacity,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }

                              Navigator.of(context).pop();
                            } catch (e) {
                              print('Error submitting offer: $e');
                              Fluttertoast.showToast(
                                  msg: "Failed to submit offer",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  backgroundColor: ApplicationColorWithOpacity,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFAEAEAE), width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        orders.image ??
                            'https://static.vecteezy.com/system/resources/previews/036/280/651/large_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "${orders.FName} ${orders.LName}",
                        style: GoogleFonts.cantataOne(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Type of service :',
                  style: GoogleFonts.cantataOne(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: isDark ? Colors.white : Colors.black,
                    decorationThickness: 2,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Service: ${orders.ServiceType}',
                  style: GoogleFonts.castoro(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Description : ${orders.Description}',
                  style: GoogleFonts.castoro(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Location : ${orders.Location}',
                  style: GoogleFonts.castoro(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 18,
                                color: isDark ? Colors.white : Colors.black),
                            const SizedBox(width: 4),
                            Text(
                              orders.Date,
                              style: GoogleFonts.castoro(
                                fontSize: 14,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 18,
                                color: isDark ? Colors.white : Colors.black),
                            const SizedBox(width: 4),
                            Text(
                              orders.Time,
                              style: GoogleFonts.castoro(
                                fontSize: 14,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
