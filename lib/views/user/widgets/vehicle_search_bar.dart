import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';

class VehicleSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Color card;
  final Color bdr;
  final Color tx;
  final Color mt;

  const VehicleSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.card,
    required this.bdr,
    required this.tx,
    required this.mt,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: GoogleFonts.plusJakartaSans(color: tx),
      decoration: InputDecoration(
        hintText: 'Search vehicles or drivers…',
        hintStyle: GoogleFonts.plusJakartaSans(color: mt, fontSize: 13),
        prefixIcon: Icon(Icons.search_rounded, color: mt, size: 20),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear_rounded, color: mt, size: 18),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              )
            : null,
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: bdr),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: bdr),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
