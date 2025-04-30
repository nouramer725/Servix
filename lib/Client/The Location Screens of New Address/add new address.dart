import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../Components/Buttons.dart';
import '../../../../Theme/Theme_Provider.dart';
import '../../../../constents/constent.dart';
import '../Home/HomeLayoutClient.dart';
import 'google maps new address.dart';

class NewAddress extends StatefulWidget {
  final String orderId;
  String? description;
  String? serviceTitle;
  String? imagePath;
  List<String> fileUrls = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  NewAddress(
      {super.key,
      required this.orderId,
      this.description,
      this.serviceTitle,
      this.imagePath,
      required this.fileUrls,
      required this.selectedDate,
      required this.selectedTime});

  @override
  State<NewAddress> createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  String? area;
  String? street;
  String? building;
  String? apartment;

  String? newarea;
  String? newstreet;
  String? newbuilding;
  String? newapartment;
  List<Map<String, dynamic>> newLocations = [];

  int? selectedIndex = -1;
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();


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

  @override
  void initState() {
    super.initState();
    fetchUserLocation();
    fetchUserNewLocation();
    getUserNames();
    fetchProfileImageUrl();
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
            area = data['area'];
            street = data['street'];
            building = data['building'];
            apartment = data['apartment'];
          });
        } else {
          print('Latitude or longitude is null.');
        }
      } else {
        print('No location details found for this user.');
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<void> fetchUserNewLocation() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('user-files')
          .doc(userId)
          .collection('NewLocationDetails')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          newLocations = querySnapshot.docs.map((doc) => doc.data()).toList();
        });
      } else {
        print('No location details found for this user.');
      }
    } catch (e) {
      print('Error fetching location: $e');
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
          title: Text(
            'Saved Address'.tr(),
            style: GoogleFonts.castoro(
                fontSize: 20,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                              "$area, $street, $building, $apartment",
                              style: GoogleFonts.castoro(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF676565),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = -1; // Select the first location
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ApplicationColor,
                                  width: 2,
                                ),
                              ),
                              child: selectedIndex == -1
                                  ? Center(
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ApplicationColor,
                                          border: Border.all(
                                            color: ApplicationColor,
                                            width: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newLocations.length,
                  itemBuilder: (context, index) {
                    final location = newLocations[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
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
                        child: Row(
                          children: [
                            Icon(Icons.location_pin,
                                color: ApplicationColor, size: 30),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "${location['area']}, ${location['street']}, ${location['building']} building, apartment no.${location['apartment']}",
                                style: GoogleFonts.castoro(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF676565),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ApplicationColor,
                                    width: 2,
                                  ),
                                ),
                                child: selectedIndex == index
                                    ? Center(
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ApplicationColor,
                                            border: Border.all(
                                              color: ApplicationColor,
                                              width: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                GradientButton(
                    onPressed: () async {
                      Fluttertoast.showToast(
                        msg: "Posting..".tr(),
                        backgroundColor: ApplicationColorWithOpacity,
                        textColor: Colors.white,
                        fontSize: 16.0,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                      );
                      await saveServiceWithSelectedLocation();

                      Future.delayed(const Duration(seconds: 2), () {
                        Fluttertoast.showToast(
                          msg: "Posted".tr(),
                          backgroundColor: ApplicationColorWithOpacity,
                          textColor: Colors.white,
                          fontSize: 16.0,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                        );
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeClientLayout(),
                          ));
                    },
                    text: "Post".tr()),
                const SizedBox(height: 15),
                GradientButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoogleMapNewScreenClient(
                              orderId: widget.orderId, // Pass the orderId here
                            ),
                          ));
                    },
                    text: "Add A New Address".tr()),
              ],
            ),
          ),
        ));
  }

  Future<void> saveServiceWithSelectedLocation() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      Map<String, dynamic> selectedLocation;

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

      if (selectedIndex == -1) {
        // Use the default address
        selectedLocation = {
          'area': area ?? '',
          'street': street ?? '',
          'building': building ?? '',
          'apartment': apartment ?? '',
          'source': 'default',
          'timestamp': FieldValue.serverTimestamp(),
        };
      } else if (selectedIndex! >= 0 && selectedIndex! < newLocations.length) {
        // Use one of the new locations
        selectedLocation = {
          ...newLocations[selectedIndex!],
          'source': 'new',
          'latitude': newLocations[selectedIndex!]['latitude'],
          'longitude': newLocations[selectedIndex!]['longitude'],
          'area': newLocations[selectedIndex!]['area'],
          'street': newLocations[selectedIndex!]['street'],
          'building': newLocations[selectedIndex!]['building'],
          'apartment': newLocations[selectedIndex!]['apartment'],
          'description': widget.description,
          'serviceTitle': serviceTitleMap, // <-- Store as a map
          'fileUrls': widget.fileUrls,
          'selectedDate': DateFormat('dd-MM-yyyy').format(widget.selectedDate!),
          'selectedTime': widget.selectedTime!.format(context),
          'Status': 'Pending',
          'userId': user.uid,
          'orderId': widget.orderId,
          'firstName': userNames['first_name'],
          'lastName': userNames['last_name'],
          'profileImageUrl': profileImageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        };
      } else {
        Fluttertoast.showToast(msg: "Please select a valid location.".tr());
        return;
      }
      await FirebaseFirestore.instance
          .collection('Services Requests')
          .doc(user.uid)
          .collection('user-services')
          .doc(widget.orderId)
          .set(selectedLocation);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error saving service: $e",
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
      print("Error saving service: $e");
    }
  }
}
