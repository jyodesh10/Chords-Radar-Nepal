import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

mixin AppColors {
  static const Color warmWood = Color(0xFF4E342E);
  static const Color honeyOak = Color(0xFFC29A63);
  static const Color amber = Color(0xFFFFD700);
  static const Color burntOrange = Color(0xFFD95B43);
  static const Color olive = Color(0xFF38A3A5);
  static const Color sage = Color(0xFFA0AF87);

  static const Color gunmetal = Color(0xFF2C3E50);
  static const Color charcoal = Color(0xFF333333);
  static const Color neonBlue = Color(0xFF007BFF);
  static const Color limeGreen = Color(0xFFA2C952);
  
  static const Color deepTeal = Color(0xFF008080);
  static const Color vibrantPurple = Color(0xFF5D00FF);
  static const Color white = Colors.white;
}

TextStyle titleStyle = GoogleFonts.poppins(
    fontSize: 20, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.bold);
TextStyle subtitleStyle = GoogleFonts.poppins(
    fontSize: 15, color: AppColors.neonBlue, fontWeight: FontWeight.w300);