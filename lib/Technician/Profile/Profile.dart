import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/constents/constent.dart';
import '../../Components/List of Service.dart';
import '../../Theme/Theme_Provider.dart';

class ProfileTechnician extends StatefulWidget {
  const ProfileTechnician({super.key});

  @override
  State<ProfileTechnician> createState() => _ProfileTechnicianState();
}

class _ProfileTechnicianState extends State<ProfileTechnician> {
  Map<String, dynamic>? userData;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  TextEditingController mainServiceController = TextEditingController();
  TextEditingController subServiceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  double? userRating;
  double averageRating = 0.0;
  int totalRatings = 0;
  String description = "Description"; // Default placeholder

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
        .doc('user_id')
        .get();
    if (doc.exists) {
      setState(() {
        description = doc['description'] ?? "Description";
      });
    }
  }

  void _saveDescription(String newDescription) async {
    await FirebaseFirestore.instance
        .collection('technician')
        .doc('user_id')
        .set({
      'description': newDescription,
    }, SetOptions(merge: true));

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchAverageRating();
    _fetchDescription();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
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
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("user-files")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("uploads")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    String personalFileUrl =
                        snapshot.data!.docs.first['personalFileUrl'];
                    return CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 70,
                      backgroundImage: NetworkImage(personalFileUrl),
                    );
                  }
                  return const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 70,
                    child: Icon(Icons.person, size: 100),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userData != null
                        ? " ${userData!['first_name']} ${userData!['last_name']}"
                        : "Welcome".tr(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: GoogleFonts.castoro(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: _showEditDialog,
                    icon: FaIcon(
                      FontAwesomeIcons.filePen,
                      color: Colors.black.withOpacity(0.7),
                      size: 20,
                    ),
                  )
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${averageRating.toStringAsFixed(1)}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[600]),
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
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userData == null
                      ? CircularProgressIndicator(color: ApplicationColor)
                      : Column(
                          children: [
                            Text(
                              "Main Service: ${userData!['main_service'] ?? 'N/A'}",
                              style: GoogleFonts.castoro(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF676767)),
                            ),
                            Text(
                              "Sub Service: ${userData!['sub_service'] ?? 'N/A'}",
                              style: GoogleFonts.castoro(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF676767)),
                            ),
                          ],
                        ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.filePen,
                      color: Colors.black.withOpacity(0.7),
                      size: 20,
                    ),
                    onPressed: _showEditDialogService,
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.19,
                    margin: const EdgeInsets.all(17),
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        description,
                        style: TextStyle(color: Colors.grey[600], fontSize: 18),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10, // Adjust as needed
                    right: 5, // Adjust as needed
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.filePen,
                        color: Colors.black.withOpacity(0.7),
                        size: 20,
                      ),
                      onPressed: _showEditDialogDiscription,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
