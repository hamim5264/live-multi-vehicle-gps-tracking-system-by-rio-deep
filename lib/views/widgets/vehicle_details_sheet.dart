import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';
import '../../models/vehicle.dart';
import '../../services/firebase_service.dart';
import 'package:provider/provider.dart';

class VehicleDetailsSheet extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailsSheet({super.key, required this.vehicle});

  static void show(BuildContext context, Vehicle v) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => VehicleDetailsSheet(vehicle: v),
  );

  Future<void> _openRoute(Vehicle v) async {
    final geoUri = Uri(
      scheme: 'geo',
      path: '${v.lat},${v.lng}',
      queryParameters: {
        'q': '${v.lat},${v.lng}(${Uri.encodeComponent(v.name)})',
      },
    );
    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri);
      return;
    }
    final mapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${v.lat},${v.lng}',
    );
    try {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(mapsUri, mode: LaunchMode.inAppBrowserView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _VehicleDetailsBody(vehicle: vehicle, onOpenRoute: _openRoute);
  }
}

class _VehicleDetailsBody extends StatefulWidget {
  final Vehicle vehicle;
  final Future<void> Function(Vehicle) onOpenRoute;

  const _VehicleDetailsBody({required this.vehicle, required this.onOpenRoute});

  @override
  State<_VehicleDetailsBody> createState() => _VehicleDetailsBodyState();
}

class _VehicleDetailsBodyState extends State<_VehicleDetailsBody> {
  double _selectedStars = 0;

  void _showRatingDialog() {
    double tempStars = _selectedStars;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: AppColors.darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Rate ${widget.vehicle.driver}',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How was your experience?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.white50,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final star = i + 1.0;
                  return GestureDetector(
                    onTap: () => setS(() => tempStars = star),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Icon(
                        tempStars >= star
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: tempStars >= star
                            ? AppColors.warning
                            : AppColors.white35,
                        size: 32,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(color: AppColors.white50),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: tempStars == 0
                  ? null
                  : () async {
                      Navigator.pop(ctx);
                      setState(() => _selectedStars = tempStars);
                      final svc = context.read<FirebaseService>();
                      final messenger = ScaffoldMessenger.of(context);
                      await svc.submitRating(widget.vehicle.id, tempStars);
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Rating submitted! ${tempStars.toInt()} star${tempStars > 1 ? 's' : ''}',
                            style: GoogleFonts.plusJakartaSans(),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
              child: Text(
                'Submit',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.vehicle;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.white20,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white10,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    v.avatar,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
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
                        v.driver,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Driver',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.white50,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Feature coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.phone_outlined,
                      color: AppColors.success,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A5F),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: v.photoBase64 != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.memory(
                          base64Decode(v.photoBase64!),
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.local_shipping_outlined,
                        color: AppColors.primaryLight,
                        size: 24,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${v.number} · ${v.type.displayName}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.white50,
                      ),
                    ),
                  ],
                ),
              ),
              if (v.ratingCount > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.warning,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          v.rating.toStringAsFixed(1),
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '(${v.ratingCount})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: AppColors.white50,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Stat(
                label: 'Speed',
                value: '${v.speed.toInt()} km/h',
                color: AppColors.primaryLight,
              ),
              const SizedBox(width: 8),
              _Stat(
                label: 'Status',
                value: v.status.label,
                color: v.status.color,
              ),
              const SizedBox(width: 8),
              _Stat(
                label: 'Updated',
                value: v.lastUpdated,
                color: AppColors.warning,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => widget.onOpenRoute(v),
                  icon: const Icon(Icons.route_outlined, size: 18),
                  label: const Text('View Route'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showRatingDialog,
                  icon: Icon(
                    _selectedStars > 0
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 18,
                    color: AppColors.warning,
                  ),
                  label: Text(
                    _selectedStars > 0
                        ? 'Rated ${_selectedStars.toInt()}★'
                        : 'Rate Driver',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      color: AppColors.warning,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.warning),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final Color color;

  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext c) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: AppColors.white50,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
