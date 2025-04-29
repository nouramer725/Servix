import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Components/Description Screen component.dart';
import '../../../Components/service_card.dart';

class DeliveryServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xffA52754),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Delivery Service'.tr(),
            style: GoogleFonts.castoro(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home/delivery.png'),
                alignment: Alignment.centerRight,
                fit: BoxFit.contain,
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
                serviceName: 'School Delivery'.tr(),
                imagePath: 'assets/images/delivery/school.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'School Delivery'.tr(), // Custom title
                        imagePath:
                            'assets/images/delivery/school.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Parcels'.tr(),
                imagePath: 'assets/images/delivery/spend.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Parcels'.tr(), // Custom title
                        imagePath:
                            'assets/images/delivery/spend.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Taxi'.tr(),
                imagePath: 'assets/images/delivery/Taxi.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Taxi'.tr(), // Custom title
                        imagePath:
                            'assets/images/delivery/Taxi.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Bus'.tr(),
                imagePath: 'assets/images/delivery/bus.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Bus'.tr(), // Custom title
                        imagePath:
                            'assets/images/delivery/bus.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Truck'.tr(),
                imagePath: 'assets/images/delivery/truck.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Truck'.tr(), // Custom title
                        imagePath:
                            'assets/images/delivery/truck.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Scooter'.tr(),
                imagePath: 'assets/images/delivery/scooter.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Scooter'.tr(), // Custom title
                        imagePath:
                            'assets/images/delivery/scooter.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            ServiceCard(
                serviceName: 'Loader Truck'.tr(),
                imagePath: 'assets/images/delivery/loader.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DescriptionnScreen(
                        title: 'Loader Truck'.tr(), // Custom title
                        imagePath:
                            'assets/images/delivery/loader.jpg', // Custom image
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
