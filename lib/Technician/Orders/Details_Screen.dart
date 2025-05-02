import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Components/Buttons.dart';
import 'package:servix/constents/constent.dart';
import '../../Theme/Theme_Provider.dart';
import 'model/VideoPlayerWidget.dart';
import 'model/modelTech.dart';

class DetailsScreen extends StatefulWidget {
  final OrderModelTech orders;

  const DetailsScreen({super.key, required this.orders});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final TextEditingController priceController = TextEditingController();
    final TextEditingController feesController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Text('Service Details',
            style: GoogleFonts.castoro(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              widget.orders.image ??
                                  'https://static.vecteezy.com/system/resources/previews/036/280/651/large_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "${widget.orders.FName} ${widget.orders.LName}",
                              style: GoogleFonts.cantataOne(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Service Type:",
                            style: GoogleFonts.castoro(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.orders.ServiceType,
                            style: GoogleFonts.castoro(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Description:",
                            style: GoogleFonts.castoro(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              widget.orders.Description,
                              style: GoogleFonts.castoro(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Date:",
                            style: GoogleFonts.castoro(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black38,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.orders.Date,
                            style: GoogleFonts.castoro(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black38,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Time:",
                            style: GoogleFonts.castoro(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black38,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.orders.Time,
                            style: GoogleFonts.castoro(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black38,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Area:",
                            style: GoogleFonts.castoro(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black38,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "${widget.orders.Location} , ${widget.orders.street}",
                              style: GoogleFonts.castoro(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black38,
                              ),
                              maxLines: 5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.orders.fileUrls.length,
                          itemBuilder: (context, index) {
                            final url = widget.orders.fileUrls[index];
                            final isVideo = url.toLowerCase().endsWith('.mp4');

                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: isVideo
                                  ? AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: VideoPlayerWidget(url: url),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        url,
                                        width: 150,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black12,
                thickness: 2,
                indent: 10,
                endIndent: 10,
              ),
              Text(
                "Offer Price:",
                style: GoogleFonts.castoro(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Price:",
                              style: GoogleFonts.castoro(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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
                                  feesController.text = fees.toStringAsFixed(2);
                                } else {
                                  feesController.clear();
                                }
                              },
                              autocorrect: true,
                              enableSuggestions: true,
                              cursorColor: Colors.grey[400],
                              style: GoogleFonts.judson(
                                  color:
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: "Enter Your Offer Price",
                                hintStyle: GoogleFonts.judson(fontSize: 15),
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
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("-> The Service fees of this service will be",
                      style: GoogleFonts.castoro(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(width: 25),
                  Expanded(
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: feesController,
                      builder: (context, value, _) {
                        return Text(
                          value.text,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.judson(
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? ApplicationColor6
                                : ApplicationColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
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
                    final currentUser = FirebaseAuth.instance.currentUser!;
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
                    final uploadsSnapshot = await FirebaseFirestore.instance
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
                    final locationSnapshot = await FirebaseFirestore.instance
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
                    final existingOfferQuery = await FirebaseFirestore.instance
                        .doc(widget.orders.docPath!)
                        .collection("offers")
                        .where('technicianId', isEqualTo: uid)
                        .limit(1)
                        .get();

                    if (existingOfferQuery.docs.isNotEmpty) {
                      final existingOfferDoc = existingOfferQuery.docs.first;

                      // Update the existing offer with the new price and fees
                      await existingOfferDoc.reference.update({
                        'technicianOffer': offerPrice,
                        'technicianFees': fees,
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      // Update service fees (set the value instead of incrementing)
                      await updateServiceFees(uid, double.tryParse(fees) ?? 0);

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
                text: "Offer",
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateServiceFees(String technicianId, double feesAmount) async {
    try {
      await FirebaseFirestore.instance
          .collection('technician')
          .doc(technicianId)
          .update({
        'serviceFees':
            feesAmount, // Directly set the serviceFees to the provided value
      });
    } catch (e) {
      print("Error updating service fees: $e");
    }
  }
}
