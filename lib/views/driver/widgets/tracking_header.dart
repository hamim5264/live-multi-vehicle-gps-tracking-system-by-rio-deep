import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';

class TrackingHeader extends StatelessWidget {
  final bool isTracking;

  const TrackingHeader({super.key, required this.isTracking});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const SizedBox(width: 48),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isTracking
                    ? AppColors.success.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.5),
                border: Border.all(
                  color: isTracking
                      ? AppColors.success.withValues(alpha: 0.4)
                      : AppColors.white20,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isTracking ? AppColors.success : AppColors.white35,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isTracking ? 'Live Tracking' : 'Tracking Off',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isTracking ? AppColors.success : AppColors.white50,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
