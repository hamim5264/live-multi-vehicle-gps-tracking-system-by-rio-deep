import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';

class VehicleImagePicker extends StatelessWidget {
  final String? photoBase64;
  final VoidCallback onTap;
  final Color tx;
  final Color mt;
  final Color ibg;

  const VehicleImagePicker({
    super.key,
    this.photoBase64,
    required this.onTap,
    required this.tx,
    required this.mt,
    required this.ibg,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ibg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: photoBase64 != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.memory(
                  base64Decode(photoBase64!),
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Vehicle Photo',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: tx,
                    ),
                  ),
                  Text(
                    'Please add or pick landscape image',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: mt),
                  ),
                ],
              ),
      ),
    );
  }
}
