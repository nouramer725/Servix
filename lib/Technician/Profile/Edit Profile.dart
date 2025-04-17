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
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
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
  String area = "Area not available";
  String linkSocialMedia = "LinkSocialMedia";

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
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Edit Name",
            style: GoogleFonts.castoro(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: ApplicationColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: "First Name",
                ),
              ),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: "Last Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style:
                    GoogleFonts.castoro(fontSize: 20, color: ApplicationColor3),
              ),
            ),
            TextButton(
              onPressed: _updateUserName,
              child: Text("Save",
                  style: GoogleFonts.castoro(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ApplicationColor)),
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
      _loadUserData(); // Refresh UI
    }
  }

  void _showEditDialogService() {
    String? selectedMainService = userData?['main_service'];
    String? selectedSubService = userData?['sub_service'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit Services",
          style: GoogleFonts.castoro(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: ApplicationColor),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Main Service Dropdown
                DropdownButtonFormField<String>(
                  value: selectedMainService,
                  decoration: const InputDecoration(labelText: "Main Service"),
                  items: subServicesMap.keys.map((String service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(service),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMainService = newValue;
                      selectedSubService = null; // Reset sub-service
                    });
                  },
                ),

                const SizedBox(height: 10),

                // Sub Service Dropdown
                DropdownButtonFormField<String>(
                  value: selectedSubService,
                  decoration: const InputDecoration(labelText: "Sub Service"),
                  items: selectedMainService != null
                      ? subServicesMap[selectedMainService]!
                          .map((String sub) => DropdownMenuItem<String>(
                                value: sub,
                                child: Text(sub),
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
              "Cancel",
              style:
                  GoogleFonts.castoro(fontSize: 20, color: ApplicationColor3),
            ),
          ),
          TextButton(
            onPressed: () {
              _updateService(selectedMainService, selectedSubService);
              Navigator.pop(context); // Close the dialog after saving
            },
            child: Text("Save",
                style: GoogleFonts.castoro(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ApplicationColor)),
          ),
        ],
      ),
    );
  }

  void _fetchDescription() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('technician')
        .doc(FirebaseAuth.instance.currentUser!.uid) // Use actual UID
        .get();
    if (doc.exists) {
      setState(() {
        description = doc['description'] ?? "No Description Available";
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
  }

  void _showEditDialogDiscription() {
    _descController.text = description;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit Description",
          style: GoogleFonts.castoro(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: ApplicationColor),
        ),
        content: TextField(
          controller: _descController,
          maxLines: 5,
          decoration: const InputDecoration(hintText: "Enter new description"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style:
                  GoogleFonts.castoro(fontSize: 20, color: ApplicationColor3),
            ),
          ),
          TextButton(
            onPressed: () {
              _saveDescription(_descController.text);
              Navigator.pop(context);
            },
            child: Text("Save",
                style: GoogleFonts.castoro(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ApplicationColor)),
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
          title: Text(
            "Edit Phone Number".tr(),
            style: GoogleFonts.castoro(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: ApplicationColor),
          ),
          content: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Enter new phone number".tr(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel".tr(),
                style:
                    GoogleFonts.castoro(fontSize: 20, color: ApplicationColor3),
              ),
            ),
            TextButton(
              onPressed: () async {
                String newPhone = _phoneController.text.trim();
                if (newPhone.isNotEmpty) {
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
                }
                Navigator.pop(context);
              },
              child: Text("Save".tr(),
                  style: GoogleFonts.castoro(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ApplicationColor)),
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
      });
    } else {
      setState(() {
        street = "Street not available";
        area = "Area not available";
      });
    }
  }

  void _updateLocationDetails(String newStreet, String newArea) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Fetch the latest document ID
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("user-files")
        .doc(user.uid)
        .collection("locationDetails")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String latestDocId =
          querySnapshot.docs.first.id; // Get latest document ID

      await FirebaseFirestore.instance
          .collection("user-files")
          .doc(user.uid)
          .collection("locationDetails")
          .doc(latestDocId) // Update the same document
          .update({
        'street': newStreet,
        'area': newArea,
      });

      // Update UI
      setState(() {
        street = newStreet;
        area = newArea;
      });
    }
  }

  void _showEditLocationDialog() {
    TextEditingController streetController =
        TextEditingController(text: street);
    TextEditingController areaController = TextEditingController(text: area);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Location",
              style: GoogleFonts.castoro(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: ApplicationColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: streetController,
                decoration: InputDecoration(labelText: "Street"),
              ),
              TextField(
                controller: areaController,
                decoration: InputDecoration(labelText: "Area"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel",
                  style: GoogleFonts.castoro(
                      fontSize: 20, color: ApplicationColor3)),
            ),
            TextButton(
              onPressed: () {
                _updateLocationDetails(
                    streetController.text, areaController.text);
                Navigator.pop(context);
              },
              child: Text("Save",
                  style: GoogleFonts.castoro(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ApplicationColor)),
            ),
          ],
        );
      },
    );
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
  }

  void _showEditDialogSocialMedia() {
    _socialMediaController.text = linkSocialMedia;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit SocialMedia Link",
          style: GoogleFonts.castoro(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: ApplicationColor),
        ),
        content: TextField(
          controller: _socialMediaController,
          maxLines: 5,
          decoration:
              const InputDecoration(hintText: "Enter new SocialMedia Link"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style:
                  GoogleFonts.castoro(fontSize: 20, color: ApplicationColor3),
            ),
          ),
          TextButton(
            onPressed: () {
              _saveLinkSocialMedia(_socialMediaController.text);
              Navigator.pop(context);
            },
            child: Text("Save",
                style: GoogleFonts.castoro(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ApplicationColor)),
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
            doc['LinkSocialMedia'] ?? "No SocialMedia Link Available";
      });
    }
  }

  Future<void> _pickAndUploadImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      List<String> uploadedUrls = [];

      for (var pickedFile in pickedFiles) {
        final file = File(pickedFile.path);
        final url = await uploadToCloudinary(file);
        if (url != null) {
          uploadedUrls.add(url);
        }
      }

      if (uploadedUrls.isNotEmpty) {
        await saveImageUrlsToFirestore(uploadedUrls);
        Fluttertoast.showToast(
          msg: "Images uploaded successfully!",
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
          "Edit Profile",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileImageWidget(onTap: updateProfileImage),
              const SizedBox(height: 20),
              EditableRow(
                text: userData != null
                    ? "Name: ${userData!['first_name']} ${userData!['last_name']}"
                    : "Welcome".tr(),
                onEdit: _showEditDialog,
              ),
              const ThemedDivider(),
              EditableRow(
                text: "Main Service: ${userData?['main_service'] ?? 'N/A'}\n"
                    "Sub Service: ${userData?['sub_service'] ?? 'N/A'}",
                onEdit: _showEditDialogService,
              ),
              const ThemedDivider(),
              EditableRow(
                text: "Description : $description",
                onEdit: _showEditDialogDiscription,
                maxLines: 20,
              ),
              const ThemedDivider(),
              EditableRow(
                text: "Phone Number: $phoneNumber",
                onEdit: _showEditPhoneDialog,
              ),
              const ThemedDivider(),
              EditableRow(
                text: "Area: $area \n"
                    "Street: $street",
                onEdit: _showEditLocationDialog,
              ),
              const ThemedDivider(),
              EditableRow(
                text: "Link SocialMedia : $linkSocialMedia",
                onEdit: _showEditDialogSocialMedia,
                maxLines: 20,
              ),
              const ThemedDivider(),
              EditableRow(
                text: "Upload Work images to PRODUCTS part",
                onEdit: _pickAndUploadImages,
                maxLines: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
