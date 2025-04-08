import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Components/service_card.dart';

class DeliveryServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased AppBar height
        child: AppBar(
          backgroundColor: const Color(0xffA52754),
          iconTheme: IconThemeData(
              color: Colors.white
          ),
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
            ),
            ServiceCard(
              serviceName: 'Spend'.tr(),
              imagePath: 'assets/images/delivery/spend.jpg',
            ),
            ServiceCard(
              serviceName: 'Taxi'.tr(),
              imagePath: 'assets/images/delivery/Taxi.jpg',
            ),
            ServiceCard(
              serviceName: 'Bus'.tr(),
              imagePath: 'assets/images/delivery/bus.jpg',
            ),
            ServiceCard(
              serviceName: 'Truck'.tr(),
              imagePath: 'assets/images/delivery/truck.jpg',
            ),
            ServiceCard(
              serviceName: 'Scooter'.tr(),
              imagePath: 'assets/images/delivery/scooter.jpg',
            ),
            ServiceCard(
              serviceName: 'Loader Truck'.tr(),
              imagePath: 'assets/images/delivery/loader.jpg',
            ),
            ServiceCard(
              serviceName: 'Motorcycle'.tr(),
              imagePath: 'assets/images/delivery/motorcycle.jpg',
            ),
            ServiceCard(
              serviceName: 'Food Delivery'.tr(),
              imagePath: 'assets/images/delivery/food_delivery.jpg',
            ),
            ServiceCard(
              serviceName: 'Courier'.tr(),
              imagePath: 'assets/images/delivery/courier.jpg',
            ),
            ServiceCard(
              serviceName: 'Furniture Delivery'.tr(),
              imagePath: 'assets/images/delivery/furniture_delivery.jpg',
            ),
            ServiceCard(
              serviceName: 'Grocery Delivery'.tr(),
              imagePath: 'assets/images/delivery/grocery_delivery.jpg',
            ),
            ServiceCard(
              serviceName: 'Parcel Delivery'.tr(),
              imagePath: 'assets/images/delivery/parcel_delivery.jpg',
            ),
            ServiceCard(
              serviceName: 'Mail Delivery'.tr(),
              imagePath: 'assets/images/delivery/mail_delivery.jpg',
            ),
            ServiceCard(
              serviceName: 'Moving Services'.tr(),
              imagePath: 'assets/images/delivery/moving_services.jpg',
            ),
            ServiceCard(
              serviceName: 'Flower Delivery'.tr(),
              imagePath: 'assets/images/delivery/flower_delivery.jpg',
            ),
          ],
        ),
      ),
    );
  }
}
