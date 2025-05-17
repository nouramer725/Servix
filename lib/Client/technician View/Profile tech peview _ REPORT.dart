import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Components/Buttons.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';

class ReportScreen extends StatefulWidget {
  final String technicianId;
  final String technicianName;
  const ReportScreen({
    super.key,
    required this.technicianId,
    required this.technicianName,
  });

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? selectedReason;
  final TextEditingController _controller = TextEditingController();

  final List<String> reasons = [
    'Nudity or sexual activity'.tr(),
    'Bullying or harassment'.tr(),
    'Suicide, self-injury or eating disorders'.tr(),
    'Violence, hate or exploitation'.tr(),
    'Selling or promoting restricted items'.tr(),
    'Scam, fraud or impersonation'.tr(),
    "I just don't like it".tr(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final clientId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Text(
          'Reporting Technician'.tr(),
          style: GoogleFonts.castoro(
            fontSize: 20,
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why are you reporting'.tr(),
                  style: GoogleFonts.charisSil(
                    fontSize: 24,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'If someone is in immediate danger, get help before reporting to Facebook. Don’t wait.'
                      .tr(),
                  style: GoogleFonts.castoro(
                    fontSize: 15,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white60
                        : const Color(0XFF9D9D9D),
                  ),
                ),
                const SizedBox(height: 20),
                ...reasons.map((reason) => RadioListTile<String>(
                      activeColor: ApplicationColor,
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        reason,
                        style: GoogleFonts.charisSil(
                          fontSize: 18,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      value: reason,
                      groupValue: selectedReason,
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value;
                        });
                      },
                    )),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.grey[600]
                        : Colors.grey[200],
                  ),
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.text,
                    cursorColor: const Color(0xffA7A7A7),
                    maxLines: 5,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Any additional information'.tr(),
                      hintStyle: GoogleFonts.cantataOne(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : const Color(0xffA7A7A7)),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.cantataOne(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GradientButton(
          text: 'Send Report'.tr(),
          onPressed: () async {
            if (selectedReason == null) {
              Fluttertoast.showToast(
                msg: "Please select a reason".tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                backgroundColor: ApplicationColorWithOpacity,
                textColor: Colors.white,
              );
              return;
            }

            try {
              await FirebaseFirestore.instance
                  .collection('reports')
                  .doc(widget.technicianId)
                  .set({
                'technicianId': widget.technicianId,
                'technicianName': widget.technicianName,
                'clientId': clientId,
                'reason': selectedReason,
                'additionalInfo': _controller.text.trim(),
                'timestamp': FieldValue.serverTimestamp(),
              });

              // Ask user if they want to block
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: themeProvider.themeMode == ThemeMode.dark
                        ? const Color(0xFF333739)
                        : Colors.white,
                    title: Text(
                      '${'Block'.tr()} ${widget.technicianName}'.tr(),
                      style: GoogleFonts.castoro(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    content: Text(
                      '${widget.technicianName} ${'will no longer be able to see your posts or start a conversation with you'.tr()}'
                          .tr(),
                      style: GoogleFonts.castoro(
                          fontSize: 18,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black),
                      maxLines: 5,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                            msg: "Your report has been submitted.".tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            backgroundColor: ApplicationColorWithOpacity,
                            textColor: Colors.white,
                          );
                        },
                        child: Text("No".tr(),
                            style: GoogleFonts.castoro(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black)),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Fetch client name from the 'clients' collection
                          final clientSnapshot = await FirebaseFirestore
                              .instance
                              .collection('users')
                              .doc(clientId)
                              .get();

                          final clientName =
                              clientSnapshot.data()?['first_name'] ?? 'Unknown';
                          final clientLastName =
                              clientSnapshot.data()?['last_name'] ?? 'Unknown';

                          // Add to blocked_technicians collection
                          await FirebaseFirestore.instance
                              .collection('blocked_technicians')
                              .doc(widget.technicianId)
                              .set({
                            'technicianId': widget.technicianId,
                            'technicianName': widget.technicianName,
                            'reason': selectedReason,
                            'additionalInfo': _controller.text.trim(),
                            'clientId': clientId,
                            'clientName': clientName,
                            'clientLastName': clientLastName,
                            'timestamp': FieldValue.serverTimestamp(),
                          });

                          // Add to technician's blocked_clients
                          await FirebaseFirestore.instance
                              .collection('technician')
                              .doc(widget.technicianId)
                              .collection('blocked_clients')
                              .doc(clientId)
                              .set({
                            'clientId': clientId,
                            'clientName': clientName,
                            'clientLastName': clientLastName,
                            'reason': selectedReason,
                            'additionalInfo': _controller.text.trim(),
                            'timestamp': FieldValue.serverTimestamp(),
                          });

                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);

                          Fluttertoast.showToast(
                            msg: "Technician has been reported and blocked."
                                .tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            backgroundColor: ApplicationColorWithOpacity,
                            textColor: Colors.white,
                          );
                        },
                        child: Text("Yes".tr(),
                            style: GoogleFonts.castoro(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: ApplicationColor)),
                      ),
                    ],
                  );
                },
              );
            } catch (e) {
              Fluttertoast.showToast(
                msg: "Failed to submit report".tr(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
          },
        ),
      ),
    );
  }
}
