import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import 'colors.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    color: HexColor('333739'),
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 25,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('333739'),
      statusBarIconBrightness: Brightness.light,

    ),
  ),
  scaffoldBackgroundColor: HexColor('333739'),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: HexColor('333739'),
    elevation: 20,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,

  ),
  // primarySwatch: defaultColor,
  textTheme: TextTheme(
    bodyText1: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 18,
      color: Colors.white,
    ),
    bodyText2: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white70,
    ),
    subtitle1: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.3,
    ),
  ),
);
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 25,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,

    ),
  ),
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    elevation: 20,
    selectedItemColor: defaultColor,
    type: BottomNavigationBarType.fixed,

  ),
  textTheme: TextTheme(
      bodyText1: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        color: Colors.black,
      ),
      bodyText2: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      subtitle1: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.3,
      ),

  ),

  // primarySwatch: defaultColor,
);

ThemeData calculatorDarkTheme = ThemeData(
  scaffoldBackgroundColor: calculatorColor.withOpacity(0.6),
  appBarTheme: AppBarTheme(
    color: calculatorColor.withOpacity(0.0),
    titleTextStyle: (
        TextStyle(
            color: Colors.white,
            fontSize: 20
        )
    ),
    elevation: 0,
  ),
  primaryColor: Colors.white,
  sliderTheme: SliderThemeData(
    overlayColor: Colors.white,
    activeTickMarkColor: Colors.white,
    thumbColor: Colors.white,
  ),
  primarySwatch:  Colors.cyan,
);
ThemeData calculatorLightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white12,
  appBarTheme: AppBarTheme(
    color: Colors.white,
    titleTextStyle: (
        TextStyle(
            color: Colors.black,
            fontSize: 20
        )
    ),
    elevation: 0,
  ),
  primaryColor: Colors.black,
  sliderTheme: SliderThemeData(
    overlayColor: Colors.black,
    activeTickMarkColor: Colors.black,
    thumbColor: Colors.black,
  ),
  primarySwatch:  Colors.cyan,
);