import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Define static color variables
  static const Color primaryBackground = Color(0XFFFFFFFF);
  static const Color appBarColor = Color(0XFFA7ED10);
  static const Color GridCardColor = Color(0XFF000000);
  static const Color SearchBarColor = Color(0XFFB5B5B5);
  static const Color GridCardTextColor = Color(0XFFFFFFFF);
  // Add more colors as needed
}

class AppFonts {
  static TextStyle regular({
    double fontSize = 16.0,
    Color color = Colors.black,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle bold({
    double fontSize = 16.0,
    Color color = Colors.black,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle italic({
    double fontSize = 16.0,
    Color color = Colors.black,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      color: color,
      fontStyle: FontStyle.italic,
    );
  }
}
