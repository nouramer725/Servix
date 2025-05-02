import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/constents/constent.dart';
import '../../Theme/Theme_Provider.dart';
import 'model/VideoPlayerWidget.dart';
import 'model/modelTech.dart';

class DetailsPreviousScreen extends StatefulWidget {
  final OrderModelTech orders;

  const DetailsPreviousScreen({super.key, required this.orders});

  @override
  State<DetailsPreviousScreen> createState() => _DetailsPreviousScreenState();
}

class _DetailsPreviousScreenState extends State<DetailsPreviousScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Text('Service Details',
            style: GoogleFonts.castoro(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
            child: Text(
              widget.orders.Status,
              style: GoogleFonts.castoro(
                fontSize: 20,
                color: widget.orders.Status == "Finished"
                    ? Colors.green
                    : widget.orders.Status == "Cancelled"
                        ? Colors.red
                        : (themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              widget.orders.image ??
                                  'https://static.vecteezy.com/system/resources/previews/036/280/651/large_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "${widget.orders.FName} ${widget.orders.LName}",
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
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Service Type:",
                            style: GoogleFonts.castoro(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.orders.ServiceType,
                            style: GoogleFonts.castoro(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Description:",
                            style: GoogleFonts.castoro(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              widget.orders.Description,
                              style: GoogleFonts.castoro(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Date:",
                            style: GoogleFonts.castoro(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black38,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.orders.Date,
                            style: GoogleFonts.castoro(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black38,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Time:",
                            style: GoogleFonts.castoro(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black38,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.orders.Time,
                            style: GoogleFonts.castoro(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black38,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Area:",
                            style: GoogleFonts.castoro(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black38,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "${widget.orders.Location} , ${widget.orders.street}",
                              style: GoogleFonts.castoro(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black38,
                              ),
                              maxLines: 5,
                            ),
                          ),
                        ],
                      ),
                      if (widget.orders.fileUrls.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.orders.fileUrls.length,
                            itemBuilder: (context, index) {
                              final url = widget.orders.fileUrls[index];
                              final isVideo =
                                  url.toLowerCase().endsWith('.mp4');

                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: isVideo
                                    ? AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: VideoPlayerWidget(url: url),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          url,
                                          width: 150,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black12,
                thickness: 2,
                indent: 10,
                endIndent: 10,
              ),
              Text(
                "Offer Price:",
                style: GoogleFonts.castoro(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Price:",
                              style: GoogleFonts.castoro(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                              )),
                          const SizedBox(width: 80),
                          Text("${widget.orders.previousOffer}",
                              style: GoogleFonts.castoro(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? ApplicationColor6
                                    : ApplicationColor,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
