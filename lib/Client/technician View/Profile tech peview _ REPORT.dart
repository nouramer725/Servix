import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Components/Buttons.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? selectedReason;
  final TextEditingController _controller = TextEditingController();

  final List<String> reasons = [
    'Nudity or sexual activity',
    'Bullying or harassment',
    'Suicide, self-injury or eating disorders',
    'Violence, hate or exploitation',
    'Selling or promoting restricted items',
    'Scam, fraud or impersonation',
    "I just don't like it",
  ];

  @override
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Color(0xFF333739)
          : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Why are you reporting Nour ?',
                style: GoogleFonts.castoro(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),),
              SizedBox(height: 8),
              Text(
                'If someone is in immediate danger, get help before reporting to Facebook. Don’t wait.',
                style: GoogleFonts.castoro(
                  fontSize: 15,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              SizedBox(height: 8),
              ...reasons.map((reason) => RadioListTile<String>(
                activeColor: ApplicationColor,
                title: Text(reason,
                  style: GoogleFonts.castoro(
                    fontSize: 16,
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
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffEEEEEE),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: 4,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Any additional information',
                  ),
                  style: TextStyle(color: Color(0xffA7A7A7)),
                ),
              ),
              SizedBox(height: 14),
              GradientButton(
                text: 'Done',
                onPressed: () {
                  Fluttertoast.showToast(
                    msg: "Your report is done",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    backgroundColor: ApplicationColor,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
