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
import '../../../Notification/notification_nodejs.dart';
import '../../../Notification/notification_send_to_tech.dart';
import '../../../Technician/Orders/model/VideoPlayerWidget.dart';
import '../../../Theme/Theme_Provider.dart';
import '../../../constents/constent.dart';

class DetailsProcessTech extends StatefulWidget {
  final OrderModelTech orders;

  const DetailsProcessTech({super.key, required this.orders});

  @override
  State<DetailsProcessTech> createState() => _DetailsProcessTechState();
}

class _DetailsProcessTechState extends State<DetailsProcessTech> {
  double _blurValue = 0;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final orders = widget.orders;
    // number of url files in carousel
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
                                orders.Time.tr(),
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
                                orders.Date.tr(),
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
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("Price:".tr(),
                            style: GoogleFonts.castoro(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            )),
                        const SizedBox(width: 8),
                        Text("${orders.previousOffer}",
                            style: GoogleFonts.castoro(
                              fontSize: 20,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            )),
                        const SizedBox(width: 8),
                        Text("EGP".tr(),
                            style: GoogleFonts.castoro(
                              fontSize: 20,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            )),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: WhiteButtonOffer(
                            text: "Cancel".tr(),
                            onPressed: () async {
                              await CancelOrder(context, orders);
                            },
                            font: 18,
                          ),
                        ),
                        Expanded(
                          child: GradientButtonOffer(
                            text: "Complete".tr(),
                            onPressed: () async {
                              await _completeOrder(context, orders);
                            },
                            font: 18,
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

  Future<void> incrementServiceCount(
      String technicianId, String docPath) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.doc(docPath).get();

      if (docSnapshot.exists && docSnapshot.data()?['Status'] == 'Finished') {
        await FirebaseFirestore.instance
            .collection('technician')
            .doc(technicianId)
            .update({
          'serviceCount': FieldValue.increment(1),
        });
      }
    } catch (e) {
      print("Error incrementing service count: $e");
    }
  }

  Future<void> _completeOrder(
      BuildContext context, OrderModelTech order) async {
    try {
      final docRef = FirebaseFirestore.instance.doc(order.docPath!);
      await docRef.update({'Status': 'Finished'});

      await incrementServiceCount(
          FirebaseAuth.instance.currentUser!.uid, order.docPath!);

      String user = FirebaseAuth.instance.currentUser!.uid;

      final fcmTechToken = await getTechnicianFcmToken(user);

      // Notify technician: Order completed and fees
      if (fcmTechToken != null && fcmTechToken.isNotEmpty) {
        final notificationService = NotificationServices();

        await notificationService.sendNotifications(
          fcmToken: fcmTechToken,
          title: "Order Completed",
          body:
              "You have completed the order for ${order.FName} ${order.LName}. You earned ${order.previousOffer} EGP for this service.",
          userId: user,
        );
      }
      // Fetch client FCM token
      final fcmToken = await getClientFcmToken(order.userId!);

      if (fcmToken != null && fcmToken.isNotEmpty) {
        final notificationService = NotificationServices();
        // Notify client: Order completed
        await notificationService.sendNotifications(
          fcmToken: fcmToken,
          title: "Order Completed",
          body:
              "Your order has been completed by ${order.FName} ${order.LName}. You paid ${order.previousOffer} EGP.",
          userId: order.userId!,
        );

        // Notify client: Please rate the technician
        await notificationService.sendNotifications(
          fcmToken: fcmToken,
          title: "Rate Technician",
          body:
              "Please rate the service of technician ${order.FName} ${order.LName}.",
          userId: order.userId!,
        );
      }

      Fluttertoast.showToast(
        msg: "Order completed successfully!".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to complete order'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> CancelOrder(BuildContext context, OrderModelTech order) async {
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
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("No".tr(),
                  style: GoogleFonts.castoro(
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 25,
                  )),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
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

    if (confirmCancellation == true) {
      try {
        final docRef = FirebaseFirestore.instance.doc(order.docPath!);
        await docRef.update({'Status': 'Cancelled'});

        String user = FirebaseAuth.instance.currentUser!.uid;

        final fcmTechToken = await getTechnicianFcmToken(user);

        // Notify technician: Order completed and fees
        if (fcmTechToken != null && fcmTechToken.isNotEmpty) {
          final notificationService = NotificationServices();

          await notificationService.sendNotifications(
            fcmToken: fcmTechToken,
            title: "Order Cancelled",
            body:
                "You have cancelled the order for ${order.FName} ${order.LName}. You lost ${order.previousOffer} EGP for this service.!!",
            userId: user,
          );
        }

        final fcmToken = await getClientFcmToken(order.userId!);

        if (fcmToken != null && fcmToken.isNotEmpty) {
          final notificationService = NotificationServices();

          await notificationService.sendNotifications(
            fcmToken: fcmToken,
            title: "Order Cancelled",
            body:
                "Your order was cancelled by ${order.FName} ${order.LName}. We apologize for the inconvenience.",
            userId: order.userId!,
          );
        }

        Fluttertoast.showToast(
          msg: "Order Cancelled!".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
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
