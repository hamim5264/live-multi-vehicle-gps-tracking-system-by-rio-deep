import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../../../constants/app_colors.dart';
import '../../../models/vehicle.dart';
import 'tracking_detail_item.dart';

class TrackingDetailsCard extends StatelessWidget {
  final Vehicle? vehicle;
  final bool isTracking;
  final LatLng pos;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onRecenter;

  const TrackingDetailsCard({
    super.key,
    this.vehicle,
    required this.isTracking,
    required this.pos,
    required this.onStart,
    required this.onStop,
    required this.onRecenter,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 24,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.white20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    vehicle?.avatar ?? 'RA',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle?.driver ?? 'Rahul Ahmed',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${vehicle?.name ?? '---'} · ${vehicle?.number ?? '---'}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppColors.white50,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.signal_cellular_alt_rounded,
                      color: AppColors.success,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Strong',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TrackingDetailItem(
                  label: 'Speed',
                  value: isTracking
                      ? '${vehicle?.speed.toStringAsFixed(1)} km/h'
                      : '0 km/h',
                  color: AppColors.primaryLight,
                ),
                const SizedBox(width: 8),
                TrackingDetailItem(
                  label: 'Latitude',
                  value: '${pos.latitude.toStringAsFixed(4)}°',
                  color: AppColors.success,
                ),
                const SizedBox(width: 8),
                TrackingDetailItem(
                  label: 'Longitude',
                  value: '${pos.longitude.toStringAsFixed(4)}°',
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.white35,
                  size: 13,
                ),
                const SizedBox(width: 5),
                Text(
                  isTracking
                      ? 'Updating live coordinate feed'
                      : 'GPS simulation offline',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.white35,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: isTracking ? null : onStart,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: isTracking
                            ? AppColors.primary
                            : AppColors.white10,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Start',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: isTracking
                                  ? Colors.white
                                  : AppColors.white50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: !isTracking ? null : onStop,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: !isTracking
                            ? AppColors.error
                            : AppColors.white10,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.stop_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Stop',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: !isTracking
                                  ? Colors.white
                                  : AppColors.white50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onRecenter,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.white10,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.my_location_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
