import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dk = Theme.of(context).brightness == Brightness.dark;
    final bg = dk ? AppColors.darkBg : AppColors.lightBg;
    final card = dk ? AppColors.darkCard : Colors.white;
    final tx = dk ? Colors.white : const Color(0xFF0F172A);
    final mt = dk ? AppColors.white50 : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: dk ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy & Security Policy',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: tx,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'At FleetLive, we take your privacy and location data security extremely seriously. We only track location when you explicitly enable live tracking.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: mt,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '1. Data We Collect',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: tx,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '• Real-time GPS location coordinates of the vehicle (only when active tracking is toggled on).\n'
                '• Vehicle registration details, description, and status.\n'
                '• Driver credentials and profiles.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: mt,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '2. How We Protect Your Info',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: tx,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'All communications between your device, Firebase Auth, and Firebase Realtime Database are encrypted over SSL/TLS channels.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: mt,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
