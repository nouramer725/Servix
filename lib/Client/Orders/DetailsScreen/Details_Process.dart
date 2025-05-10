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
import '../../technician View/Profile tech.dart';
import '../model/model.dart';
import 'dart:ui';

class DetailsProcess extends StatefulWidget {
  final OrderModel orders;

  const DetailsProcess({super.key, required this.orders});

  @override
  State<DetailsProcess> createState() => _DetailsProcessState();
}

class _DetailsProcessState extends State<DetailsProcess> {
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
                    Text(
                      "${'Service Type:'.tr()} ${orders.ServiceType.tr()}",
                      style: GoogleFonts.castoro(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
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
                    Text(
                      "${'Status :'.tr()} ${orders.Status.tr()}",
                      style: GoogleFonts.castoro(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                            '${'Price:'.tr()} ${orders.technicianOffer} ${'EGP'.tr()}',
                            style: GoogleFonts.castoro(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black)),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TechnicianProfileScreen(
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
                                    color: themeProvider.themeMode ==
                                            ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                maxLines: 5,
                              ),
                            ),
                          ],
                        )
                      ],
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
}
