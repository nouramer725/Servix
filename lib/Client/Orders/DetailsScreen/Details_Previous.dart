import 'package:flutter/material.dart';
import '../model/model.dart';

class DetailsPrevious extends StatelessWidget {
  final OrderModel orders;

  const DetailsPrevious({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('DetailsPrevious'),
      ),
    );
  }
}
