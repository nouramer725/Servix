import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Client/Orders/DetailsScreen/Details_Pending.dart';
import '../../Theme/Theme_Provider.dart';
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
                  builder: (context) =>
                      DetailsPending(orders: orders)));
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
                            orders.ServiceType,
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                // Positioned(
                //     top: 10,
                //     right: context.locale.languageCode == 'en' ? 5 : null,
                //     left: context.locale.languageCode == 'ar' ? 5 : null,
                //     child: GestureDetector(
                //       onTap: () {
                //         // CancelOrder(context, orders);
                //       },
                //       child: Icon(
                //         Icons.arrow_forward_ios,
                //         size: 20,
                //         color: Colors.grey,
                //       ),
                //     ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> CancelOrder(BuildContext context, OrderModel order) async {
  //   var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  //
  //   bool? confirmCancellation = await showDialog<bool>(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: themeProvider.themeMode == ThemeMode.dark
  //             ? const Color(0xFF333739)
  //             : Colors.white,
  //         title: Text(
  //           "Confirm Cancellation".tr(),
  //           style: GoogleFonts.castoro(
  //             fontSize: 28,
  //             fontWeight: FontWeight.bold,
  //             color: themeProvider.themeMode == ThemeMode.dark
  //                 ? Colors.white
  //                 : Colors.black,
  //           ),
  //         ),
  //         content: Text("Are you sure you want to cancel this order?".tr(),
  //             style: GoogleFonts.castoro(
  //               fontSize: 18,
  //               fontWeight: FontWeight.w500,
  //               color: themeProvider.themeMode == ThemeMode.dark
  //                   ? Colors.white
  //                   : Colors.black,
  //             )),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(false); // User cancels the action
  //             },
  //             child: Text("No".tr(),
  //                 style: GoogleFonts.castoro(
  //                   color: themeProvider.themeMode == ThemeMode.dark
  //                       ? Colors.white
  //                       : Colors.black,
  //                   fontSize: 25,
  //                 )),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(true);
  //             },
  //             child: Text("Yes".tr(),
  //                 style: GoogleFonts.castoro(
  //                     fontSize: 25,
  //                     color: themeProvider.themeMode == ThemeMode.dark
  //                         ? Colors.white
  //                         : ApplicationColor)),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //
  //   // If the user confirmed the cancellation, proceed with the order update
  //   if (confirmCancellation == true) {
  //     try {
  //       final user = FirebaseAuth.instance.currentUser;
  //       final uid = user!.uid;
  //
  //       await FirebaseFirestore.instance
  //           .collection('Services Requests')
  //           .doc(uid)
  //           .collection('user-services')
  //           .doc(order.orderId)
  //           .update({'Status': 'Cancelled'});
  //
  //       Fluttertoast.showToast(
  //         msg: "Order cancelled!".tr(),
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.TOP,
  //         backgroundColor: ApplicationColorWithOpacity,
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //     } catch (e) {
  //       Fluttertoast.showToast(
  //         msg: "Failed to cancel order".tr(),
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.TOP,
  //         backgroundColor: ApplicationColorWithOpacity,
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //     }
  //   } else {
  //     // If the user cancels, show a cancellation message or handle the action accordingly
  //     Fluttertoast.showToast(
  //       msg: "Order cancellation was not confirmed".tr(),
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.TOP,
  //       backgroundColor: ApplicationColorWithOpacity,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //   }
  // }
}
