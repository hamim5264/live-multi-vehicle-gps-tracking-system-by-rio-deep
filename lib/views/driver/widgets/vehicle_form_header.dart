import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VehicleFormHeader extends StatelessWidget {
  final VoidCallback? onBack;
  final Color card;
  final Color bdr;
  final Color tx;
  final Color mt;

  const VehicleFormHeader({
    super.key,
    required this.onBack,
    required this.card,
    required this.bdr,
    required this.tx,
    required this.mt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: card,
        border: Border(bottom: BorderSide(color: bdr)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: mt, size: 20),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 8),
          Text(
            'Vehicle Configuration',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: tx,
            ),
          ),
        ],
      ),
    );
  }
}
