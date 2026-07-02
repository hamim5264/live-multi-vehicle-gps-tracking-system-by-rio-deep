import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../../../constants/app_colors.dart';
import '../../../models/vehicle.dart';

class CurrentVehicleCard extends StatelessWidget {
  final Vehicle? vehicle;
  final bool isTracking;
  final LatLng currentLocation;

  const CurrentVehicleCard({
    super.key,
    this.vehicle,
    required this.isTracking,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A6E), Color(0xFF162D52)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Vehicle',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.white50,
                      ),
                    ),
                    Text(
                      vehicle?.name ?? 'No Vehicle Configured',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      vehicle != null
                          ? '${vehicle!.number} · ${vehicle!.type.displayName}'
                          : "Tap 'Configure' to register vehicle info",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.white50,
                      ),
                    ),
                  ],
                ),
              ),
              if (vehicle != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: (isTracking ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.2),
                    border: Border.all(
                      color: (isTracking ? AppColors.success : AppColors.error)
                          .withValues(alpha: 0.4),
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isTracking
                              ? AppColors.success
                              : AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isTracking ? 'Active' : 'Offline',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isTracking
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.local_shipping_outlined,
                color: AppColors.white20,
                size: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: isTracking ? 0.75 : 0.0,
                        backgroundColor: AppColors.white20,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.primaryLight,
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isTracking
                          ? 'Route progress: 75%'
                          : 'Tracking not started',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: AppColors.white35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.white50,
                size: 13,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  isTracking
                      ? 'Dhaka · ${currentLocation.latitude.toStringAsFixed(4)}°N, ${currentLocation.longitude.toStringAsFixed(4)}°E'
                      : vehicle != null
                      ? 'Dhaka · ${vehicle!.lat.toStringAsFixed(4)}°N, ${vehicle!.lng.toStringAsFixed(4)}°E (Last known)'
                      : 'No coordinates streams active',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.white50,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
