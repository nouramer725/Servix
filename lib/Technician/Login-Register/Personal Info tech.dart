import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:servix/Components/Buttons.dart';
import 'package:servix/Technician/Login-Register/Sign_In_Tech.dart';
import '../../Components/TextField for National ID.dart';
import 'Database for personal information.dart';

class PersonalInformation extends StatefulWidget {
  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final ImagePicker _picker = ImagePicker();
  File? personalImage, frontID, backID, criminalRecord, armyCertificate, skillsCertificate;
  final TextEditingController nationalIdController = TextEditingController();

  bool personalImageError = false, frontIDError = false, backIDError = false, criminalRecordError = false, nationalIdError = false;

  Future<void> pickImage(Function(File?) onImagePicked) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => onImagePicked(File(pickedFile.path)));
    }
  }

  Widget buildImagePicker(String title, File? imageFile, Function(File?) onImagePicked, bool showError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => pickImage(onImagePicked),
          child: Container(
            height: 125,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: showError ? Colors.red : Colors.transparent, width: 2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 6))],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black12,
                  backgroundImage: imageFile != null ? FileImage(imageFile) : null,
                  child: imageFile == null ? const Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 50) : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 25, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
        if (showError) const Padding(
          padding: EdgeInsets.only(left: 12, top: 4),
          child: Text("This field is required", style: TextStyle(color: Colors.red, fontSize: 14)),
        ),
      ],
    );
  }

  void onSubmit() async {
    setState(() {
      personalImageError = personalImage == null;
      frontIDError = frontID == null;
      backIDError = backID == null;
      criminalRecordError = criminalRecord == null;
      String nationalId = nationalIdController.text.trim();
      nationalIdError = nationalId.isEmpty || nationalId.length != 14;
    });

    if (personalImageError || frontIDError || backIDError || criminalRecordError || nationalIdError) {
      return;
    }

    Map<String, dynamic> userData = {
      'personalImage': personalImage!.path,
      'frontID': frontID!.path,
      'backID': backID!.path,
      'criminalRecord': criminalRecord!.path,
      'armyCertificate': armyCertificate?.path ?? '',
      'skillsCertificate': skillsCertificate?.path ?? '',
      'nationalID': nationalIdController.text.trim(),
    };

    await DatabaseHelper().insertUserData(userData);

    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInTechnician()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 25, right: 25, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildImagePicker("Personal Image *", personalImage, (file) => setState(() => personalImage = file), personalImageError),
              buildImagePicker("Front ID Image *", frontID, (file) => setState(() => frontID = file), frontIDError),
              buildImagePicker("Back ID Image *", backID, (file) => setState(() => backID = file), backIDError),
              buildImagePicker("Criminal Record Image *", criminalRecord, (file) => setState(() => criminalRecord = file), criminalRecordError),
              buildImagePicker("Army Certificate", armyCertificate, (file) => setState(() => armyCertificate = file), false),
              buildImagePicker("Skills Measurements Certificate", skillsCertificate, (file) => setState(() => skillsCertificate = file), false),
              const SizedBox(height: 20),
              customTextFieldNational(controller: nationalIdController, labelText: "Enter your National ID", showError: nationalIdError),
              const SizedBox(height: 20),
              GradientButton(onPressed: onSubmit, text: "Confirm"),
            ],
          ),
        ),
      ),
    );
  }
}
