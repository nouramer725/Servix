import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart'; // Import FilePicker
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:servix/Components/Buttons.dart';
import 'package:servix/constents/constent.dart';
import '../../../Components/datepicker.dart';
import '../../../Components/time picker.dart';
import '../../../Components/upload photo or video in description screens.dart';
import '../../../Theme/Theme_Provider.dart';

class DescriptionnScreen extends StatefulWidget {
  final String title;
  final String imagePath;

  const DescriptionnScreen({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<DescriptionnScreen> createState() => _DescriptionnScreenState();
}

class _DescriptionnScreenState extends State<DescriptionnScreen> {
  List<String> filepath = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? descriptionError;
  String? dateError;
  String? timeError;
  String? fileError;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeProvider.themeMode == ThemeMode.dark
              ? const Color(0xFF333739)
              : Colors.white,
          title: Text(
            widget.title.tr(),
            style: GoogleFonts.castoro(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      margin: const EdgeInsets.only(right: 8),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('The Description'.tr(),
                          style: GoogleFonts.castoro(
                            fontSize: 25,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTextField(
                    "Please write your service description here".tr(),
                    controller: _descriptionController,
                    themeProvider: themeProvider,
                    errorText: descriptionError,
                    maxLines: 4),
                const SizedBox(height: 20),
                DatePickerField(
                  hintText: "Choose Your Preferred Date".tr(),
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                if (dateError != null)
                  Text(
                    dateError!,
                    style: GoogleFonts.castoro(color: Colors.red, fontSize: 12),
                  ),
                const SizedBox(height: 20),
                TimePickerField(
                  hintText: "Choose Your Preferred Time".tr(),
                  onTimeSelected: (time) {
                    setState(() {
                      selectedTime = time;
                    });
                  },
                ),
                if (timeError != null)
                  Text(
                    timeError!,
                    style: GoogleFonts.castoro(color: Colors.red, fontSize: 12),
                  ),
                const SizedBox(height: 20),
                Row(children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.only(right: 8),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Upload Photo or Video'.tr(),
                        style: GoogleFonts.castoro(
                          fontSize: 25,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                        )),
                  ),
                ]),
                Text(
                  '         -> Maximum 10 files'.tr(),
                  style: GoogleFonts.castoro(
                    fontSize: 15,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                Text(
                  '         -> Long Tap on the uploaded file to preview'.tr(),
                  style: GoogleFonts.castoro(
                    fontSize: 15,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                if (fileError != null)
                  Text(
                    fileError!,
                    style: GoogleFonts.castoro(color: Colors.red, fontSize: 12),
                  ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < filepath.length && i < 10; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilePickerWidget(
                            filePath: filepath[i],
                            onFilePicked: (pickedFilePath) {
                              setState(() {
                                filepath[i] = pickedFilePath!;
                              });
                              print('File picked: $pickedFilePath');
                            },
                          ),
                        ),
                      if (filepath.length < 10)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: [
                                  'jpg',
                                  'jpeg',
                                  'png',
                                  'mp4',
                                  'mov',
                                  'avi'
                                ],
                              );
                              if (result != null) {
                                setState(() {
                                  filepath.add(result.files.single.path!);
                                });
                              }
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 28,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white54
                                    : Colors.black54,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (fileError != null)
                  Text(
                    fileError!,
                    style: GoogleFonts.castoro(color: Colors.red, fontSize: 12),
                  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GradientButton(
            onPressed: () {
              print("Button Pressed");
              if (_validateForm()) {
                print("Form is valid");
                _saveServiceData(context, _descriptionController.text,
                    widget.title, widget.imagePath);
              } else {
                print("Form is invalid");
              }
            },
            text: "Select your Location".tr(),
          ),
        ));
  }

  bool _validateForm() {
    setState(() {
      descriptionError = null;
      dateError = null;
      timeError = null;
      fileError = null;
    });

    if (_descriptionController.text.isEmpty) {
      setState(() {
        descriptionError = "Description is required.".tr();
      });
      print("Description is empty");
      return false;
    }

    if (selectedDate == null) {
      setState(() {
        dateError = "Please select a date.".tr();
      });
      print("Date is not selected");
      return false;
    }

    if (selectedTime == null) {
      setState(() {
        timeError = "Please select a time.".tr();
      });
      print("Time is not selected");
      return false;
    }

    if (filepath.isEmpty) {
      setState(() {
        fileError = "Please upload at least one photo or video.".tr();
      });
      print("No file uploaded");
      return false;
    }

    print("Form is valid");
    return true;
  }

  Future<void> _saveServiceData(
    BuildContext context,
    String description,
    String serviceTitle,
    String imagePath,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userId = user.uid;
    List<String> fileUrls = [];

    for (var filePath in filepath) {
      File file = File(filePath);
      String? fileUrl = await uploadToCloudinary(file);
      if (fileUrl != null) {
        fileUrls.add(fileUrl);
      }
    }

    // Point to the subcollection 'orders' under the user's document
    CollectionReference userOrders = FirebaseFirestore.instance
        .collection('Services made by user')
        .doc(userId)
        .collection('Services Request');

    try {
      await userOrders.add({
        'userId': userId,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
        'serviceTitle': serviceTitle,
        'imagePath': imagePath,
        'fileUrls': fileUrls,
      });

      Fluttertoast.showToast(
        msg: "Service details saved successfully!".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error saving data".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<String?> uploadToCloudinary(File file) async {
    if (!file.existsSync()) {
      print("File does not exist: ${file.path}");
      return null;
    }

    String mimeType = lookupMimeType(file.path) ?? 'unknown';
    print("Uploading file with mime type: $mimeType");

    Uri url;
    String uploadPreset = 'Servix';

    if (mimeType.startsWith('image/')) {
      url = Uri.parse('https://api.cloudinary.com/v1_1/dstg1nqdx/image/upload');
    } else if (mimeType.startsWith('video/')) {
      url = Uri.parse('https://api.cloudinary.com/v1_1/dstg1nqdx/video/upload');
    } else {
      print("Invalid file type. Expected image or video, but got $mimeType");
      return null;
    }

    try {
      var request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['upload_preset'] = uploadPreset;

      var response = await request.send();

      if (response.statusCode == 200) {
        var result = await response.stream.bytesToString();
        var json = jsonDecode(result);
        return json['secure_url']; // Return the uploaded file's URL
      } else {
        print("Failed to upload file. Response status: ${response.statusCode}");
        print("Response body: ${await response.stream.bytesToString()}");
        return null;
      }
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }

  Widget _buildTextField(
    String hintText, {
    int maxLines = 10,
    required TextEditingController controller,
    String? errorText,
    required ThemeProvider themeProvider,
  }) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.castoro(
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white54
                : Colors.black54,
            fontSize: 15),
        filled: true,
        fillColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        errorText: errorText,
        errorStyle: GoogleFonts.castoro(color: Colors.red, fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF9E9E9E), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF9E9E9E), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }
}
