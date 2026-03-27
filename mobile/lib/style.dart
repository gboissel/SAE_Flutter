import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color greyColor = Colors.grey;

  static TextStyle titleLight = GoogleFonts.overpass(
    fontSize: 28,
    fontWeight: FontWeight.w200,
    color: Colors.black,
  );

  static TextStyle titleBold = GoogleFonts.overpass(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle airportCode = GoogleFonts.overpass(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: Colors.black54,
  );

  static TextStyle airportShortName = GoogleFonts.overpass(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static TextStyle airportLongName = GoogleFonts.overpass(
    fontSize: 12,
    color: Colors.black54,
  );

  static TextStyle stopSelectorText = GoogleFonts.overpass(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static BoxDecoration flightCardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: const Offset(0, 4),
        blurRadius: 12,
      ),
    ],
  );
}
