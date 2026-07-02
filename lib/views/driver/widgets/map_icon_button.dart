import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class MapIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const MapIconButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.white20),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
