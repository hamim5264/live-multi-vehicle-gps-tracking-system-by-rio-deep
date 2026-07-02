import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_theme.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/driver_viewmodel.dart';
import '../role_selection_screen.dart';
import '../privacy_policy_screen.dart';
import '../help_support_screen.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_item.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  bool _n = true;

  @override
  Widget build(BuildContext context) {
    final dk = Theme.of(context).brightness == Brightness.dark;
    final bg = dk ? AppColors.darkBg : AppColors.lightBg;
    final card = dk ? AppColors.darkCard : AppColors.lightCard;
    final bdr = dk ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final tx = dk ? Colors.white : const Color(0xFF0F172A);
    final mt = dk ? AppColors.white50 : const Color(0xFF64748B);
    final idark = themeModeNotifier.value == ThemeMode.dark;

    final authVm = context.watch<AuthViewModel>();
    final driverVm = context.watch<DriverViewModel>();
    final driverName = authVm.currentUserName ?? 'Rahul Ahmed';
    final driverEmail = authVm.currentUserEmail ?? 'rahul@fleetlive.com';

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              userName: driverName,
              userEmail: driverEmail,
              role: 'Driver',
              onEditName: () => _showEditNameDialog(context, driverName),
              isDark: dk,
              tx: tx,
              mt: mt,
            ),
            _buildStatsRow(card, bdr, tx, mt, driverVm),
            _buildMyVehicleSection(card, bdr, tx, mt, driverVm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: tx,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: bdr),
                    ),
                    child: Column(
                      children: [
                        SettingsItem(
                          icon: idark
                              ? Icons.wb_sunny_outlined
                              : Icons.dark_mode_outlined,
                          label: 'Dark Mode',
                          mt: mt,
                          tx: tx,
                          bdr: bdr,
                          trailing: Switch.adaptive(
                            value: idark,
                            onChanged: (_) {
                              final newTheme = idark
                                  ? ThemeMode.light
                                  : ThemeMode.dark;
                              themeModeNotifier.value = newTheme;
                              SharedPreferences.getInstance().then(
                                (p) => p.setString(
                                  'theme_mode',
                                  newTheme == ThemeMode.dark ? 'dark' : 'light',
                                ),
                              );
                              setState(() {});
                            },
                          ),
                        ),
                        Divider(height: 1, color: bdr),
                        SettingsItem(
                          icon: Icons.notifications_outlined,
                          label: 'Notifications',
                          mt: mt,
                          tx: tx,
                          bdr: bdr,
                          trailing: Switch.adaptive(
                            value: _n,
                            onChanged: (_) => setState(() => _n = !_n),
                          ),
                        ),
                        Divider(height: 1, color: bdr),
                        SettingsItem(
                          icon: Icons.shield_outlined,
                          label: 'Privacy & Security',
                          mt: mt,
                          tx: tx,
                          bdr: bdr,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PrivacyPolicyScreen(),
                            ),
                          ),
                        ),
                        Divider(height: 1, color: bdr),
                        SettingsItem(
                          icon: Icons.help_outline_rounded,
                          label: 'Help & Support',
                          mt: mt,
                          tx: tx,
                          bdr: bdr,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const HelpSupportScreen(),
                            ),
                          ),
                        ),
                        Divider(height: 1, color: bdr),
                        SettingsItem(
                          icon: Icons.settings_outlined,
                          label: 'App Settings',
                          mt: mt,
                          tx: tx,
                          bdr: bdr,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Feature coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSignOutButton(context, authVm),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(
    Color card,
    Color bdr,
    Color tx,
    Color mt,
    DriverViewModel driverVm,
  ) {
    final vehicle = driverVm.currentVehicle;
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: bdr),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              for (final s in [
                (
                  vehicle != null ? (driverVm.isTracking ? '1' : '0') : '0',
                  'Trips',
                ),
                (
                  vehicle != null ? (driverVm.isTracking ? '124' : '0') : '0',
                  'km Driven',
                ),
                (
                  vehicle != null
                      ? (vehicle.ratingCount > 0
                            ? '${vehicle.rating.toStringAsFixed(1)}★'
                            : '0.0★')
                      : '---',
                  'Rating',
                ),
              ])
                Expanded(
                  child: Container(
                    decoration: s.$2 != 'Rating'
                        ? BoxDecoration(
                            border: Border(right: BorderSide(color: bdr)),
                          )
                        : null,
                    child: Column(
                      children: [
                        Text(
                          s.$1,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: tx,
                          ),
                        ),
                        Text(
                          s.$2,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: mt,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyVehicleSection(
    Color card,
    Color bdr,
    Color tx,
    Color mt,
    DriverViewModel driverVm,
  ) {
    final vehicle = driverVm.currentVehicle;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Vehicle',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: tx,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
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
                  child: const Icon(
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
                        vehicle?.name ?? 'No vehicle configure',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: tx,
                        ),
                      ),
                      Text(
                        '${vehicle?.number ?? '---'} · ${vehicle?.type.displayName ?? '---'}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: mt,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (driverVm.isTracking
                                ? AppColors.success
                                : AppColors.white35)
                            .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    driverVm.isTracking ? 'Active' : 'Offline',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: driverVm.isTracking ? AppColors.success : mt,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context, AuthViewModel authVm) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          authVm.logout();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
            (_) => false,
          );
        },
        icon: const Icon(
          Icons.logout_rounded,
          color: AppColors.error,
          size: 18,
        ),
        label: Text(
          'Sign Out',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            color: AppColors.error,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) {
        final dk = Theme.of(context).brightness == Brightness.dark;
        final card = dk ? AppColors.darkCard : Colors.white;
        final tx = dk ? Colors.white : const Color(0xFF0F172A);
        return AlertDialog(
          backgroundColor: card,
          title: Text(
            'Edit Name',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              color: tx,
            ),
          ),
          content: TextField(
            controller: controller,
            style: GoogleFonts.plusJakartaSans(color: tx),
            decoration: InputDecoration(
              hintText: 'Enter name',
              hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(color: AppColors.error),
              ),
            ),
            TextButton(
              onPressed: () async {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  final authVm = context.read<AuthViewModel>();
                  final driverVm = context.read<DriverViewModel>();
                  Navigator.pop(context);
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await user.updateDisplayName(newName);
                    authVm.updateUserName(newName);

                    driverVm.setDriverName(newName);

                    if (driverVm.currentVehicle != null) {
                      await driverVm.registerOrUpdateVehicle(
                        name: driverVm.currentVehicle!.name,
                        number: driverVm.currentVehicle!.number,
                        type: driverVm.currentVehicle!.type,
                        photoBase64: driverVm.currentVehicle!.photoBase64,
                      );
                    }
                  }
                }
              },
              child: Text(
                'Save',
                style: GoogleFonts.plusJakartaSans(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
