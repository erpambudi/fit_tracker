import 'package:fit_tracker/commons/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: MyColor.primaryColor,
      splashColor: MyColor.secondaryColor,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: MyColor.primaryColor,
        secondary: MyColor.secondaryColor,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),

      //Text Field Theme
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(
          color: MyColor.greyTextColor,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        fillColor: const Color(0xFFF2F3F7),
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      ),

      //Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: MyColor.primaryColor,
          onPrimary: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 22,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(38),
          ),
        ),
      ),
    );
  }
}
