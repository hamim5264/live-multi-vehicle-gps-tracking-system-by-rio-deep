import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:http_cache_file_store/http_cache_file_store.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../viewmodels/driver_viewmodel.dart';
import 'widgets/tracking_header.dart';
import 'widgets/speedometer_overlay.dart';
import 'widgets/tracking_details_card.dart';

class DriverTrackingScreen extends StatefulWidget {
  const DriverTrackingScreen({super.key});

  @override
  State<DriverTrackingScreen> createState() => _DriverTrackingScreenState();
}

class _DriverTrackingScreenState extends State<DriverTrackingScreen> {
  final MapController _mapController = MapController();
  Directory? _cacheDir;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _initCacheDir();
    _requestLocationPermission();
  }

  Future<void> _initCacheDir() async {
    try {
      final dir = await getTemporaryDirectory();
      if (mounted) {
        setState(() => _cacheDir = dir);
      }
    } catch (e) {
      debugPrint('Error getting cache dir: $e');
      if (mounted) setState(() {});
    }
  }

  Future<void> _requestLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    } catch (e) {
      debugPrint('Error requesting location permission: $e');
    }
  }

  void _safeMove(LatLng pos) {
    if (_mapReady) {
      try {
        _mapController.move(pos, _mapController.camera.zoom);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final driverVm = context.watch<DriverViewModel>();
    final isTracking = driverVm.isTracking;
    final pos = driverVm.currentLocation;
    final vehicle = driverVm.currentVehicle;

    if (isTracking && _mapReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _safeMove(pos));
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: pos,
              initialZoom: 15.0,
              maxZoom: 18.0,
              minZoom: 12.0,
              onMapReady: () {
                setState(() => _mapReady = true);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.fleetlive.app',
                tileProvider: _cacheDir != null
                    ? CachedTileProvider(
                        store: FileCacheStore('${_cacheDir!.path}/map_tiles'),
                      )
                    : NetworkTileProvider(),
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: const [
                      LatLng(23.8103, 90.4125),
                      LatLng(23.8120, 90.4135),
                      LatLng(23.8145, 90.4140),
                      LatLng(23.8160, 90.4162),
                      LatLng(23.8185, 90.4178),
                      LatLng(23.8190, 90.4150),
                      LatLng(23.8170, 90.4110),
                      LatLng(23.8140, 90.4095),
                      LatLng(23.8120, 90.4080),
                      LatLng(23.8100, 90.4100),
                    ],
                    strokeWidth: 4,
                    color: AppColors.primary.withValues(alpha: 0.8),
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: pos,
                    width: 60.0,
                    height: 60.0,
                    child: _buildTrackingMarker(isTracking, vehicle),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TrackingHeader(isTracking: isTracking),
          ),
          SpeedometerOverlay(
            isTracking: isTracking,
            speed: vehicle?.speed ?? 0,
          ),
          TrackingDetailsCard(
            vehicle: vehicle,
            isTracking: isTracking,
            pos: pos,
            onStart: () => driverVm.startTracking(),
            onStop: () => driverVm.stopTracking(),
            onRecenter: () => _safeMove(pos),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingMarker(bool isTracking, dynamic vehicle) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isTracking)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Container(
                width: 20 + value * 30,
                height: 20 + value * 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 1.0 - value),
                ),
              );
            },
          ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Image.asset(
            vehicle?.type.mapIconAsset ?? 'assets/images/others.png',
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }
}
