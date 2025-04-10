import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Components/Description Screen component.dart';
import '../../../Components/service_card.dart';

class HomeService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xffE57D38),
          iconTheme: const IconThemeData(
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DescriptionnScreen(
                        title: 'Cleaning', // Custom title
                        imagePath:
                            'assets/images/home-service/cleaning.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Carpentry'.tr(),
                imagePath: 'assets/images/home-service/Carpentry.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DescriptionnScreen(
                        title: 'Carpentry', // Custom title
                        imagePath:
                            'assets/images/home-service/Carpentry.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Electricity'.tr(),
                imagePath: 'assets/images/home-service/Electricity.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DescriptionnScreen(
                        title: 'Electricity', // Custom title
                        imagePath:
                            'assets/images/home-service/Electricity.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Plumbing'.tr(),
                imagePath: 'assets/images/home-service/Plumbing.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DescriptionnScreen(
                        title: 'Plumbing', // Custom title
                        imagePath:
                            'assets/images/home-service/Plumbing.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Kitchen Technician'.tr(),
                imagePath: 'assets/images/home-service/Kitchentechnician.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DescriptionnScreen(
                        title: 'Kitchen Technician', // Custom title
                        imagePath:
                            'assets/images/home-service/Kitchentechnician.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Painting'.tr(),
                imagePath: 'assets/images/home-service/painting.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DescriptionnScreen(
                        title: 'Painting', // Custom title
                        imagePath:
                            'assets/images/home-service/painting.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Camera Technician'.tr(),
                imagePath: 'assets/images/home-service/camera.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DescriptionnScreen(
                        title: 'Camera Technician', // Custom title
                        imagePath:
                            'assets/images/home-service/camera.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Gardener'.tr(),
                imagePath: 'assets/images/home-service/LandScaper.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DescriptionnScreen(
                        title: 'Gardener', // Custom title
                        imagePath:
                            'assets/images/home-service/LandScaper.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            // ServiceCard(
            //   serviceName: 'Tiling'.tr(),
            //   imagePath: 'assets/images/home-service/tiling.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Pest Control'.tr(),
            //   imagePath: 'assets/images/home-service/pest_control.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Masonry'.tr(),
            //   imagePath: 'assets/images/home-service/masonry.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Roofing'.tr(),
            //   imagePath: 'assets/images/home-service/roofing.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Furniture Assembly'.tr(),
            //   imagePath: 'assets/images/home-service/furniture_assembly.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Window Cleaning'.tr(),
            //   imagePath: 'assets/images/home-service/window_cleaning.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Car Detailing'.tr(),
            //   imagePath: 'assets/images/home-service/car_detailing.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Laundry Service'.tr(),
            //   imagePath: 'assets/images/home-service/laundry.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Handyman'.tr(),
            //   imagePath: 'assets/images/home-service/handyman.jpg',
            // ),
          ],
        ),
      ),
    );
  }
}
