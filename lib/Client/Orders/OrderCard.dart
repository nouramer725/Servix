import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Components/OfferButtonInOrderCard.dart';
import '../../Theme/Theme_Provider.dart';
import '../Offers/The Nearest.dart';
import 'model/model.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({required this.orders, super.key});

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
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type of service :',
                    style: GoogleFonts.castoro(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      decorationThickness: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Service Type:',
                        style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        orders.ServiceType,
                        style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                    ],
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
                ],
              ),
              Positioned(
                bottom: 15,
                left: context.locale.languageCode == 'ar' ? 5 : null,
                right: context.locale.languageCode == 'en' ? 5 : null,
                child: OfferButtonInOrderCard(
                  onPressed: () {
                    print('Navigating with orderId: ${orders.orderId}');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TheNearestScreen(
                            orderId: orders.orderId,
                          ),
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
