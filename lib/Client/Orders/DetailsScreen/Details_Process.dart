import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/model.dart';

class DetailsProcess extends StatelessWidget {
  final OrderModel orders;

  const DetailsProcess({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
            ),
            expandedHeight: 275.0,
            backgroundColor: Colors.white,
            elevation: 0.0,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                orders.ServiceImage,
                fit: BoxFit.cover,
              ),
              stretchModes: const [
                StretchMode.blurBackground,
                StretchMode.zoomBackground,
              ],
            ),
          ),

          // Example content
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Order Details Here..."),
            ),
          ),
        ],
      ),
    );
  }
}
