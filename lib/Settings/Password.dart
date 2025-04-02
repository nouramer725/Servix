import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Components/Buttons.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _logoutOtherDevices = false; // Checkbox state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Change Password",
            style: GoogleFonts.castoro(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instruction Text
                Text(
                  "Your password must be at least 6 characters and should include a combination of numbers, letters and special characters (!\$@%).",
                  style: GoogleFonts.castoro(fontSize: 14, color: Colors.black),
                ),
                SizedBox(height: 80),
                _buildPasswordField("Current Password"),
                SizedBox(height: 25),
                _buildPasswordField("New Password"),
                SizedBox(height: 25),
                _buildPasswordField("Retype new password"),
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      // Handle "Forgot Password" action
                    },
                    child: Text(
                      "Forgotten your password?",
                      style: GoogleFonts.castoro(
                        color: Color(0xff821717),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _logoutOtherDevices,
                      activeColor: Color(0xff821717), // Checkbox color
                      onChanged: (value) {
                        setState(() {
                          _logoutOtherDevices = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Log out of other devices. Choose this if someone else used your account.",
                        style: GoogleFonts.castoro(
                            fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GradientButton(text: "Change Password", onPressed: () {}),
        ));
  }

  Widget _buildPasswordField(String label) {
    return TextField(
      obscureText: true, // Hide password input
      style: GoogleFonts.castoro(
        color: Color(0xffAEAEAE), // Set text color here
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.castoro(
          color: Color(0xffAEAEAE), // Set label text color here (optional)
        ),
        filled: false,
        fillColor: Colors.grey[100], // Light gray background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xffAEAEAE)), // Border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xffAEAEAE),
          ), // Border color when enabled
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xffAEAEAE),
          ), // Border color when focused
        ),
      ),
    );
  }
}
