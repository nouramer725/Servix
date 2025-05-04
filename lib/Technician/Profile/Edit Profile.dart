import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:servix/Technician/Profile/google%20map%20of%20default%20location.dart';
import 'package:servix/Technician/Profile/widgets/EditableRow.dart';
import 'package:servix/Technician/Profile/widgets/ThemedDivider.dart';
import 'package:servix/Technician/Profile/widgets/images.dart';
import 'package:servix/constents/constent.dart';
import '../../Components/List of Service.dart';
import '../../Theme/Theme_Provider.dart';

class ProfileTechnicianEdit extends StatefulWidget {
  const ProfileTechnicianEdit({super.key});

  @override
  State<ProfileTechnicianEdit> createState() => _ProfileTechnicianEditState();
}

class _ProfileTechnicianEditState extends State<ProfileTechnicianEdit> {
  Map<String, dynamic>? userData;
  LatLng? userLocation;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  TextEditingController mainServiceController = TextEditingController();
  TextEditingController subServiceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _socialMediaController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String description = "Description";
  String phoneNumber = "N/A";
  String street = "Street not available";
  String building = "Building not available";
  String apartment = "Apartment not available";
  String area = "Area not available";
  String linkSocialMedia = "LinkSocialMedia".tr();
  var themeProvider = ThemeProvider();

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

