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
            'Delivery Services'.tr(),
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
                serviceName: 'School delivery'.tr(),
                imagePath: 'assets/images/delivery/school.jpg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DescriptionnScreen(
                        title: 'School delivery', // Custom title
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
                      builder: (context) => const DescriptionnScreen(
                        title: 'Parcels', // Custom title
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
                      builder: (context) => const DescriptionnScreen(
                        title: 'Taxi', // Custom title
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
                      builder: (context) => const DescriptionnScreen(
                        title: 'Bus', // Custom title
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
                      builder: (context) => const DescriptionnScreen(
                        title: 'Truck', // Custom title
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
                      builder: (context) => const DescriptionnScreen(
                        title: 'Scooter', // Custom title
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
                      builder: (context) => const DescriptionnScreen(
                        title: 'Loader Truck', // Custom title
                        imagePath:
                            'assets/images/delivery/loader.jpg', // Custom image
                      ),
                    ),
                  );
                }),
            // ServiceCard(
            //   serviceName: 'Motorcycle'.tr(),
            //   imagePath: 'assets/images/delivery/motorcycle.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Food Delivery'.tr(),
            //   imagePath: 'assets/images/delivery/food_delivery.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Courier'.tr(),
            //   imagePath: 'assets/images/delivery/courier.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Furniture Delivery'.tr(),
            //   imagePath: 'assets/images/delivery/furniture_delivery.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Grocery Delivery'.tr(),
            //   imagePath: 'assets/images/delivery/grocery_delivery.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Parcel Delivery'.tr(),
            //   imagePath: 'assets/images/delivery/parcel_delivery.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Mail Delivery'.tr(),
            //   imagePath: 'assets/images/delivery/mail_delivery.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Moving Services'.tr(),
            //   imagePath: 'assets/images/delivery/moving_services.jpg',
            // ),
            // ServiceCard(
            //   serviceName: 'Flower Delivery'.tr(),
            //   imagePath: 'assets/images/delivery/flower_delivery.jpg',
            // ),
          ],
        ),
      ),
    );
  }
}
