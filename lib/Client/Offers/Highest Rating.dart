import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Components/Buttons.dart';
import '../../Theme/Theme_Provider.dart';
import 'Lowest Price.dart';
import 'Model/Offer.dart';
import 'OfferDetailsScreen.dart';
import 'The Nearest.dart';
import 'offer_card.dart';

class HighestRatingScreen extends StatefulWidget {
  const HighestRatingScreen({super.key});

  @override
  State<HighestRatingScreen> createState() => _HighestRatingScreenState();
}

class _HighestRatingScreenState extends State<HighestRatingScreen> {
  int selectedIndex = 0;

  List<Offer> offers = [
    Offer(
      id: '1',
      name: 'Basmala Osama',
      rating: 3.5,
      price: 350,
      address1: 'Moharm beh',
      address2: 'Amir elbehari street',
      image: 'assets/images/photos_of_technicians/basbosa.jpg',
    ),
    Offer(
      id: '2',
      name: 'Nour Amer',
      rating: 4.0,
      price: 350,
      address1: 'Moharm beh',
      address2: 'Amir elbehari street',
      image: 'assets/images/photos_of_technicians/NOUR.jpg',
    ),
    Offer(
      id: '3',
      name: 'Basmala Osama',
      rating: 4.6,
      price: 350,
      address1: 'Moharm beh',
      address2: 'Amir elbehari street',
      image: 'assets/images/photos_of_technicians/basbosa.jpg',
    ),
    Offer(
      id: '4',
      name: 'Basmala Osama',
      rating: 1,
      price: 350,
      address1: 'Moharm beh',
      address2: 'Amir elbehari street',
      image: 'assets/images/photos_of_technicians/basbosa.jpg',
    ),
    Offer(
      id: '5',
      name: 'Nour Amer',
      rating: 2.5,
      price: 350,
      address1: 'Moharm beh',
      address2: 'Amir elbehari street',
      image: 'assets/images/photos_of_technicians/NOUR.jpg',
    ),
  ];
  void onSelect(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LowestPriceScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TheNearestScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    offers.sort((a, b) => b.rating.compareTo(a.rating));
  }

  void removeOffer(String id) {
    setState(() {
      offers.removeWhere((offer) => offer.id == id);
    });
  }

  Widget buildOptionButton(String text, int index) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: SizedBox(
        height: 65,
        child: isSelected
            ? GradientButtonOffer(
          text: text,
          font: 14,
          onPressed: () => onSelect(index),
        )
            : WhiteButtonOffer(
          text: text,
          font: 14,
          onPressed: () => onSelect(index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Text(
          "Offers".tr(),
          style: GoogleFonts.cantataOne(
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
        child: Column(
          children: [
            Row(
              children: [
                buildOptionButton("The Nearest", 2),
                buildOptionButton("Highest Rating", 0),
                buildOptionButton("Lowest price", 1),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return OfferCard(
                    offer: offer,
                    onDecline: () => removeOffer(offer.id),
                    onAccept: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OfferDetailsScreen(offer: offer),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
