import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';

class VehicleNumberField extends StatelessWidget {
  final TextEditingController controller;
  final Color ibg;
  final Color bdr;
  final Color mt;
  final Color tx;

  const VehicleNumberField({
    super.key,
    required this.controller,
    required this.ibg,
    required this.bdr,
    required this.mt,
    required this.tx,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return TextFormField(
      controller: controller,
      style: GoogleFonts.plusJakartaSans(
        color: tx,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
      decoration: InputDecoration(
        hintText: 'ABC-1234',
        hintStyle: GoogleFonts.plusJakartaSans(color: mt, letterSpacing: 1),
        filled: true,
        fillColor: ibg,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        prefixIcon: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          width: 36,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.white10,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'BD',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: mt,
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: bdr),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: bdr),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
    );
  }
}
