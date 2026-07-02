import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../models/vehicle.dart';
import '../../widgets/status_badge.dart';

class NearbyVehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final Color card;
  final Color bdr;
  final Color tx;
  final Color mt;
  final VoidCallback onTap;

  const NearbyVehicleCard({
    super.key,
    required this.vehicle,
    required this.card,
    required this.bdr,
    required this.tx,
    required this.mt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: bdr),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A5F),
                borderRadius: BorderRadius.circular(14),
              ),
              child: vehicle.photoBase64 != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.memory(
                        base64Decode(vehicle.photoBase64!),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.local_shipping_outlined,
                      color: AppColors.primaryLight,
                      size: 22,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          vehicle.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: tx,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      StatusBadge(status: vehicle.status),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${vehicle.driver} · ${vehicle.number}',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: mt),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${vehicle.speed.toInt()} km/h',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: tx,
                  ),
                ),
                Text(
                  vehicle.lastUpdated,
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, color: mt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
