import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const MapButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.white20),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
