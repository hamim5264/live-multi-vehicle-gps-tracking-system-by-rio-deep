import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:http_cache_file_store/http_cache_file_store.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../constants/app_colors.dart';
import '../../../models/vehicle.dart';
import '../../widgets/vehicle_details_sheet.dart';
import 'map_button.dart';

class HomeMapCard extends StatelessWidget {
  final MapController mapController;
  final LatLng userLocation;
  final List<Vehicle> vehicles;
  final Directory? cacheDir;
  final int liveCount;
  final Color bdr;

  const HomeMapCard({
    super.key,
    required this.mapController,
    required this.userLocation,
    required this.vehicles,
    this.cacheDir,
    required this.liveCount,
    required this.bdr,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: bdr),
        ),
        child: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: userLocation,
                initialZoom: 14.0,
                maxZoom: 18.0,
                minZoom: 10.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.fleetlive.app',
                  tileProvider: cacheDir != null
                      ? CachedTileProvider(
                          store: FileCacheStore('${cacheDir!.path}/map_tiles'),
                        )
                      : NetworkTileProvider(),
                ),
                MarkerLayer(
                  markers: vehicles.map((v) {
                    final isActive = v.status == VehicleStatus.online;
                    return Marker(
                      point: LatLng(v.lat, v.lng),
                      width: 40.0,
                      height: 40.0,
                      child: GestureDetector(
                        onTap: () => VehicleDetailsSheet.show(context, v),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? AppColors.success
                                : AppColors.white35,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(v.type.mapIconAsset),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Column(
                children: [
                  MapButton(
                    icon: Icons.add_rounded,
                    onTap: () => mapController.move(
                      mapController.camera.center,
                      mapController.camera.zoom + 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  MapButton(
                    icon: Icons.remove_rounded,
                    onTap: () => mapController.move(
                      mapController.camera.center,
                      mapController.camera.zoom - 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  MapButton(
                    icon: Icons.my_location_rounded,
                    onTap: () async {
                      try {
                        final pos = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high,
                        );
                        mapController.move(
                          LatLng(pos.latitude, pos.longitude),
                          15.0,
                        );
                      } catch (_) {}
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '$liveCount vehicles live',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
