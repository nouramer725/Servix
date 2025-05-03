import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Technician/Orders/DetailsScreen/Details_Pending.dart';
import '../../Theme/Theme_Provider.dart';
import 'model/modelTech.dart';

class OrderCardTech extends StatelessWidget {
  const OrderCardTech({required this.orders, super.key});

  final OrderModelTech orders;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPendingTech(
                  orders: orders,
                ),
              ));
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailsPendingTech(orders: orders)));
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
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Status:'.tr(),
                        style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        orders.Status.tr(),
                        style: GoogleFonts.castoro(
                          fontSize: 14,
                          color: orders.Status.toLowerCase() == 'pending'
                              ? Colors.orangeAccent
                              : (isDark ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 18,
                            color: isDark ? Colors.white : Colors.black),
                        const SizedBox(width: 4),
                        Text(
                          orders.Date.tr(),
                          style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 18,
                            color: isDark ? Colors.white : Colors.black),
                        const SizedBox(width: 4),
                        Text(
                          orders.Time.tr(),
                          style: GoogleFonts.castoro(
                            fontSize: 14,
                            color: isDark ? Colors.white : Colors.black,
                          ),
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