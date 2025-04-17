import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';
import 'Profile tech peview _ REPORT.dart';

class TechnicianProfileScreen extends StatefulWidget {
  final String technicianName;
  final String technicianId;
  final String technicianImage;
  final String technicianLocationArea;
  final String technicianLocationStreet;
  final String technicianPhone;
  final String technicianSub;
  final String technicianMain;
  final String technicianDescription;
  // final double technicianRating;
  final List<String> technicianProducts;
  final String technicianLinkSocialMedia;

  const TechnicianProfileScreen({
    required this.technicianName,
    required this.technicianId,
    required this.technicianImage,
    required this.technicianLocationArea,
    required this.technicianLocationStreet,
    required this.technicianPhone,
    required this.technicianSub,
    required this.technicianMain,
    required this.technicianDescription,
    // required this.technicianRating,
    required this.technicianProducts,
    required this.technicianLinkSocialMedia,
    super.key,
  });

  @override
  State<TechnicianProfileScreen> createState() =>
      _TechnicianProfileScreenState();
}

class _TechnicianProfileScreenState extends State<TechnicianProfileScreen> {
  int selectedIndex = 0;
  bool isBlocked = false;

  Future<void> checkIfTechnicianIsBlocked() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('blocked_technicians')
        .where('technicianId',
            isEqualTo: widget.technicianId) // Pass the technicianId here
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        isBlocked = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfTechnicianIsBlocked();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (isBlocked) {
      return Scaffold(
        appBar: AppBar(
            title: Text(
          "Technician Profile",
          style: GoogleFonts.castoro(
            fontSize: 20,
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        )),
        body: Center(
          child: Text(
            "This User is blocked",
            style: GoogleFonts.castoro(
              fontSize: 20,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? Color(0xFF333739)
            : Colors.white,
        title: Text("Profile Technician",
            style: GoogleFonts.castoro(
              fontSize: 20,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            )),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : const Color(0xFF333739)),
            color: themeProvider.themeMode == ThemeMode.dark
                ? const Color(0xFF333739)
                : Colors.white,
            onSelected: (value) async {
              if (value == "Report") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportScreen(
                        technicianId: widget.technicianId,
                        technicianName: widget.technicianName,
                      ),
                    ));
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "Report",
                child: Text("Report".tr(),
                    style: GoogleFonts.castoro(
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18)),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.network(
                    widget.technicianImage,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.technicianName,
                  style: GoogleFonts.calistoga(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                Text(
                  'Main Service: ${widget.technicianMain}',
                  style: GoogleFonts.castoro(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : const Color(0xFF626262),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Sub Service: ${widget.technicianSub}',
                  style: GoogleFonts.castoro(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : const Color(0xFF626262),
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.14,
                  margin: const EdgeInsets.all(17),
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.grey[600]
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      widget.technicianDescription,
                      style: TextStyle(
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 20,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final url = widget.technicianLinkSocialMedia;
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Could not open social media link")),
                          );
                        }
                      },
                      child: Icon(
                        Icons.facebook,
                        color: Colors.blue[700],
                        size: 40,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Technician Location",
                                    style: GoogleFonts.castoro(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(height: 10),
                                Text(
                                  "Area: ${widget.technicianLocationArea}",
                                  style: GoogleFonts.castoro(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                    "Street: ${widget.technicianLocationStreet}",
                                    style: GoogleFonts.castoro(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.location_on_outlined,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        size: 40,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final Uri phoneUri =
                            Uri(scheme: 'tel', path: widget.technicianPhone);
                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Could not launch phone dialer")),
                          );
                        }
                      },
                      child: Icon(
                        Icons.phone,
                        color: ApplicationColor,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Divider(
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.grey[500],
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                          child: Text(
                            'Products',
                            style: GoogleFonts.castoro(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: selectedIndex == 0
                                  ? themeProvider.themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black
                                  : Colors.grey[600],
                              decoration: selectedIndex == 0
                                  ? TextDecoration.underline
                                  : null,
                              decorationColor:
                                  themeProvider.themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                              textBaseline: TextBaseline.alphabetic,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                          child: Text(
                            'Reviews',
                            style: GoogleFonts.castoro(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: selectedIndex == 1
                                  ? themeProvider.themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black
                                  : Colors.grey[600],
                              decoration: selectedIndex == 1
                                  ? TextDecoration.underline
                                  : null,
                              decorationColor:
                                  themeProvider.themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (selectedIndex == 0) ...[
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.technicianProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 / 2,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          image: DecorationImage(
                            image:
                                NetworkImage(widget.technicianProducts[index]),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ],
                // if (selectedIndex == 1) ...[
                //   const SizedBox(height: 10),
                //   GridView.builder(
                //     shrinkWrap: true,
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemCount: widget.technicianProducts.length,
                //     gridDelegate:
                //     const SliverGridDelegateWithMaxCrossAxisExtent(
                //       maxCrossAxisExtent: 300,
                //       crossAxisSpacing: 10,
                //       mainAxisSpacing: 10,
                //       childAspectRatio: 3 / 2,
                //     ),
                //     itemBuilder: (context, index) {
                //       return Container(
                //         decoration: BoxDecoration(
                //           color: Colors.grey[200],
                //           image: DecorationImage(
                //             image:
                //             NetworkImage(widget.technicianProducts[index]),
                //             fit: BoxFit.fill,
                //           ),
                //           borderRadius: BorderRadius.circular(15),
                //           border: Border.all(color: Colors.grey),
                //         ),
                //       );
                //     },
                //   ),
                // ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
