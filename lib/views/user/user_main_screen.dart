import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../viewmodels/user_viewmodel.dart';
import 'user_home_screen.dart';
import 'vehicle_list_screen.dart';
import 'user_profile_screen.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _S();
}

class _S extends State<UserMainScreen> {
  int _i = 0;
  final _s = const [UserHomeScreen(), VehicleListScreen(), UserProfileScreen()];

  Future<bool?> _showExitDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        final dk = Theme.of(context).brightness == Brightness.dark;
        final card = dk ? const Color(0xFF1E293B) : Colors.white;
        final tx = dk ? Colors.white : const Color(0xFF0F172A);
        return AlertDialog(
          backgroundColor: card,
          title: Text(
            'Exit App',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              color: tx,
            ),
          ),
          content: Text(
            'Are you sure you want to exit FleetLive?',
            style: GoogleFonts.plusJakartaSans(color: tx),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'No',
                style: GoogleFonts.plusJakartaSans(color: AppColors.primary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Yes',
                style: GoogleFonts.plusJakartaSans(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext c) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) async {
      if (didPop) return;
      final shouldExit = await _showExitDialog(c);
      if (shouldExit ?? false) {
        SystemNavigator.pop();
      }
    },
    child: Scaffold(
      body: IndexedStack(index: _i, children: _s),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(c).brightness == Brightness.dark
              ? AppColors.darkCard
              : AppColors.lightCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(c).brightness == Brightness.dark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: NavigationBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedIndex: _i,
            onDestinationSelected: (i) {
              setState(() => _i = i);
              c.read<UserViewModel>().refresh();
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.directions_car_outlined),
                selectedIcon: Icon(Icons.directions_car_rounded),
                label: 'Vehicles',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outlined),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