  Future<void> updateProfileImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );

    if (result != null) {
      File newImage = File(result.files.single.path!);

      // Upload to Cloudinary
      String? newImageUrl = await uploadToCloudinary(newImage);
      if (newImageUrl == null) {
        print("Failed to upload new profile image.");
        return;
      }

      // Update Firestore with new image URL
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("user-files")
            .doc(user.uid)
            .collection("uploads")
            .get()
            .then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            querySnapshot.docs.first.reference.update({
              "personalFileUrl": newImageUrl,
            });
          }
        });
      }
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('technician')
          .doc(user.uid)
          .get();
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  void _loadUserData() async {
    var data = await getUserData();
    if (!mounted) return;
    setState(() {
      userData = data;
      if (userData != null) {
        _firstNameController.text = userData!['first_name'] ?? '';
        _lastNameController.text = userData!['last_name'] ?? '';
      }
    });
  }

  Future<void> _updateUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('technician')
          .doc(user.uid)
          .update({
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
      });
      _loadUserData();
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'Profile updated successfully'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: themeProvider.themeMode == ThemeMode.dark
              ? const Color(0xFF333739)
              : Colors.white,
          title: Text(
            "Edit Name".tr(),
            style: GoogleFonts.castoro(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : ApplicationColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _firstNameController,
                style: GoogleFonts.castoro(
                  fontSize: 15,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: "First Name".tr(),
                  labelStyle: GoogleFonts.castoro(color: Colors.grey),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _lastNameController,
                style: GoogleFonts.castoro(
                  fontSize: 15,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: "Last Name".tr(),
                  labelStyle: GoogleFonts.castoro(color: Colors.grey),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel".tr(),
                style: GoogleFonts.castoro(
                    fontSize: 20,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ),
            TextButton(
              onPressed: _updateUserName,
              child: Text("Update".tr(),
                  style: GoogleFonts.castoro(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : ApplicationColor)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateService(String? mainService, String? subService) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('technician')
          .doc(user.uid)
          .update({
        'main_service': mainService,
        'sub_service': subService,
      });
      Fluttertoast.showToast(
          msg: 'Profile updated successfully'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0);
      _loadUserData(); // Refresh UI
    }
  }

  void _showEditDialogService() {
    String? selectedMainService = userData?['main_service'.tr()];
    String? selectedSubService = userData?['sub_service'.tr()];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Text(
          "Edit Services".tr(),
          style: GoogleFonts.castoro(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white
                  : ApplicationColor),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            // Before building the dropdown:
            if (selectedMainService != null &&
                !subServicesMap.keys.contains(selectedMainService)) {
              selectedMainService = null;
            }
            if (selectedSubService != null &&
                (selectedMainService == null ||
                    !subServicesMap[selectedMainService]!
                        .contains(selectedSubService))) {
              selectedSubService = null;
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Main Service Dropdown
                DropdownButtonFormField<String>(
                  value: selectedMainService?.tr(),
                  dropdownColor: themeProvider.themeMode == ThemeMode.dark
                      ? const Color(0xFF333739)
                      : Colors.white,
                  decoration: InputDecoration(
                    labelText: "Main Service".tr(),
                    labelStyle: GoogleFonts.castoro(color: Colors.grey),
                    border: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFAEAEAE), width: 1),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFAEAEAE), width: 1),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFAEAEAE), width: 1),
                    ),
                  ),
                  items: subServicesMap.keys.map((String service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(service,
                          style: GoogleFonts.castoro(
                              fontSize: 15,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMainService = newValue;
                      selectedSubService = null;
                    });
                  },
                ),

                const SizedBox(height: 10),

                // Sub Service Dropdown
                DropdownButtonFormField<String>(
                  value: selectedSubService,
                  dropdownColor: themeProvider.themeMode == ThemeMode.dark
                      ? const Color(0xFF333739)
                      : Colors.white,
                  decoration: InputDecoration(
                    labelText: "Sub Service".tr(),
                    labelStyle: GoogleFonts.castoro(color: Colors.grey),
                    border: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFAEAEAE), width: 1),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFAEAEAE), width: 1),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFAEAEAE), width: 1),
                    ),
                  ),
                  items: selectedMainService != null
                      ? subServicesMap[selectedMainService]!
                          .map((String sub) => DropdownMenuItem<String>(
                                value: sub,
                                child: Text(sub,
                                    style: GoogleFonts.castoro(
                                        fontSize: 15,
                                        color: themeProvider.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white
                                            : Colors.black)),
                              ))
                          .toList()
                      : [],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSubService = newValue;
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel".tr(),
              style: GoogleFonts.castoro(
                  fontSize: 20,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              _updateService(selectedMainService, selectedSubService);
              Navigator.pop(context); // Close the dialog after saving
            },
            child: Text("Update".tr(),
                style: GoogleFonts.castoro(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : ApplicationColor)),
          ),
        ],
      ),
    );
  }

  void _fetchDescription() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('technician')
        .doc(uid)
        .get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        description = data.containsKey('description')
            ? data['description']
            : "No Description Available".tr();
      });
    }
  }

  void _saveDescription(String newDescription) async {
    await FirebaseFirestore.instance
        .collection('technician')
        .doc(FirebaseAuth.instance.currentUser!.uid) // Use actual UID
        .set({
      'description': newDescription,
    }, SetOptions(merge: true)); // Merges without overwriting other fields

    setState(() {
      description = newDescription;
    });
    Fluttertoast.showToast(
        msg: 'Profile updated successfully'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _showEditDialogDiscription() {
    _descController.text = description;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Text(
          "Edit Description".tr(),
          style: GoogleFonts.castoro(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white
                  : ApplicationColor),
        ),
        content: TextField(
          controller: _descController,
          maxLines: 5,
          style: GoogleFonts.castoro(
            fontSize: 15,
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
          decoration: InputDecoration(
            labelText: "Enter new description".tr(),
            labelStyle: GoogleFonts.castoro(color: Colors.grey),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel".tr(),
              style: GoogleFonts.castoro(
                  fontSize: 20,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              _saveDescription(_descController.text);
              Navigator.pop(context);
            },
            child: Text("Update".tr(),
                style: GoogleFonts.castoro(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : ApplicationColor)),
          ),
        ],
      ),
    );
  }

  Future<void> _loadPhoneNumber() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('technician')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          phoneNumber = userDoc['phone'] ?? "N/A";
        });
      }
    }
  }

  void _showEditPhoneDialog() {
    _phoneController.text = phoneNumber; // ✅ Pre-fill current phone number

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: themeProvider.themeMode == ThemeMode.dark
              ? const Color(0xFF333739)
              : Colors.white,
          title: Text(
            "Edit Phone Number".tr(),
            style: GoogleFonts.castoro(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : ApplicationColor),
          ),
          content: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: GoogleFonts.castoro(
              fontSize: 15,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            decoration: InputDecoration(
              labelText: "Phone Number".tr(),
              hintText: "Enter new phone number".tr(),
              labelStyle: GoogleFonts.castoro(color: Colors.grey),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel".tr(),
                style: GoogleFonts.castoro(
                    fontSize: 20,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                String newPhone = _phoneController.text.trim();
                if (newPhone.isEmpty ||
                    newPhone.length != 11 ||
                    !RegExp(r'^\d{11}$').hasMatch(newPhone)) {
                  Fluttertoast.showToast(
                    msg: "Please enter a valid 11-digit phone number.".tr(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    backgroundColor: ApplicationColorWithOpacity,
                    textColor: Colors.white,
                  );
                  return;
                }

                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection('technician')
                      .doc(user.uid)
                      .update({'phone': newPhone});

                  setState(() {
                    phoneNumber = newPhone;
                  });
                }

                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: 'Profile updated successfully'.tr(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    backgroundColor: ApplicationColorWithOpacity,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              child: Text("Update".tr(),
                  style: GoogleFonts.castoro(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : ApplicationColor)),
            ),
          ],
        );
      },
    );
  }

  void _fetchLocationDetails() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("user-files")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("locationDetails")
        .orderBy("timestamp", descending: true) // Get latest entry
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs.first.data() as Map<String, dynamic>;

      setState(() {
        street = data['street'] ?? "Street not available";
        area = data['area'] ?? "Area not available";
        building = data['building'] ?? "Building not available";
        apartment = data['apartment'] ?? "Apartment not available";
        userLocation = LatLng(data['latitude'], data['longitude']);
      });
    } else {
      setState(() {
        street = "Street not available";
        area = "Area not available";
        building = "Building not available";
        apartment = "Apartment not available";
      });
    }
  }

  void _saveLinkSocialMedia(String newSocial) async {
    await FirebaseFirestore.instance
        .collection('technician')
        .doc(FirebaseAuth.instance.currentUser!.uid) // Use actual UID
        .set({
      'LinkSocialMedia': newSocial,
    }, SetOptions(merge: true)); // Merges without overwriting other fields

    setState(() {
      linkSocialMedia = newSocial;
    });
    Fluttertoast.showToast(
        msg: 'Profile updated successfully'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _showEditDialogSocialMedia() {
    _socialMediaController.text = linkSocialMedia;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Text(
          "Edit Facebook Link".tr(),
          style: GoogleFonts.castoro(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white
                  : ApplicationColor),
        ),
        content: TextField(
          controller: _socialMediaController,
          style: GoogleFonts.castoro(
            fontSize: 15,
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
          maxLines: 1,
          decoration: InputDecoration(
            labelText: "Link".tr(),
            labelStyle: GoogleFonts.castoro(color: Colors.grey),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel".tr(),
              style: GoogleFonts.castoro(
                  fontSize: 20,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              _saveLinkSocialMedia(_socialMediaController.text);
              Navigator.pop(context);
            },
            child: Text("Update".tr(),
                style: GoogleFonts.castoro(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : ApplicationColor)),
          ),
        ],
      ),
    );
  }

  void _fetchLinkSocialMedia() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('technician')
        .doc(FirebaseAuth.instance.currentUser!.uid) // Use actual UID
        .get();
    if (doc.exists) {
      setState(() {
        linkSocialMedia =
            doc['LinkSocialMedia'] ?? "No SocialMedia Link Available".tr();
      });
    }
  }

  Future<void> _pickAndUploadImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      List<String> uploadedUrls = [];

      // Show a FlutterToast indicating the upload process has started
      Fluttertoast.showToast(
        msg: "Uploading...".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
      );

      for (var pickedFile in pickedFiles) {
        final file = File(pickedFile.path);
        final url = await uploadToCloudinary(file);
        if (url != null) {
          uploadedUrls.add(url);
        }
      }

      if (uploadedUrls.isNotEmpty) {
        await saveImageUrlsToFirestore(uploadedUrls);

        // Show a success message after uploading
        Fluttertoast.showToast(
          msg: "Images uploaded successfully!".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<void> saveImageUrlsToFirestore(List<String> imageUrls) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('technician').doc(uid).set({
      'Products': FieldValue.arrayUnion(imageUrls),
    }, SetOptions(merge: true));
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchDescription();
    _loadPhoneNumber();
    _fetchLocationDetails();
    _fetchLinkSocialMedia();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Text(
          "Edit Profile".tr(),
          style: GoogleFonts.castoro(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileImageWidget(onTap: updateProfileImage),
              const SizedBox(height: 20),
              EditableRow(
                title: "Name:".tr(),
                text: userData != null
                    ? "${userData!['first_name']} ${userData!['last_name']}"
                    : "Welcome".tr(),
                onEdit: _showEditDialog,
                icon: FontAwesomeIcons.pencil,
              ),
              const ThemedDivider(),
              EditableRow(
                title: "Main Service:\nSub Service:".tr(),
                text:
                    "${userData?['main_service'] ?? 'N/A'}\n${userData?['sub_service'] ?? 'N/A'}"
                        .tr(),
                onEdit: _showEditDialogService,
                icon: FontAwesomeIcons.pencil,
              ),
              const ThemedDivider(),
              EditableRow(
                title: "Description:".tr(),
                text: description,
                onEdit: _showEditDialogDiscription,
                maxLines: 20,
                icon: FontAwesomeIcons.pencil,
              ),
              const ThemedDivider(),
              EditableRow(
                title: "Phone Number:".tr(),
                text: phoneNumber,
                onEdit: _showEditPhoneDialog,
                icon: FontAwesomeIcons.pencil,
              ),
              const ThemedDivider(),
              const SizedBox(
                height: 10,
              ),
              if (userLocation != null)
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: userLocation!,
                        initialZoom: 15.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: userLocation!,
                              child: Icon(
                                Icons.location_pin,
                                color: ApplicationColor,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? const Color(0x9DEAEAEA)
                      : const Color(0xFFF9F4F4),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(10, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_pin,
                            color: ApplicationColor, size: 30),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "$area, $street, $building ,$apartment",
                            style: GoogleFonts.castoro(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF676565),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const GoogleMapDefaultLocationTech(),
                                ));
                          },
                          child: Text(
                            "Change Your Location".tr(),
                            style: GoogleFonts.castoro(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ApplicationColor,
                              decoration: TextDecoration.underline,
                              decorationColor: ApplicationColor,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const ThemedDivider(),
              EditableRow(
                  title: "Facebook Link:".tr(),
                  text: linkSocialMedia,
                  onEdit: _showEditDialogSocialMedia,
                  maxLines: 20,
                  icon: FontAwesomeIcons.pencil),
              const ThemedDivider(),
              EditableRow(
                title: "Products:".tr(),
                text: "Upload images of work".tr(),
                onEdit: _pickAndUploadImages,
                maxLines: 20,
                icon: FontAwesomeIcons.image,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
