import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:servix/Components/Buttons.dart';
import 'package:servix/constents/constent.dart';
import '../../../Components/TextField for National ID.dart';
import '../LocationTechnician/Access_Location1.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});
  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  User? user = FirebaseAuth.instance.currentUser;
  String? personalFile,
      frontID,
      backID,
      criminalRecord,
      armyCertificate,
      skillsCertificate;
  final TextEditingController nationalIdController = TextEditingController();
  bool _isLoading = false; // Add isLoading state variable

  bool personalFileError = false,
      frontIDError = false,
      backIDError = false,
      criminalRecordError = false,
      nationalIdError = false;

  Future<void> pickFile(Function(String?) onFilePicked) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );
    if (result != null) {
      setState(() => onFilePicked(result.files.single.path));
    }
  }

  Widget buildFilePicker(String title, String? filePath,
      Function(String?) onFilePicked, bool showError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => pickFile(onFilePicked),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 0,
            ),
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: showError ? Colors.red : Colors.transparent, width: 2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 6))
              ],
            ),
            child: Row(
              children: [
                // Display Image if file is selected, otherwise show CircleAvatar
                filePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          File(filePath), // Load the file as an image
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(Icons.camera_alt_outlined,
                            color: Colors.grey, size: 50),
                      ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
        if (showError)
          Padding(
            padding: EdgeInsets.only(left: 12, top: 4),
            child: Text("This field is required".tr(),
                style: TextStyle(color: Colors.red, fontSize: 14)),
          ),
      ],
    );
  }

  void onSubmit() async {
    setState(() {
      _isLoading = true;
      personalFileError = personalFile == null;
      frontIDError = frontID == null;
      backIDError = backID == null;
      criminalRecordError = criminalRecord == null;
      String nationalId = nationalIdController.text.trim();
      nationalIdError = nationalId.isEmpty || nationalId.length != 14;
    });

    if (personalFileError ||
        frontIDError ||
        backIDError ||
        criminalRecordError ||
        nationalIdError) {
      Fluttertoast.showToast(
        msg: "Please fill all required fields properly.".tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
      setState(() => _isLoading = false);
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Fluttertoast.showToast(
        msg: "No user is logged in.".tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
      setState(() => _isLoading = false);
      return;
    }

    List<File> images = [
      File(personalFile!),
      File(frontID!),
      File(backID!),
      File(criminalRecord!),
      if (armyCertificate != null) File(armyCertificate!),
      if (skillsCertificate != null) File(skillsCertificate!),
    ];

    List<String> imageUrls = [];

    try {
      for (var image in images) {
        String? imageUrl = await uploadToCloudinary(image);
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        } else {
          throw Exception("Failed to upload ${image.path}");
        }
      }

      await FirebaseFirestore.instance
          .collection("user-files")
          .doc(user.uid)
          .collection("uploads")
          .add({
        "nationalId": nationalIdController.text.trim(),
        "personalFileUrl": imageUrls[0],
        "frontIDUrl": imageUrls[1],
        "backIDUrl": imageUrls[2],
        "criminalRecordUrl": imageUrls[3],
        "armyCertificateUrl": armyCertificate != null ? imageUrls[4] : null,
        "skillsCertificateUrl": skillsCertificate != null ? imageUrls[5] : null,
        "timestamp": FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(
        msg: "Data uploaded successfully.".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LocationRequestScreenTech()),
        (route) => false,
      );
    } on SocketException catch (_) {
      Fluttertoast.showToast(
        msg: "Network connection issue. Please check your internet.".tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    } on FirebaseException catch (e) {
      print("Firebase error: ${e.message}");
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Please try another image".tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<String?> uploadToCloudinary(File imageFile) async {
    String cloudinaryUrl =
        "https://api.cloudinary.com/v1_1/dstg1nqdx/image/upload";
    String uploadPreset = "Servix";

    var request = http.MultipartRequest("POST", Uri.parse(cloudinaryUrl));
    request.fields["upload_preset"] = uploadPreset;
    request.files
        .add(await http.MultipartFile.fromPath("file", imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      return jsonResponse["secure_url"];
    } else {
      print(
          "Cloudinary upload failed with status code: ${response.statusCode}");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 50, left: 25, right: 25, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildFilePicker(
                  "Personal Image *".tr(),
                  personalFile,
                  (file) => setState(() => personalFile = file),
                  personalFileError),
              buildFilePicker("Front ID Image *".tr(), frontID,
                  (file) => setState(() => frontID = file), frontIDError),
              buildFilePicker("Back ID Image *".tr(), backID,
                  (file) => setState(() => backID = file), backIDError),
              buildFilePicker(
                  "Criminal Record Image *".tr(),
                  criminalRecord,
                  (file) => setState(() => criminalRecord = file),
                  criminalRecordError),
              buildFilePicker("Army Certificate".tr(), armyCertificate,
                  (file) => setState(() => armyCertificate = file), false),
              buildFilePicker(
                  "Skills Measurements Certificate".tr(),
                  skillsCertificate,
                  (file) => setState(() => skillsCertificate = file),
                  false),
              const SizedBox(height: 20),
              customTextFieldNational(
                  controller: nationalIdController,
                  labelText: "Enter your National ID".tr(),
                  showError: nationalIdError),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  onPressed: _isLoading ? null : onSubmit,
                  text: _isLoading ? "Processing...".tr() : "Confirm".tr(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
