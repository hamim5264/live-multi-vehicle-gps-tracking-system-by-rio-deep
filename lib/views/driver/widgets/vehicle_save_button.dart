import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VehicleSaveButton extends StatelessWidget {
  final bool hasVehicle;
  final VoidCallback onPressed;

  const VehicleSaveButton({
    super.key,
    required this.hasVehicle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          hasVehicle ? 'Update Vehicle' : 'Save Vehicle',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
