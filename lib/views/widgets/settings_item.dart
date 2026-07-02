import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color mt;
  final Color tx;
  final Color bdr;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isLast;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.label,
    required this.mt,
    required this.tx,
    required this.bdr,
    this.trailing,
    this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: mt, size: 20),
      title: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: tx,
        ),
      ),
      trailing:
          trailing ??
          (onTap != null
              ? Icon(Icons.arrow_forward_ios_rounded, color: mt, size: 14)
              : null),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: isLast ? const Radius.circular(20) : Radius.zero,
          bottomRight: isLast ? const Radius.circular(20) : Radius.zero,
        ),
      ),
    );
  }
}
