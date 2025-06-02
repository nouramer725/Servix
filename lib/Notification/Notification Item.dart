import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';

class NotificationItem extends StatefulWidget {
  final String profileImageUrl;
  final String title;
  final String preview;
  final String time;
  final String date;

  final VoidCallback onDelete; // Delete function

  const NotificationItem({
    Key? key,
    required this.profileImageUrl,
    required this.title,
    required this.preview,
    required this.time,
    required this.date,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  String _formatTimeTo12Hour(String time24) {
    try {
      final parsedTime = DateFormat("HH:mm:ss").parse(time24);
      return DateFormat("h:mm:ss a").format(parsedTime);
    } catch (e) {
      return time24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            Stack(
              children: [
                CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        isDarkMode ? const Color(0xFF333739) : Colors.white,
                    child: Image.asset(
                      "assets/images/lang-member/langmem.png",
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    )),
              ],
            ),
            const SizedBox(width: 12),

            // Notification Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title (User Name)
                  Text(
                    widget.title.tr(),
                    style: GoogleFonts.castoro(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Preview Text
                  Text(
                    widget.preview.tr(),
                    style: GoogleFonts.castoro(
                      fontSize: 16,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.date.tr(),
                  style: GoogleFonts.castoro(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  _formatTimeTo12Hour(widget.time),
                  style: GoogleFonts.castoro(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                // Three-dot menu with Delete option
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  color: isDarkMode ? const Color(0xFF333739) : Colors.white,
                  onSelected: (value) async {
                    if (value == "delete") {
                      bool confirmDelete =
                          await showDeleteDialog(context, themeProvider);
                      if (confirmDelete) {
                        widget.onDelete(); // Call delete function
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "delete",
                      child: Row(
                        children: [
                          Icon(Icons.delete,
                              color:
                                  isDarkMode ? Colors.red : ApplicationColor),
                          const SizedBox(width: 8),
                          Text("Delete".tr(),
                              style: GoogleFonts.castoro(
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? Colors.red
                                      : ApplicationColor,
                                  fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const Divider(
          color: Color(0xFFD9D9D9),
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }

  // Function to show delete confirmation dialog
  Future<bool> showDeleteDialog(
      BuildContext context, ThemeProvider themeProvider) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: themeProvider.themeMode == ThemeMode.dark
                ? const Color(0xFF333739)
                : Colors.white,
            title: Text(
              "Delete Notification".tr(),
              style: GoogleFonts.castoro(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
            ),
            content: Text(
              "Are you sure you want to delete this notification?".tr(),
              style: GoogleFonts.castoro(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Cancel
                child: Text("Cancel".tr(),
                    style: GoogleFonts.castoro(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black)),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // Confirm Delete
                child: Text("Delete".tr(),
                    style: GoogleFonts.castoro(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: ApplicationColor)),
              ),
            ],
          ),
        ) ??
        false; // Default to false if dismissed
  }
}
