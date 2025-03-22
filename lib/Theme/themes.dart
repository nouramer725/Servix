import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:servix/constents/constent.dart';

ThemeData darktheme= ThemeData(
  scaffoldBackgroundColor: Color(0xFF333739),
  appBarTheme: AppBarTheme(
    titleSpacing: 20.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor:Color(0xFF333739),
      statusBarIconBrightness: Brightness.light,
    ),
    backgroundColor: Color(0xFF333739),
    elevation: 0.0,
    titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.bold
    ),
    iconTheme: IconThemeData(
        color: Colors.white
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor:  ApplicationColorWithOpacity,
    elevation: 0.0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: ApplicationColor,
    unselectedItemColor: Colors.grey,
    elevation: 30.0,
    backgroundColor: Color(0xFF333739),
  ),
);


ThemeData lighttheme= ThemeData(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    titleSpacing: 25.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor:Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: ApplicationColor,
    unselectedItemColor: ApplicationColor3,
    elevation: 30.0,
  ),
);