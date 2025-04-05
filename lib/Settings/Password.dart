import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/constents/constent.dart';
import '../Components/Buttons.dart';
import '../Components/ShowResetPasswordDiaglog.dart';
import '../Components/_buildPasswordField.dart';
import '../Theme/Theme_Provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _logoutOtherDevices = false;

  final TextEditingController _currentPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _retypePasswordController =
  TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final retypePassword = _retypePasswordController.text.trim();

    if (newPassword != retypePassword) {
      Fluttertoast.showToast(
        msg: "New passwords do not match the retyped password.".tr(),
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (newPassword.length < 6) {
      Fluttertoast.showToast(
        msg: "Password must be at least 6 characters.".tr(),
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    final hasUppercase = newPassword.contains(RegExp(r'[A-Z]'));
    final hasNumber = newPassword.contains(RegExp(r'[0-9]'));
    final hasLowercase = newPassword.contains(RegExp(r'[a-z]'));
    final hasSpecialChar =
    newPassword.contains(RegExp(r'[!@#\$&*~%^()_+={}\[\]:;<>,.?\\|/-]'));

    if (!hasUppercase) {
      Fluttertoast.showToast(
        msg: "Password must include at least one uppercase letter.".tr(),
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    if (!hasLowercase) {
      Fluttertoast.showToast(
        msg: "Password must include at least one lowercase letter.".tr(),
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    if (!hasNumber) {
      Fluttertoast.showToast(
        msg: "Password must include at least one number.".tr(),
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    if (!hasSpecialChar) {
      Fluttertoast.showToast(
        msg:
        "Password must include at least one special character".tr(),
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(newPassword);

        if (_logoutOtherDevices) {
          await FirebaseAuth.instance.signOut();
          Fluttertoast.showToast(
            msg: "Password changed. Please log in again.".tr(),
            backgroundColor: ApplicationColorWithOpacity,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
          );
          Navigator.pop(context);

        } else {
          Fluttertoast.showToast(
            msg: "Password changed successfully.".tr(),
            backgroundColor: ApplicationColorWithOpacity,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
          );
          Navigator.pop(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: "Current password is not correct.".tr(),
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
      } else {
        print("Error: ${e.message}");
        Fluttertoast.showToast(
          msg: "Current password is incorrect.".tr(),
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
      }
    } catch (e) {
      print("Unexpected error: ${e.toString()}");
      Fluttertoast.showToast(
        msg: "Unexpected error: ${e.toString()}",
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        elevation: 0,
        title: Text(
          "Change Password".tr(),
          style: GoogleFonts.castoro(
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Your password must be at least 6 characters and should include a combination of numbers, letters and special characters like:".tr(),
                    style: GoogleFonts.castoro(
                      fontSize: 14,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "(! @ # \$ % ^ & *).",
              style: GoogleFonts.castoro(
                fontSize: 14,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 80),
            PasswordTextField(
              label: "Current Password".tr(),
              controller: _currentPasswordController,
            ),
            const SizedBox(height: 25),
            PasswordTextField(
              label: "New Password".tr(),
              controller: _newPasswordController,
            ),
            const SizedBox(height: 25),
            PasswordTextField(
              label: "Retype New Password".tr(),
              controller: _retypePasswordController,
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ResetPasswordDialog(),
                );
              },
              child: Text(
                "Forgotten your password?".tr(),
                style: GoogleFonts.castoro(
                  decoration: TextDecoration.underline,
                  decorationColor: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : ApplicationColor,
                  decorationThickness: 2,
                  decorationStyle: TextDecorationStyle.solid,
                  fontSize: 18,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : ApplicationColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _logoutOtherDevices,
                  activeColor: ApplicationColor,
                  onChanged: (value) {
                    setState(() {
                      _logoutOtherDevices = value!;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    "Log out of other devices. Choose this if someone else used your account.".tr(),
                    style: GoogleFonts.castoro(
                      fontSize: 14,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GradientButton(
          text: "Change Password".tr(),
          onPressed: _changePassword,
        ),
      ),
    );
  }
}