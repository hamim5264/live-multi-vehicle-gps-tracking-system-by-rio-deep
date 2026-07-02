import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/vehicle.dart';
import '../widgets/vehicle_details_sheet.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'widgets/user_home_stat_card.dart';
import 'widgets/home_header.dart';
import 'widgets/category_selector.dart';
import 'widgets/home_map_card.dart';
import 'widgets/nearby_vehicle_card.dart';
import 'vehicle_list_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final MapController _mapController = MapController();
  Directory? _cacheDir;
  LatLng _userLocation = const LatLng(23.8103, 90.4125); // Default: Dhaka

  @override
  void initState() {
    super.initState();
    _initCacheDir();
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      LocationPermission granted = permission;
      if (permission == LocationPermission.denied) {
        granted = await Geolocator.requestPermission();
      }
      if (granted == LocationPermission.deniedForever) return;
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          _userLocation = LatLng(pos.latitude, pos.longitude);
        });
        _mapController.move(_userLocation, 14.0);
      }
    } catch (e) {
      debugPrint('Could not get user location: $e');
    }
  }

  Future<void> _initCacheDir() async {
    try {
      final dir = await getTemporaryDirectory();
      if (mounted) {
        setState(() => _cacheDir = dir);
      }
    } catch (e) {
      debugPrint('Error getting cache dir: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dk = Theme.of(context).brightness == Brightness.dark;
    final bg = dk ? AppColors.darkBg : AppColors.lightBg;
    final card = dk ? AppColors.darkCard : AppColors.lightCard;
    final bdr = dk ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final tx = dk ? Colors.white : const Color(0xFF0F172A);
    final mt = dk ? AppColors.white50 : const Color(0xFF64748B);

    final userVm = context.watch<UserViewModel>();
    final shown = userVm.vehicles;
    final liveCount = userVm.allVehicles
        .where((v) => v.status == VehicleStatus.online)
        .length;
    final categories = [
      'All',
      'Car',
      'Motorcycle',
      'Rickshaw',
      'CNG',
      'Delivery Van',
      'Truck',
    ];

    final authVm = context.watch<AuthViewModel>();
    final userName = authVm.currentUserName ?? 'Sara Islam';
    final initials = userName.length >= 2
        ? userName.substring(0, 2).toUpperCase()
        : 'US';
    final totalVehicles = userVm.allVehicles.length;
    final deliveriesCount = userVm.allVehicles
        .where(
          (v) =>
              v.type == VehicleType.deliveryVan || v.type == VehicleType.truck,
        )
        .length;
    final liveDeliveries = userVm.allVehicles
        .where(
          (v) =>
              (v.type == VehicleType.deliveryVan ||
                  v.type == VehicleType.truck) &&
              v.status == VehicleStatus.online,
        )
        .length;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            userVm.refresh();
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    children: [
                      HomeHeader(
                        userName: userName,
                        initials: initials,
                        tx: tx,
                        mt: mt,
                        card: card,
                        bdr: bdr,
                      ),
                      const SizedBox(height: 16),
                      CategorySelector(
                        categories: categories,
                        selectedCategory: userVm.selectedCategory,
                        onCategorySelected: (c) => userVm.selectCategory(c),
                        isDark: dk,
                        bdr: bdr,
                        mt: mt,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          UserHomeStatCard(
                            value: totalVehicles.toString(),
                            label: 'Active Vehicles',
                            change: '+$liveCount',
                            color: AppColors.primaryLight,
                            cardColor: card,
                            borderColor: bdr,
                            textColor: tx,
                            labelColor: mt,
                          ),
                          const SizedBox(width: 10),
                          UserHomeStatCard(
                            value: liveCount.toString(),
                            label: 'Online Drivers',
                            change: '+$liveCount',
                            color: AppColors.success,
                            cardColor: card,
                            borderColor: bdr,
                            textColor: tx,
                            labelColor: mt,
                          ),
                          const SizedBox(width: 10),
                          UserHomeStatCard(
                            value: deliveriesCount.toString(),
                            label: 'Deliveries',
                            change: '+$liveDeliveries',
                            color: AppColors.warning,
                            cardColor: card,
                            borderColor: bdr,
                            textColor: tx,
                            labelColor: mt,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      HomeMapCard(
                        mapController: _mapController,
                        userLocation: _userLocation,
                        vehicles: shown,
                        cacheDir: _cacheDir,
                        liveCount: liveCount,
                        bdr: bdr,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Nearby Vehicles',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: tx,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const VehicleListScreen(),
                              ),
                            ),
                            child: Text(
                              'View all →',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((ctx, i) {
                    final v = shown[i];
                    return NearbyVehicleCard(
                      vehicle: v,
                      card: card,
                      bdr: bdr,
                      tx: tx,
                      mt: mt,
                      onTap: () {
                        userVm.selectVehicle(v);
                        _mapController.move(LatLng(v.lat, v.lng), 14.5);
                        VehicleDetailsSheet.show(context, v);
                      },
                    );
                  }, childCount: shown.length),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
