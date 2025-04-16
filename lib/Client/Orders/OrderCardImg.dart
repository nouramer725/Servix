import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Theme/Theme_Provider.dart';
import '../technician View/Profile tech.dart';
import 'model/model.dart';

class OrderCardImg extends StatelessWidget {
  const OrderCardImg({required this.orders, super.key});
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
                    'Type of service :',
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
                    orders.ServiceType,
                    style: GoogleFonts.castoro(
                        fontSize: 14,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Description : ${orders.Description}',
                    style: GoogleFonts.castoro(
                        fontSize: 14,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Status : ${orders.Status}',
                    style: GoogleFonts.castoro(
                        fontSize: 14,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black),
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
                  const SizedBox(height: 20), // spacing for bottom image
                ],
              ),
              Positioned(
                bottom: 0,
                left: context.locale.languageCode == 'ar' ? 5 : null,
                right: context.locale.languageCode == 'en' ? 5 : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TechnicianProfileScreen(
                              technicianName: orders.technicianName,
                              technicianImage: orders.technicianImage,
                              technicianLocationArea: orders.technicianLocationArea,
                              technicianLocationStreet: orders.technicianLocationStreet,
                              technicianPhone: orders.technicianPhone,
                              technicianSub: orders.technicianSub,
                              technicianMain: orders.technicianMain,
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
