import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Category {
  final String categoryname;
  final String image;
  final Color color;
  final double height;



  const Category({
    required this.categoryname,
    required this.image,
    required this.color,
    required this.height,
  });
}