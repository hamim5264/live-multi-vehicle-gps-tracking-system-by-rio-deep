import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';

class UserHomeStatCard extends StatelessWidget {
  final String value;
  final String label;
  final String change;
  final Color color;
  final Color cardColor;
  final Color borderColor;
  final Color textColor;
  final Color labelColor;

  const UserHomeStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.change,
    required this.color,
    required this.cardColor,
    required this.borderColor,
    required this.textColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9,
                color: labelColor,
                height: 1.3,
              ),
            ),
            Text(
              change,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
