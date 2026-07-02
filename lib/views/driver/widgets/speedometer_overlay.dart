import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';

class SpeedometerOverlay extends StatelessWidget {
  final bool isTracking;
  final double speed;

  const SpeedometerOverlay({
    super.key,
    required this.isTracking,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 72,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.white20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isTracking ? speed.toStringAsFixed(0) : '0',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1,
              ),
            ),
            Text(
              'KM/H',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: AppColors.white50,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
