import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../Components/Buttons.dart';
import '../../../Technician/Orders/model/VideoPlayerWidget.dart';
import '../../../Theme/Theme_Provider.dart';
import '../../../constents/constent.dart';
import '../../Offers/The Nearest.dart';
import '../model/model.dart';
import 'dart:ui';

class DetailsPending extends StatefulWidget {
  final OrderModel orders;

  const DetailsPending({super.key, required this.orders});

  @override
  State<DetailsPending> createState() => _DetailsPendingState();
}

class _DetailsPendingState extends State<DetailsPending> {
  double _blurValue = 0;

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
                : CarouselSlider.builder(
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
                      autoPlay: true,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      aspectRatio: 25 / 9,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                    ),
                  ),
          ),

          // Blur layer
          if (_blurValue > 0)
            // Foreground scrollable content with blur
            Positioned.fill(
                child: SingleChildScrollView(
                    child: Column(children: [
              // Add a blur effect over the image
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.2), // adjust if needed
                  height: 450, // height of the blurred section (same as image)
                ),
              ),
            ]))),

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
                          "Service Type:",
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
                            orders.ServiceType,
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
                          "Status:",
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
                            orders.Status,
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
                                "Time:",
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
                                "Date:",
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
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: GradientButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TheNearestScreen(
                                            orderId: orders.orderId,
                                          )));
                            },
                            text: "Offers",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: WhiteButtonOffer(
                            font: 27,
                            onPressed: () async {
                              await CancelOrder(context, orders);
                            },
                            text: "Cancel",
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> CancelOrder(BuildContext context, OrderModel order) async {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    bool? confirmCancellation = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeProvider.themeMode == ThemeMode.dark
              ? const Color(0xFF333739)
              : Colors.white,
          title: Text(
            "Confirm Cancellation".tr(),
            style: GoogleFonts.castoro(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          content: Text("Are you sure you want to cancel this order?".tr(),
              style: GoogleFonts.castoro(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              )),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancels the action
              },
              child: Text("No".tr(),
                  style: GoogleFonts.castoro(
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 25,
                  )),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Yes".tr(),
                  style: GoogleFonts.castoro(
                      fontSize: 25,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : ApplicationColor)),
            ),
          ],
        );
      },
    );

    // If the user confirmed the cancellation, proceed with the order update
    if (confirmCancellation == true) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        final uid = user!.uid;

        await FirebaseFirestore.instance
            .collection('Services Requests')
            .doc(uid)
            .collection('user-services')
            .doc(order.orderId)
            .update({'Status': 'Cancelled'});

        Navigator.pop(context);

        Fluttertoast.showToast(
          msg: "Order cancelled!".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Failed to cancel order".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      // If the user cancels, show a cancellation message or handle the action accordingly
      Fluttertoast.showToast(
        msg: "Order cancellation was not confirmed".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
