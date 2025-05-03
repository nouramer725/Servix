import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Theme/Theme_Provider.dart';
import 'DetailsScreen/Details_Pending.dart';
import 'model/model.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({required this.orders, super.key});

  final OrderModel orders;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailsPending(orders:orders)));
        },
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
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            orders.ProfileImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "${orders.Fname} ${orders.Lname}",
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsPending(orders: orders)));
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Color(0xFFAEAEAE),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Type of service :'.tr(),
                          style: GoogleFonts.castoro(
                              fontSize: 14,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            orders.ServiceType.tr(),
                            style: GoogleFonts.castoro(
                                fontSize: 14,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black),
                            maxLines: 5,
                          ),
                        ),
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
                        Expanded(
                          child: Text(
                            orders.Status.tr(),
                            style: GoogleFonts.castoro(
                              fontSize: 14,
                              color: orders.Status.toLowerCase() == 'pending'
                                  ? Colors.orangeAccent
                                  : (themeProvider.themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 16,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            orders.Date,
                            style: GoogleFonts.castoro(
                                fontSize: 14,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                        Icon(Icons.access_time,
                            size: 16,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            orders.Time,
                            style: GoogleFonts.castoro(
                                fontSize: 14,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
