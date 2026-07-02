import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../viewmodels/driver_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/app_router.dart';
import 'widgets/driver_stat_card.dart';
import 'widgets/driver_action_button.dart';
import 'widgets/driver_header.dart';
import 'widgets/current_vehicle_card.dart';

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dk = Theme.of(context).brightness == Brightness.dark;
    final bg = dk ? AppColors.darkBg : AppColors.lightBg;
    final card = dk ? AppColors.darkCard : AppColors.lightCard;
    final bdr = dk ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final tx = dk ? Colors.white : const Color(0xFF0F172A);
    final mt = dk ? AppColors.white50 : const Color(0xFF64748B);

    final authVm = context.watch<AuthViewModel>();
    final driverVm = context.watch<DriverViewModel>();
    final vehicle = driverVm.currentVehicle;

    final driverName = authVm.currentUserName ?? 'Driver';
    final initials = driverName.length >= 2
        ? driverName.substring(0, 2).toUpperCase()
        : 'DR';

    if (driverVm.driverName != driverName) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<DriverViewModel>().setDriverName(driverName);
      });
    }

    final hour = DateTime.now().hour;
    final String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else if (hour < 21) {
      greeting = 'Good evening';
    } else {
      greeting = 'Good night';
    }

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              DriverHeader(
                greeting: greeting,
                driverName: driverName,
                initials: initials,
                tx: tx,
                mt: mt,
                card: card,
                bdr: bdr,
              ),
              const SizedBox(height: 20),
              CurrentVehicleCard(
                vehicle: vehicle,
                isTracking: driverVm.isTracking,
                currentLocation: driverVm.currentLocation,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  DriverStatCard(
                    value: driverVm.isTracking ? '124 km' : '0 km',
                    label: 'Distance',
                    icon: Icons.route_outlined,
                    color: AppColors.primaryLight,
                    cardColor: card,
                    borderColor: bdr,
                    textColor: tx,
                    labelColor: mt,
                  ),
                  const SizedBox(width: 10),
                  DriverStatCard(
                    value: vehicle != null
                        ? (driverVm.isTracking ? 'Active' : 'Offline')
                        : '---',
                    label: 'Status',
                    icon: Icons.access_time_outlined,
                    color: AppColors.success,
                    cardColor: card,
                    borderColor: bdr,
                    textColor: tx,
                    labelColor: mt,
                  ),
                  const SizedBox(width: 10),
                  DriverStatCard(
                    value: driverVm.isTracking ? '1' : '0',
                    label: 'Trips',
                    icon: Icons.directions_outlined,
                    color: AppColors.warning,
                    cardColor: card,
                    borderColor: bdr,
                    textColor: tx,
                    labelColor: mt,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Quick Actions',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: tx,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (driverVm.isTracking || vehicle == null)
                          ? () {
                              if (vehicle == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please configure your vehicle details first.',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          : () => driverVm.startTracking(),
                      child: DriverActionButton(
                        label: 'Start Tracking',
                        icon: Icons.play_arrow_rounded,
                        gradient: (driverVm.isTracking || vehicle == null)
                            ? null
                            : const LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryLight,
                                ],
                              ),
                        color: (driverVm.isTracking || vehicle == null)
                            ? mt
                            : Colors.white,
                        cardColor: card,
                        borderColor: bdr,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: !driverVm.isTracking
                          ? null
                          : () => driverVm.stopTracking(),
                      child: DriverActionButton(
                        label: 'Stop',
                        icon: Icons.stop_rounded,
                        color: driverVm.isTracking ? AppColors.error : mt,
                        cardColor: card,
                        borderColor: bdr,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRouter.addVehicle),
                      child: DriverActionButton(
                        label: 'Configure',
                        icon: Icons.edit_outlined,
                        color: AppColors.primaryLight,
                        cardColor: card,
                        borderColor: bdr,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Today's Activity",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: tx,
                ),
              ),
              const SizedBox(height: 12),
              _buildActivityLogs(driverVm, card, bdr, tx, mt),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityLogs(
    DriverViewModel driverVm,
    Color card,
    Color bdr,
    Color tx,
    Color mt,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bdr),
      ),
      child: driverVm.activityLogs.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'No activity recorded today',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, color: mt),
                ),
              ),
            )
          : Column(
              children: List.generate(driverVm.activityLogs.length, (i) {
                final item = driverVm.activityLogs[i];
                final dc = item['type'] == 'start'
                    ? AppColors.success
                    : item['type'] == 'done'
                    ? AppColors.primaryLight
                    : AppColors.warning;
                return Container(
                  decoration: BoxDecoration(
                    border: i < driverVm.activityLogs.length - 1
                        ? Border(bottom: BorderSide(color: bdr))
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: dc,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['action']!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: tx,
                              ),
                            ),
                            Text(
                              item['location']!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: mt,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        item['time']!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: mt,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }
}
