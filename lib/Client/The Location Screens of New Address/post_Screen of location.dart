import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:servix/Client/Home/HomeLayoutClient.dart';
import 'package:servix/Components/Buttons.dart';
import '../../../../Theme/Theme_Provider.dart';
import '../../../../constents/constent.dart';
import 'add new address.dart';

class LocationPosting extends StatefulWidget {
  final String orderId;
  String? description;
  String? serviceTitle;
  String? imagePath;
  List<String> fileUrls = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  LocationPosting(
      {super.key,
      required this.orderId,
      required this.description,
      required this.serviceTitle,
      required this.imagePath,
      required this.fileUrls,
      required this.selectedTime,
      required this.selectedDate});

  @override
  State<LocationPosting> createState() => _LocationPostingState();
}

class _LocationPostingState extends State<LocationPosting> {
  LatLng? userLocation;
  String? area;
  String? street;
  String? building;
  String? apartment;
  bool isLoading = true;
  bool rememberMe = false;

  String get orderId => widget.orderId;

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    fetchUserLocation();
    getUserNames();
    fetchProfileImageUrl();
  }

  String _getArabicTranslation(String englishTitle) {
    Map<String, String> translationMap = {
      "Home Service": "خدمات منزلية",
      "Cleaning": "تنظيف",
      "Carpentry": "نجارة",
      "Electricity": "كهرباء",
      "Plumping": "سباكة",
      "Kitchen Technician": "فني مطبخ",
      "Painting": "دهان",
      "Camera Technician": "فني كاميرات",
      "Gardener": "جنايني",
      "Private Teaching": "تعليم خاص",
      "Primary": "ابتدائي",
      "Preparatory": "إعدادي",
      "Secondary": "ثانوي",
      "Musical Instrument": "آلة موسيقية",
      "Religion": "ديني",
      "Languages": "لغات",
      "For Men": "للرجال",
      "Haircut": "حلاق",
      "Private Coach": "مدرب خاص",
      "Massage Man": "مساج",
      "Tailoring Man": "خياط",
      "For Women": "للنساء",
      "Tailoring": "خياطة",
      "MakeUp Artist": "أخصائية تجميل",
      "Hair Styling": "تصفيف الشعر",
      "Pedicure": "باديكير",
      "Henna": "حناء",
      "Nails": "أظافر",
      "Massage": "مساج",
      "Private Coach Woman": "مدربة خاصة",
      "Care Service": "خدمات الرعاية",
      "Children": "رعاية الأطفال",
      "Elderly": "رعاية المسنين",
      "Pet": "رعاية الحيوانات الأليفة",
      "Nursing": "تمريض",
      "Disabilities": "رعاية ذوي الاحتياجات الخاصة",
      "Devices Service": "صيانة الأجهزة",
      "Mobile": "موبايل",
      "Computer": "كمبيوتر",
      "Air Conditioning": "تكييف",
      "Fridge": "ثلاجة",
      "Washing Machine": "غسالة",
      "Screens": "شاشات",
      "Microwave": "ميكروويف",
      "Stove": "بوتجاز",
      "Water Heater": "سخان مياه",
      "Fan": "مروحة",
      "Delivery Service": "خدمات التوصيل",
      "School Delivery": "توصيل للمدارس",
      "Parcels": "طرود",
      "Taxi": "تاكسي",
      "Bus": "حافلة",
      "Truck": "شاحنة",
      "Scooter": "سكوتر",
      "Loader Truck": "شاحنة نقل",
    };

    return translationMap[englishTitle] ?? englishTitle;
  }

  final Map<String, String> _arabicToEnglishMap = {
    "خدمات منزلية": "Home Service",
    "تنظيف": "Cleaning",
    "نجارة": "Carpentry",
    "كهرباء": "Electricity",
    "سباكة": "Plumbing",
    "فني مطبخ": "Kitchen Technician",
    "دهان": "Painting",
    "فني كاميرات": "Camera Technician",
    "جنايني": "Gardener",
    "تعليم خاص": "Private Teaching",
    "ابتدائي": "Primary",
    "إعدادي": "Preparatory",
    "ثانوي": "Secondary",
    "آلة موسيقية": "Musical Instrument",
    "ديني": "Religion",
    "لغات": "Languages",
    "للرجال": "For Men",
    "حلاق": "Haircut",
    "مدرب خاص": "Private Coach",
    "مساج": "Massage Man",
    "خياط": "Tailoring Man",
    "للنساء": "For Women",
    "خياطة": "Tailoring",
    "أخصائية تجميل": "MakeUp Artist",
    "تصفيف الشعر": "Hair Styling",
    "باديكير": "Pedicure",
    "حناء": "Henna",
    "أظافر": "Nails",
    "مساج": "Massage",
    "مدربة خاصة": "Private Coach Woman",
    "خدمات الرعاية": "Care Service",
    "رعاية الأطفال": "Children",
    "رعاية المسنين": "Elderly",
    "رعاية الحيوانات الأليفة": "Pet",
    "تمريض": "Nursing",
    "رعاية ذوي الاحتياجات الخاصة": "Disabilities",
    "صيانة الأجهزة": "Devices Service",
    "موبايل": "Mobile",
    "كمبيوتر": "Computer",
    "تكييف": "Air Conditioning",
    "ثلاجة": "Fridge",
    "غسالة": "Washing Machine",
    "شاشات": "Screens",
    "ميكروويف": "Microwave",
    "بوتجاز": "Stove",
    "سخان مياه": "Water Heater",
    "مروحة": "Fan",
    "خدمات التوصيل": "Delivery Service",
    "توصيل للمدارس": "School Delivery",
    "طرود": "Parcels",
    "تاكسي": "Taxi",
    "حافلة": "Bus",
    "شاحنة": "Truck",
    "سكوتر": "Scooter",
    "شاحنة نقل": "Loader Truck",
  };

  String _getEnglishVersion(String arabic) {
    return _arabicToEnglishMap[arabic.trim()] ?? arabic;
  }

  Future<void> fetchUserLocation() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('user-files')
          .doc(userId)
          .collection('locationDetails')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();
        final lat = data['latitude'];
        final lng = data['longitude'];
        area = data['area'];
        street = data['street'];
        building = data['building'];
        apartment = data['apartment'];

        if (lat != null && lng != null) {
          setState(() {
            userLocation = LatLng(lat.toDouble(), lng.toDouble());
            area = data['area'];
            street = data['street'];
            building = data['building'];
            apartment = data['apartment'];
            isLoading = false;
          });
        } else {
          print('Latitude or longitude is null.');
          setState(() => isLoading = false);
        }
      } else {
        print('No location details found for this user.');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching location: $e');
      setState(() => isLoading = false);
    }
  }

  Future<Map<String, String?>> getUserNames() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return {'name': null, 'imageUrl': null};

      final userDoc = await FirebaseFirestore.instance
          .collection('users') // Assuming the collection is named 'users'
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        return {
          'first_name': data['first_name'],
          'last_name': data['last_name'],
        };
      } else {
        return {'first_name': null, 'last_name': null};
      }
    } catch (e) {
      print("Error fetching user details: $e");
      return {'first_name': null, 'last_name': null};
    }
  }

  Future<String?> fetchProfileImageUrl() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return null; // Return null if no user is logged in
      }

      final snapshot = await FirebaseFirestore.instance
          .collection("user-files")
          .doc(user.uid)
          .collection("personalInformation")
          .doc("profile")
          .get();

      if (snapshot.exists) {
        return snapshot.data()?['personalImageUrl'];
      }

      return null; // Return null if the document doesn't exist
    } catch (e) {
      print('Error fetching profile image: $e');
      return null; // Return null if there's an error
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? const Color(0xFF333739)
          : Colors.white,
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: ApplicationColor,
            ))
          : userLocation == null
              ? Center(child: Text("Location not available".tr()))
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        Container(
                          height: 200,
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
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F4F4),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(10, 10))
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
                                        color: const Color(0xFF676565),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NewAddress(
                                                orderId: widget.orderId,
                                                description: widget.description,
                                                serviceTitle:
                                                    widget.serviceTitle,
                                                imagePath: widget.imagePath,
                                                fileUrls: widget.fileUrls,
                                                selectedDate:
                                                    widget.selectedDate,
                                                selectedTime:
                                                    widget.selectedTime,
                                              ),
                                            ));
                                      },
                                      child: Text(
                                        "Change your Location".tr(),
                                        style: GoogleFonts.castoro(
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 19,
                                            color: Colors.grey[800]),
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              activeColor: ApplicationColor,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value ?? false;
                                });
                              },
                            ),
                            Text(
                              "Accepting all terms and conditions".tr(),
                              style: GoogleFonts.castoro(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black),
                            ),
                          ],
                        ),
                      ]))),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GradientButton(
          onPressed: () async {
            if (!rememberMe) {
              Fluttertoast.showToast(
                msg: "You must accept the terms and conditions.".tr(),
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
                fontSize: 16.0,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
              );
              return;
            }

            Fluttertoast.showToast(
              msg: "Posting..".tr(),
              backgroundColor: ApplicationColorWithOpacity,
              textColor: Colors.white,
              fontSize: 16.0,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
            );

            try {
              final user = FirebaseAuth.instance.currentUser;

              if (user == null) {
                Fluttertoast.showToast(
                  msg: "User not logged in".tr(),
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
                return;
              }

              final userNames = await getUserNames(); // Fetch names
              final profileImageUrl =
                  await fetchProfileImageUrl(); // Fetch profile image URL

              final isArabic = context.locale.languageCode == 'ar';

              final serviceTitleMap = {
                'en': isArabic
                    ? _getEnglishVersion(widget.serviceTitle ?? '')
                    : widget.serviceTitle ?? '',
                'ar': isArabic
                    ? widget.serviceTitle ?? ''
                    : _getArabicTranslation(widget.serviceTitle ?? ''),
              };

              Map<String, dynamic> selectedLocation = {
                'latitude': userLocation!.latitude,
                'longitude': userLocation!.longitude,
                'area': area ?? '',
                'street': street ?? '',
                'building': building ?? '',
                'apartment': apartment ?? '',
                'description': widget.description,
                'serviceTitle': serviceTitleMap, // <-- Store as a map
                'fileUrls': widget.fileUrls,
                'selectedDate':
                    DateFormat('dd-MM-yyyy').format(widget.selectedDate!),
                'selectedTime': widget.selectedTime!.format(context),
                'Status': 'Pending',
                'userId': user.uid,
                'orderId': widget.orderId,
                'firstName': userNames['first_name'],
                'lastName': userNames['last_name'],
                'profileImageUrl': profileImageUrl,
                'timestamp': FieldValue.serverTimestamp(),
              };

              await FirebaseFirestore.instance
                  .collection('Services Requests')
                  .doc(user.uid)
                  .collection('user-services')
                  .doc(widget.orderId)
                  .set(selectedLocation);

              await Future.delayed(const Duration(seconds: 2));

              Fluttertoast.showToast(
                msg: "Posted".tr(),
                backgroundColor: ApplicationColorWithOpacity,
                textColor: Colors.white,
                fontSize: 16.0,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeClientLayout()),
              );
            } catch (e) {
              Fluttertoast.showToast(
                msg: "Error posting location: $e",
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
              print("Error saving location: $e");
            }
          },
          text: "Post".tr(),
        ),
      ),
    );
  }
}
