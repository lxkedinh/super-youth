import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Scheme
  static const primaryColor = Color(0xFFAA4405);
  static const secondaryColor = Color(0xFF03A9F4);
  static const accentColor = Color(0xFF00BCD4);
  static const backgroundColor = Color(0xFFF0742A);
  static const surfaceColor = Colors.white;
  static const errorColor = Color(0xFF981E1E);
  static const successColor = Color(0xFF4CAF50);
  static const warningColor = Color(0xFFFFA000);
  static const textColor = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      textTheme: GoogleFonts.nunitoSansTextTheme().apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),
      drawerTheme: DrawerThemeData(backgroundColor: primaryColor),
      appBarTheme: AppBarTheme(
        iconTheme: const IconThemeData(color: textColor, size: 28),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunitoSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColor,
          iconColor: textColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        fillColor: surfaceColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: textColor, size: 28),
      scaffoldBackgroundColor: backgroundColor,
    );
  }
}
