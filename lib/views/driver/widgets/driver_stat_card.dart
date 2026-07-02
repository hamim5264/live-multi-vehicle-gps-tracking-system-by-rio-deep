import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final Color cardColor;
  final Color borderColor;
  final Color textColor;
  final Color labelColor;

  const DriverStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
