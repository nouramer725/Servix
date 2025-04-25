import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../Theme/Theme_Provider.dart';

class EditableRow extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback onEdit;
  final int maxLines;
  final IconData icon;

  const EditableRow({
    required this.text,
    required this.title,
    required this.onEdit,
    required this.icon,
    this.maxLines = 5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                title,
                style: GoogleFonts.castoro(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Color(0xFF676767)),
                overflow: TextOverflow.ellipsis,
                maxLines: maxLines,
              ),
              SizedBox(width: 5,),
              Text(
                text,
                style: GoogleFonts.castoro(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Color(0xFF676767)),
                overflow: TextOverflow.ellipsis,
                maxLines: maxLines,
              ),
            ],
          ),
        ),
        IconButton(
          icon: FaIcon(
            icon,
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Color(0xFF676767),
            size: 20,
          ),
          onPressed: onEdit,
        ),
      ],
    );
  }
}