import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Client/technician%20View/rating.dart';
import 'package:servix/constents/constent.dart';
import '../../Theme/Theme_Provider.dart';
import '../technician View/Profile tech.dart';
import 'model/model.dart';

class OrderCardImgPrevious extends StatelessWidget {
  const OrderCardImgPrevious({required this.orders, super.key});
  final OrderModel orders;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFAEAEAE),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              // Main content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type of service :'.tr(),
                    style: GoogleFonts.castoro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      decoration: TextDecoration.underline,
                      decorationColor: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      decorationThickness: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    orders.ServiceType.tr(),
                    style: GoogleFonts.castoro(
                        fontSize: 14,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Description :'.tr(),
                        style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          orders.Description,
                          style: GoogleFonts.castoro(
                              fontSize: 14,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black),
                          maxLines: 3,
                        )
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Status :'.tr(),
                        style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        orders.Status.tr(),
                        style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 16,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black),
                      const SizedBox(width: 4),
                      Text(
                        orders.Date,
                        style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time,
                          size: 16,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black),
                      const SizedBox(width: 4),
                      Text(
                        orders.Time,
                        style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('technician')
                        .doc(orders.technicianId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text("Error loading data".tr());
                      }

                      final technicianData = snapshot.data;
                      if (technicianData == null || !technicianData.exists) {
                        return Text("No technician found".tr());
                      }

                      final data =
                          technicianData.data() as Map<String, dynamic>;
                      final ratings = data.containsKey('Ratings')
                          ? data['Ratings'] as List
                          : [];

                      final currentUserId =
                          FirebaseAuth.instance.currentUser?.uid;

                      // ✅ Filter by both clientId and serviceId
                      final userRating = ratings.firstWhere(
                        (rating) =>
                            rating['clientId'] == currentUserId &&
                            rating['serviceId'] == orders.orderId,
                        orElse: () => null,
                      );

                      return userRating != null
                          ? RatingBarIndicator(
                              rating: (userRating['rating'] as num).toDouble(),
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: ApplicationColor,
                              ),
                              itemCount: 5,
                              itemSize: 25.0,
                              unratedColor: Colors.grey,
                              direction: Axis.horizontal,
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RateTechnicianScreen(
                                      technicianId: orders.technicianId,
                                      serviceId: orders.orderId,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Rate'.tr(),
                                    style: GoogleFonts.castoro(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          themeProvider.themeMode == ThemeMode.dark
                                              ? Colors.white
                                              : ApplicationColor,
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          themeProvider.themeMode == ThemeMode.dark
                                              ? Colors.white
                                              : ApplicationColor,
                                    ),
                                  ),
                                  Text(
                                    orders.technicianName,
                                    style: GoogleFonts.castoro(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : ApplicationColor,
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : ApplicationColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: context.locale.languageCode == 'ar' ? 5 : null,
                right: context.locale.languageCode == 'en' ? 5 : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TechnicianProfileScreen(
                              technicianName: orders.technicianName,
                              technicianId: orders.technicianId,
                              technicianImage: orders.technicianImage,
                              technicianLocationArea:
                                  orders.technicianLocationArea,
                              technicianLocationStreet:
                                  orders.technicianLocationStreet,
                              technicianPhone: orders.technicianPhone,
                              technicianSub: orders.technicianSub,
                              technicianMain: orders.technicianMain,
                              technicianDescription:
                                  orders.technicianDescription,
                              technicianLinkSocialMedia:
                                  orders.technicianLinkSocialMedia,
                            ),
                          ),
                        );
                      },
                      child: ClipOval(
                        child: Image.network(
                          orders.technicianImage,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        orders.technicianName,
                        style: GoogleFonts.castoro(
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
