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
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:servix/Client/Profile/google%20map%20of%20default%20location.dart';
import 'package:servix/Client/Profile/savedaddress.dart';
import 'package:servix/Components/TextFormFiels_SignUp.dart';
import '../../Components/Buttons.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final nameController2 = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  LatLng? userLocation;
  String? area;
  String? street;
  String? building;
  String? apartment;
  bool isLoading = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchUserLocation();
    fetchUserData();
  }

  Future<void> fetchUserLocation() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      final querySnapshot = await _firestore
          .collection('user-files')
          .doc(user.uid)
          .collection('locationDetails')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();
        final lat = data['latitude'];
        final lng = data['longitude'];
        setState(() {
          userLocation = LatLng(lat.toDouble(), lng.toDouble());
          area = data['area'];
          street = data['street'];
          building = data['building'];
          apartment = data['apartment'];
        });
      }
    } catch (e) {
      print('Error fetching location: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<String?> _getProfileImageUrl() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final firestore = FirebaseFirestore.instance;

    // Check first path
    final firstDoc = await firestore
        .collection("user-files")
        .doc(uid)
        .collection("personalInformation")
        .doc("profile")
        .get();

    if (firstDoc.exists && firstDoc.data()?['personalImageUrl'] != null) {
      return firstDoc.data()?['personalImageUrl'];
    }

    // Check second path
    final secondDoc = await firestore
        .collection("user-files")
        .doc(uid)
        .collection("personalInformationProvider")
        .doc("profile")
        .get();

    if (secondDoc.exists && secondDoc.data()?['personalImageUrl'] != null) {
      return secondDoc.data()?['personalImageUrl'];
    }

    return null;
  }

  void fetchUserData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data();

      if (data != null) {
        nameController.text = data['first_name'] ?? '';
        nameController2.text = data['last_name'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phone'] ?? '';
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void updateUserData() async {
    if (!formKey.currentState!.validate()) return;

    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await _firestore.collection('users').doc(uid).update({
        'first_name': nameController.text,
        'last_name': nameController2.text,
        'email': emailController.text,
        'phone': phoneController.text,
      });

      Fluttertoast.showToast(
          msg: 'Profile updated successfully'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print('Error updating user data: $e');
      Fluttertoast.showToast(
          msg: 'Profile Can not be updated'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: ApplicationColorWithOpacity,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      setState(() => isLoading = false);
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

      // Save URL to Firestore under personalInformation
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("user-files")
            .doc(user.uid)
            .collection("personalInformation")
            .doc("profile") // This is a fixed doc name for easy overwrite
            .set({
          "personalImageUrl": newImageUrl,
          "updatedAt": FieldValue.serverTimestamp(),
        });
      }
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Text(
          'Profile'.tr(),
          style: GoogleFonts.castoro(
            fontSize: 20,
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isLoading)
                LinearProgressIndicator(
                  color: ApplicationColor,
                ),
              FutureBuilder<String?>(
                future: _getProfileImageUrl(),
                builder: (context, snapshot) {
                  String? personalImageUrl = snapshot.data;

                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: updateProfileImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 60,
                          backgroundImage: personalImageUrl != null
                              ? NetworkImage(personalImageUrl)
                              : null,
                          child: personalImageUrl == null
                              ? const Icon(Icons.person,
                                  size: 50, color: Colors.grey)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 1,
                        right: 5,
                        child: GestureDetector(
                          onTap: () => updateProfileImage(),
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: ApplicationColor,
                            child: const Icon(Icons.camera_alt_outlined,
                                size: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              customTextField(
                controller: nameController,
                keyboardTypee: TextInputType.text,
                labelText: 'First Name'.tr(),
              ),
              customTextField(
                controller: nameController2,
                keyboardTypee: TextInputType.text,
                labelText: 'Second Name'.tr(),
              ),
              customTextField(
                controller: emailController,
                keyboardTypee: TextInputType.emailAddress,
                labelText: 'Email'.tr(),
                readOnly: true,
              ),
              customTextField(
                controller: phoneController,
                keyboardTypee: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                labelText: 'Phone Number'.tr(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required'.tr();
                  } else if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                    return 'Phone number must be exactly 11 digits'.tr();
                  }
                  return null;
                },
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
              if (area != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? const Color(0xFF333739)
                        : Color(0xFFF9F4F4),
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
                              "$area, $street, $building building, apartment no.$apartment",
                              style: GoogleFonts.castoro(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const GoogleMapDefaultLocation(),
                                  ));
                            },
                            child: Text(
                              "Change Your Location".tr(),
                              style: GoogleFonts.castoro(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : ApplicationColor,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    themeProvider.themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : ApplicationColor,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SavedAddressesprofile(),
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFAEAEAE)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Saved Address".tr(),
                        style: GoogleFonts.castoro(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : const Color(0xFF676565),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : const Color(0xFF676565),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GradientButton(
          onPressed: updateUserData,
          text: "Update".tr(),
        ),
      ),
    );
  }
}
