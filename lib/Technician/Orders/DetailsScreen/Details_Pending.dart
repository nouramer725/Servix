import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Technician/Orders/model/modelTech.dart';
import '../../../Components/Buttons.dart';
import '../../../Notification/notification_send_to_tech.dart';
import '../../../Technician/Orders/model/VideoPlayerWidget.dart';
import '../../../Theme/Theme_Provider.dart';
import '../../../constents/constent.dart';

class DetailsPendingTech extends StatefulWidget {
  final OrderModelTech orders;

  const DetailsPendingTech({super.key, required this.orders});

  @override
  State<DetailsPendingTech> createState() => _DetailsPendingTechState();
}

class _DetailsPendingTechState extends State<DetailsPendingTech> {
  double _blurValue = 0;
  int currentIndex = 0;
  final TextEditingController priceController = TextEditingController();
  final TextEditingController feesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final orders = widget.orders;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: orders.fileUrls.isEmpty
                ? Image.asset(
                    orders.ServiceImage,
                    height: 450,
                    fit: BoxFit.cover,
                  )
                : Stack(
                    children: [
                      CarouselSlider.builder(
                        itemCount: orders.fileUrls.length,
                        itemBuilder: (context, index, realIndex) {
                          final url = orders.fileUrls[index];
                          final isVideo = url.toLowerCase().endsWith('.mp4');
                          return isVideo
                              ? AspectRatio(
                                  aspectRatio: 25 / 9,
                                  child: VideoPlayerWidget(url: url),
                                )
                              : Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                        },
                        options: CarouselOptions(
                          height: 400,
                          autoPlay: false,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          aspectRatio: 25 / 9,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                      ),

                      // File count overlay in top-right corner
                      Positioned(
                        top: 50,
                        right: context.locale.languageCode == 'ar' ? null : 16,
                        left: context.locale.languageCode == 'ar' ? 16 : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${currentIndex + 1}/${orders.fileUrls.length}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          // Bottom sheet
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.55,
            maxChildSize: 0.80,
            builder: (context, scrollController) {
              scrollController.addListener(() {
                final offset = scrollController.offset;
                final newBlur = offset.clamp(0, 30) / 5;
                if (newBlur != _blurValue) {
                  setState(() {
                    _blurValue = newBlur;
                  });
                }
              });

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Service Type:".tr(),
                          style: GoogleFonts.castoro(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            orders.ServiceType.tr(),
                            style: GoogleFonts.castoro(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${orders.Location}, ${orders.street}, ${orders.building}, ${orders.apartment}",
                      style: GoogleFonts.castoro(
                        fontSize: 17,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black12,
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Status :".tr(),
                          style: GoogleFonts.castoro(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            orders.Status.tr(),
                            style: GoogleFonts.castoro(
                              fontSize: 20,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black12,
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      orders.Description,
                      style: GoogleFonts.castoro(
                        fontSize: 20,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black12,
                      thickness: 2,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Time Row
                          Column(
                            children: [
                              Text(
                                "Time:".tr(),
                                style: GoogleFonts.castoro(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black38,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                orders.Time,
                                style: GoogleFonts.castoro(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          VerticalDivider(
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black12,
                            thickness: 2,
                          ),
                          Column(
                            children: [
                              Text(
                                "Date:".tr(),
                                style: GoogleFonts.castoro(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : const Color(0xFF9E9E9E),
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                orders.Date,
                                style: GoogleFonts.castoro(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black12,
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Price:".tr(),
                                style: GoogleFonts.castoro(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black,
                                )),
                            const SizedBox(width: 80),
                            Expanded(
                              child: TextField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                textInputAction: TextInputAction.done,
                                onChanged: (value) {
                                  final double? price = double.tryParse(value);
                                  if (price != null) {
                                    final double fees = price * 0.10;
                                    feesController.text =
                                        fees.toStringAsFixed(2);
                                  } else {
                                    feesController.clear();
                                  }
                                },
                                autocorrect: true,
                                enableSuggestions: true,
                                cursorColor: Colors.grey[400],
                                style: GoogleFonts.judson(
                                    color: themeProvider.themeMode ==
                                            ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  hintText: "Enter Your Offer Price".tr(),
                                  hintStyle: GoogleFonts.judson(
                                      fontSize: 15,
                                      color: themeProvider.themeMode ==
                                              ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black),
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color(0xffAEAEAE)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color(0xffAEAEAE)),
                                  ),
                                  filled: false,
                                  fillColor: Colors.grey[100],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text("-> The Service fees of this service will be".tr(),
                        style: GoogleFonts.castoro(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                        )),
                    const SizedBox(width: 25),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: feesController,
                      builder: (context, value, _) {
                        return Text(
                          value.text,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.judson(
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? ApplicationColor6
                                : ApplicationColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GradientButton(
                      onPressed: () async {
                        String offerPrice = priceController.text;
                        String fees = feesController.text;

                        if (priceController.text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Please enter a price".tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            backgroundColor: ApplicationColorWithOpacity,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }

                        try {
                          final currentUser =
                              FirebaseAuth.instance.currentUser!;
                          final uid = currentUser.uid;

                          // Fetch technician basic info
                          final technicianDoc = await FirebaseFirestore.instance
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
                          final LinkSocialMedia = techData['LinkSocialMedia'];

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
                            profileImageUrl =
                                uploadsSnapshot.docs.first['personalFileUrl'];
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
                            final locData = locationSnapshot.docs.first.data();
                            street = locData['street'] ?? street;
                            area = locData['area'] ?? area;
                          }

                          // Check if an offer already exists for this technician
                          final existingOfferQuery = await FirebaseFirestore
                              .instance
                              .doc(widget.orders.docPath!)
                              .collection("offers")
                              .where('technicianId', isEqualTo: uid)
                              .limit(1)
                              .get();

                          if (existingOfferQuery.docs.isNotEmpty) {
                            final existingOfferDoc =
                                existingOfferQuery.docs.first;

                            // Update the existing offer with the new price and fees
                            await existingOfferDoc.reference.update({
                              'technicianOffer': offerPrice,
                              'technicianFees': fees,
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                            // Update service fees (set the value instead of incrementing)
                            await updateServiceFees(
                                uid, double.tryParse(fees) ?? 0);

                            final orderDoc = await FirebaseFirestore.instance
                                .doc(widget.orders.docPath!)
                                .get();
                            final orderData = orderDoc.data();
                            final clientId =
                                orderData?['userId']; // adjust if needed
                            if (clientId != null) {
                              await sendClientOfferNotification(
                                clientId: clientId,
                                technicianName: fullName,
                              );
                            }

                            Fluttertoast.showToast(
                              msg: "Offer Updated Successfully".tr(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              backgroundColor: ApplicationColorWithOpacity,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            // If no offer exists, create a new one
                            await FirebaseFirestore.instance
                                .doc(widget.orders.docPath!)
                                .collection("offers")
                                .doc(uid) // Use technician ID as document ID
                                .set({
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
                              'technicianFees': fees,
                              'technicianDescription': Description,
                              'technicianLinkSocialMedia': LinkSocialMedia,
                              'status': 'offer-made',
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                            final orderDoc = await FirebaseFirestore.instance
                                .doc(widget.orders.docPath!)
                                .get();
                            final orderData = orderDoc.data();
                            final clientId =
                                orderData?['userId']; // adjust if needed
                            if (clientId != null) {
                              await sendClientOfferNotification(
                                clientId: clientId,
                                technicianName: fullName,
                              );
                            }

                            Fluttertoast.showToast(
                              msg: "Offer Submitted Successfully".tr(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              backgroundColor: ApplicationColorWithOpacity,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }

                          Navigator.of(context).pop();
                        } catch (e) {
                          print('Error submitting offer: $e');
                          Fluttertoast.showToast(
                            msg: "Failed to submit offer".tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            backgroundColor: ApplicationColorWithOpacity,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      text: "Offer".tr(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> updateServiceFees(String technicianId, double feesAmount) async {
    try {
      // Fetch the technician document from Firestore
      DocumentSnapshot technicianSnapshot = await FirebaseFirestore.instance
          .collection('technician')
          .doc(technicianId)
          .get();

      // Debugging: Check if the document exists
      if (!technicianSnapshot.exists) {
        print("Technician document does not exist.");
        return;
      }

      double currentFees = 0.0;

      // If the technician document exists, check if it has 'serviceFees'
      if (technicianSnapshot.exists && technicianSnapshot.data() != null) {
        final data = technicianSnapshot.data() as Map<String, dynamic>;

        // Debugging: Print the data retrieved
        print("Technician Data: $data");

        if (data.containsKey('serviceFees')) {
          currentFees = (data['serviceFees'] as num).toDouble();
          print("Current Fees: $currentFees");
        } else {
          print("serviceFees field not found, setting currentFees to 0.0");
        }
      }

      // Calculate the updated fees
      double updatedFees = currentFees + feesAmount;
      print("Updated Fees: $updatedFees");

      // Update the service fees in Firestore
      await FirebaseFirestore.instance
          .collection('technician')
          .doc(technicianId)
          .update({
        'serviceFees': updatedFees,
      });

      // Debugging: Confirm update was successful
      print("Service fees updated successfully.");
    } catch (e) {
      // Catch and log any errors
      print("Error updating service fees: $e");
    }
  }
}
