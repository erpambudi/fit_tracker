import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySnackbar {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: GoogleFonts.inter(),
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 28),
    ));
  }
}
