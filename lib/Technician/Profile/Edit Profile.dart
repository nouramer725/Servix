import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
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
  final TextEditingController _phoneController = TextEditingController();

  double? userRating;
  double averageRating = 0.0;
  int totalRatings = 0;
  String description = "Description"; // Default placeholder
  String phoneNumber = "N/A"; // ✅ Store phone number
  String street = "Street not available";
  String area = "Area not available";

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

  Future<void> _fetchAverageRating() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    QuerySnapshot ratingsSnapshot = await FirebaseFirestore.instance
        .collection('technician')
        .doc(user.uid)
        .collection('ratings')
        .get();

    if (ratingsSnapshot.docs.isNotEmpty) {
      double sum = 0;
      for (var doc in ratingsSnapshot.docs) {
        sum += (doc.data() as Map<String, dynamic>)['rating'];
      }
      setState(() {
        totalRatings = ratingsSnapshot.docs.length;
        averageRating = sum / totalRatings;
      });
    }
  }

  Future<void> _submitRating(double rating) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    await FirebaseFirestore.instance
        .collection('technician')
        .doc(currentUser.uid)
        .collection('ratings')
        .doc(currentUser.uid)
        .set({'rating': rating});

    _fetchAverageRating();
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
      String latestDocId = querySnapshot.docs.first.id; // Get latest document ID

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
          title: Text("Edit Location", style: GoogleFonts.castoro(fontSize: 25, fontWeight: FontWeight.bold, color: ApplicationColor)),
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
              child: Text("Cancel", style: GoogleFonts.castoro(fontSize: 20, color: ApplicationColor3)),
            ),
            TextButton(
              onPressed: () {
                _updateLocationDetails(
                    streetController.text, areaController.text);
                Navigator.pop(context);
              },
              child: Text("Save", style: GoogleFonts.castoro(fontSize: 20, fontWeight: FontWeight.bold, color: ApplicationColor)),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchAverageRating();
    _fetchDescription();
    _loadPhoneNumber();
    _fetchLocationDetails();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("user-files")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("uploads")
                        .snapshots(),
                    builder: (context, snapshot) {
                      String? personalFileUrl;
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        personalFileUrl =
                            snapshot.data!.docs.first['personalFileUrl'];
                      }

                      return GestureDetector(
                        onTap: () =>
                            updateProfileImage(), // Function to update image
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 70,
                          backgroundImage: personalFileUrl != null
                              ? NetworkImage(personalFileUrl)
                              : null,
                          child: personalFileUrl == null
                              ? const Icon(Icons.person,
                                  size: 40, color: Colors.grey)
                              : null,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () =>
                          updateProfileImage(), // Function to update image
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: ApplicationColor,
                        child: const Icon(Icons.camera_alt_outlined,
                            size: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Ensures spacing between text & icon
                children: [
                  Expanded(
                    child: Text(
                      userData != null
                          ? "Name: ${userData!['first_name']} ${userData!['last_name']}"
                          : "Welcome".tr(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: GoogleFonts.castoro(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showEditDialog,
                    icon: FaIcon(
                      FontAwesomeIcons.pencil,
                      color: Colors.black.withOpacity(0.7),
                      size: 20,
                    ),
                  )
                ],
              ),
              Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.grey[300],
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Rating: ${averageRating.toStringAsFixed(1)}",
                    style: GoogleFonts.castoro(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 5),
                  RatingBar.builder(
                    initialRating: userRating ?? 0,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 25,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amberAccent,
                    ),
                    onRatingUpdate: (rating) {
                      _submitRating(rating);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.grey[300],
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Ensures spacing between text & icon
                children: [
                  userData == null
                      ? CircularProgressIndicator(color: ApplicationColor)
                      : Column(
                          children: [
                            Text(
                              "Main Service: ${userData!['main_service'] ?? 'N/A'}",
                              style: GoogleFonts.castoro(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF676767)),
                            ),
                            Text(
                              "Sub Service: ${userData!['sub_service'] ?? 'N/A'}",
                              style: GoogleFonts.castoro(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF676767)),
                            ),
                          ],
                        ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.pencil,
                      color: Colors.black.withOpacity(0.7),
                      size: 20,
                    ),
                    onPressed: _showEditDialogService,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.grey[300],
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Description : $description",
                      style: GoogleFonts.castoro(
                          color: Color(0xFF676767), fontSize: 22),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 20,
                    ),
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.pencil,
                      color: Colors.black.withOpacity(0.7),
                      size: 20,
                    ),
                    onPressed: _showEditDialogDiscription,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.grey[300],
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Ensures spacing between text & icon
                children: [
                  Text(
                    "Phone Number: $phoneNumber",
                    style: GoogleFonts.castoro(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF676767)),
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.pencil,
                      color: Colors.black.withOpacity(0.7),
                      size: 20,
                    ),
                    onPressed: _showEditPhoneDialog,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.grey[300],
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Space between text & icon
                children: [
                  Expanded(
                    // To prevent overflow if the text is long
                    child: Text(
                      "Street: $street\nArea: $area",
                      style: GoogleFonts.castoro(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF676767),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.pencil,
                      color: Colors.black.withOpacity(0.7),
                      size: 20,
                    ),
                    onPressed:
                        _showEditLocationDialog, // Function to edit location details
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.grey[300],
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),

              // Row(
              //   children: [
              //     _buildSocialIcon(
              //       FontAwesomeIcons.facebookF,
              //       "https://firebase.flutter.dev/docs/auth/social/",
              //       [
              //         Color(0xFF1877F2), // Facebook Blue
              //         Color(0xFF0A66C2), // Slightly darker Blue
              //       ],
              //     ),
              //     const SizedBox(width: 10),
              //     _buildSocialIcon(
              //       FontAwesomeIcons.phone,
              //       "https://firebase.flutter.dev/docs/auth/social/",
              //       [ApplicationColor, ApplicationColorWithOpacity],
              //     ),
              //     const SizedBox(width: 10),
              //     _buildSocialIcon(
              //       FontAwesomeIcons.locationDot,
              //       "https://firebase.flutter.dev/docs/auth/social/",
              //       [
              //         Colors.black87,
              //         Colors.red,
              //       ],
              //     ),
              //     const SizedBox(width: 10),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
