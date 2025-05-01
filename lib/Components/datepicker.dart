import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Theme/Theme_Provider.dart';
import '../constents/constent.dart';

class DatePickerField extends StatefulWidget {
  final String hintText;
  final void Function(DateTime) onDateSelected;

  const DatePickerField({
    Key? key,
    required this.hintText,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  TextEditingController _controller = TextEditingController();

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      barrierDismissible: true,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ApplicationColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      _controller.text = DateFormat.yMMMMd().format(pickedDate);
      widget.onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: _selectDate,
      child: AbsorbPointer(
        child: TextFormField(
          controller: _controller,
          cursorColor: Colors.grey[100],
          style: GoogleFonts.castoro(
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black, // Set text color based on theme mode
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.castoro(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white54
                  : Colors.black54,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
