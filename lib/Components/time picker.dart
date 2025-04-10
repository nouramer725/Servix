import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Theme/Theme_Provider.dart';
import '../constents/constent.dart';

class TimePickerField extends StatefulWidget {
  final String hintText;
  final void Function(TimeOfDay) onTimeSelected;

  const TimePickerField({
    Key? key,
    required this.hintText,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  _TimePickerFieldState createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  TextEditingController _controller = TextEditingController();

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ApplicationColor,
              secondary: ApplicationColor,
              onSecondary: Colors.white,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
      initialEntryMode: TimePickerEntryMode.input, // Allow input mode
    );
    if (pickedTime != null) {
      _controller.text = pickedTime.format(context);
      widget.onTimeSelected(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: _selectTime,
      child: AbsorbPointer(
        child: TextFormField(
          controller: _controller,
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
