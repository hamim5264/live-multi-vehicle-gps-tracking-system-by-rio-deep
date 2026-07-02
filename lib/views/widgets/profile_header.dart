import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String role;
  final VoidCallback onEditName;
  final bool isDark;
  final Color tx;
  final Color mt;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.role,
    required this.onEditName,
    required this.isDark,
    required this.tx,
    required this.mt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E3A5F), AppColors.darkBg]
              : [const Color(0xFFEFF6FF), AppColors.lightBg],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 36,
        left: 20,
        right: 20,
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              userName.length >= 2
                  ? userName.substring(0, 2).toUpperCase()
                  : 'US',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 28,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userName,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: tx,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onEditName,
                child: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ],
          ),
          Text(
            userEmail,
            style: GoogleFonts.plusJakartaSans(fontSize: 13, color: mt),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              role,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
