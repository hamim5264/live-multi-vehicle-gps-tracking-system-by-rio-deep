import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';

class DriverActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final LinearGradient? gradient;
  final Color? color;
  final Color? cardColor;
  final Color? borderColor;

  const DriverActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.gradient,
    this.color,
    this.cardColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? cardColor : null,
        borderRadius: BorderRadius.circular(16),
        border: gradient == null
            ? Border.all(color: borderColor ?? AppColors.darkBorder)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: gradient != null ? Colors.white : color, size: 22),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: gradient != null ? Colors.white : color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
