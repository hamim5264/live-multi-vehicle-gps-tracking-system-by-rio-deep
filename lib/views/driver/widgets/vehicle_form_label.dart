import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VehicleFormLabel extends StatelessWidget {
  final String text;
  final Color color;

  const VehicleFormLabel({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color.withValues(alpha: 0.7),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

InputDecoration vehicleFieldDecoration({
  required String hint,
  required IconData icon,
  required Color fillColor,
  required Color borderColor,
  required Color hintColor,
}) {
  final radius = BorderRadius.circular(16);
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon, size: 20),
    filled: true,
    fillColor: fillColor,
    hintStyle: GoogleFonts.plusJakartaSans(color: hintColor, fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: Color(0xFFEF4444)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}
