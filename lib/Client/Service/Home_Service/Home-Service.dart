import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Components/service_card.dart';

class HomeService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xffE57D38),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'Home Service'.tr(),
            style: GoogleFonts.castoro(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home/home-service.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            ServiceCard(
              serviceName: 'Cleaning'.tr(),
              imagePath: 'assets/images/home-service/cleaning.jpg',
            ),
            ServiceCard(
              serviceName: 'Carpentry'.tr(),
              imagePath: 'assets/images/home-service/Carpentry.jpg',
            ),
            ServiceCard(
              serviceName: 'Electricity'.tr(),
              imagePath: 'assets/images/home-service/Electricity.jpg',
            ),
            ServiceCard(
              serviceName: 'Plumbing'.tr(),
              imagePath: 'assets/images/home-service/Plumbing.jpg',
            ),
            ServiceCard(
              serviceName: 'Kitchen Technician'.tr(),
              imagePath: 'assets/images/home-service/Kitchentechnician.jpg',
            ),
            ServiceCard(
              serviceName: 'Painting'.tr(),
              imagePath: 'assets/images/home-service/painting.jpg',
            ),
            ServiceCard(
              serviceName: 'Camera Technician'.tr(),
              imagePath: 'assets/images/home-service/camera.jpg',
            ),
            ServiceCard(
              serviceName: 'Gardener'.tr(),
              imagePath: 'assets/images/home-service/LandScaper.jpg',
            ),
            ServiceCard(
              serviceName: 'Tiling'.tr(),
              imagePath: 'assets/images/home-service/tiling.jpg',
            ),
            ServiceCard(
              serviceName: 'Pest Control'.tr(),
              imagePath: 'assets/images/home-service/pest_control.jpg',
            ),
            ServiceCard(
              serviceName: 'Masonry'.tr(),
              imagePath: 'assets/images/home-service/masonry.jpg',
            ),
            ServiceCard(
              serviceName: 'Roofing'.tr(),
              imagePath: 'assets/images/home-service/roofing.jpg',
            ),
            ServiceCard(
              serviceName: 'Furniture Assembly'.tr(),
              imagePath: 'assets/images/home-service/furniture_assembly.jpg',
            ),
            ServiceCard(
              serviceName: 'Window Cleaning'.tr(),
              imagePath: 'assets/images/home-service/window_cleaning.jpg',
            ),
            ServiceCard(
              serviceName: 'Car Detailing'.tr(),
              imagePath: 'assets/images/home-service/car_detailing.jpg',
            ),
            ServiceCard(
              serviceName: 'Laundry Service'.tr(),
              imagePath: 'assets/images/home-service/laundry.jpg',
            ),
            ServiceCard(
              serviceName: 'Handyman'.tr(),
              imagePath: 'assets/images/home-service/handyman.jpg',
            ),
          ],
        ),
      ),
    );
  }
}