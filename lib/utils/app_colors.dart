import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E3A8A);
  static const Color secondary = Color(0xFF3B5998);
  static const Color accent = Colors.amber;
  static const Color background = Colors.white;
  static const Color textPrimary = Colors.black87;
  static const Color disabled = Color(0xFFB0B0B0);
  static const Color textWhite = Colors.white;

  static const Color deepBlue = Color(0xFF0D47A1);
  static const Color gradientStart = Color(0xFF1E3A8A);
  static const Color gradientEnd = Color(0xFF3B5998);
  static const List<Color> gradient = [gradientStart, Colors.white, gradientEnd];

  static const LinearGradient favoriteGradient = LinearGradient(
    colors: [gradientStart, Colors.white, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient homepageBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1E3A8A),
      Color(0xFF2A3A8A),
      Color(0xFF3B5998),
    ],
  );

}
