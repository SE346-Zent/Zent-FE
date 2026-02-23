import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class TextStyles {
  
  static final TextStyle display = GoogleFonts.lexend(
    fontWeight: FontWeight.w700, 
    fontSize: 32.0,
    height: 1.25, 
  );

  static final TextStyle headline = GoogleFonts.lexend(
    fontWeight: FontWeight.w600, 
    fontSize: 24.0,
    height: 1.33,
  );

  static final TextStyle title = GoogleFonts.lexend(
    fontWeight: FontWeight.w500, 
    fontSize: 20.0,
    height: 1.40,
  );

  static final TextStyle bodyLarge = GoogleFonts.sourceSans3(
    fontWeight: FontWeight.w400, 
    fontSize: 16.0,
    height: 1.50,
  );

  static final TextStyle bodyMedium = GoogleFonts.sourceSans3(
    fontWeight: FontWeight.w400, 
    fontSize: 14.0,
    height: 1.50,
  );

  static final TextStyle label = GoogleFonts.sourceSans3(
    fontWeight: FontWeight.w500, 
    fontSize: 12.0,
    height: 1.33,
  );
}