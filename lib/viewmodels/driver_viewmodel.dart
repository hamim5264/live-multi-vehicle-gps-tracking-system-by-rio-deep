import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/vehicle.dart';
import '../services/firebase_service.dart';
import '../services/simulation_service.dart';
import 'package:geolocator/geolocator.dart';

class DriverViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService;
  final SimulationService _simulationService = SimulationService();

  String? _driverName;
  Vehicle? _currentVehicle;
  bool _isTracking = false;
  LatLng _currentLocation = const LatLng(23.8103, 90.4125);
  StreamSubscription? _locationSubscription;
  StreamSubscription<List<Vehicle>>? _vehiclesSubscription;

  DriverViewModel(this._firebaseService) {
    _vehiclesSubscription = _firebaseService.getVehiclesStream().listen((
      vehicles,
    ) {
      if (_driverName != null) {
        try {
          _currentVehicle = vehicles.firstWhere((v) => v.driver == _driverName);
          if (!_isTracking) {
            _currentLocation = LatLng(
              _currentVehicle!.lat,
              _currentVehicle!.lng,
            );
          }
        } catch (_) {
          _currentVehicle = null;
        }
        notifyListeners();
      }
    });
  }

  String? get driverName => _driverName;

  Vehicle? get currentVehicle => _currentVehicle;

  bool get isTracking => _isTracking;

  LatLng get currentLocation => _currentLocation;

  void setDriverName(String name) {
    if (_driverName == name) return;
    _driverName = name;

    final vehicles = _firebaseService.getVehicles();
    try {
      _currentVehicle = vehicles.firstWhere((v) => v.driver == name);
      _currentLocation = LatLng(_currentVehicle!.lat, _currentVehicle!.lng);
    } catch (_) {
      _currentVehicle = null;
    }
    notifyListeners();
  }

  Future<void> registerOrUpdateVehicle({
    required String name,
    required String number,
    required VehicleType type,
    String? photoBase64,
  }) async {
    final activeDriverName = _driverName ?? 'FleetLive Driver';
    final initials = activeDriverName.length >= 2
        ? activeDriverName.substring(0, 2).toUpperCase()
        : 'DR';

    final vehicle = Vehicle(
      id:
          _currentVehicle?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      number: number,
      type: type,
      speed: _isTracking ? 65.0 : 0.0,
      status: _isTracking ? VehicleStatus.online : VehicleStatus.offline,
      distance: _currentVehicle?.distance ?? '0 km',
      lastUpdated: 'Just now',
      driver: activeDriverName,
      avatar: initials,
      lat: _currentLocation.latitude,
      lng: _currentLocation.longitude,
      photoBase64: photoBase64 ?? _currentVehicle?.photoBase64,
    );

    _currentVehicle = vehicle;
    await _firebaseService.registerVehicle(vehicle);
    notifyListeners();
  }

  final List<Map<String, String>> _activityLogs = [];

  List<Map<String, String>> get activityLogs => _activityLogs;

  void _addActivityLog(String action, String location, String type) {
    final now = DateTime.now();
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    _activityLogs.insert(0, {
      'time': timeStr,
      'action': action,
      'location': location,
      'type': type,
    });
    notifyListeners();
  }

  Future<void> startTracking() async {
    if (_isTracking || _currentVehicle == null) return;
    _isTracking = true;

    _firebaseService.updateVehicleStatus(
      _currentVehicle!.id,
      VehicleStatus.online,
    );

    bool useGPS = false;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          useGPS = true;
        }
      }
    } catch (_) {}

    if (useGPS) {
      _addActivityLog('Tracking started (GPS)', 'Live GPS Coordinate', 'start');
      _locationSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 5,
            ),
          ).listen(
            (Position position) {
              final newPos = LatLng(position.latitude, position.longitude);
              _currentLocation = newPos;
              double speedKmH = position.speed * 3.6;
              if (speedKmH < 0) speedKmH = 0;

              _firebaseService.updateVehicleLocation(
                _currentVehicle!.id,
                newPos.latitude,
                newPos.longitude,
                speedKmH,
              );
              _currentVehicle = _currentVehicle!.copyWith(
                lat: newPos.latitude,
                lng: newPos.longitude,
                speed: speedKmH,
                status: VehicleStatus.online,
              );
              notifyListeners();
            },
            onError: (err) {
              debugPrint('Geolocator stream error: $err');
            },
          );
    } else {
      _addActivityLog(
        'Tracking started (Simulated)',
        'Tejgaon, Dhaka',
        'start',
      );
      _simulationService.startSimulation();
      _locationSubscription = _simulationService.locationStream.listen((
        LatLng newPos,
      ) {
        _currentLocation = newPos;
        double currentSpeed = 45.0 + (newPos.latitude * 100) % 25;
        _firebaseService.updateVehicleLocation(
          _currentVehicle!.id,
          newPos.latitude,
          newPos.longitude,
          currentSpeed,
        );
        _currentVehicle = _currentVehicle!.copyWith(
          lat: newPos.latitude,
          lng: newPos.longitude,
          speed: currentSpeed,
          status: VehicleStatus.online,
        );
        notifyListeners();
      });
    }

    notifyListeners();
  }

  void stopTracking() {
    if (!_isTracking || _currentVehicle == null) return;
    _isTracking = false;

    _locationSubscription?.cancel();
    _locationSubscription = null;
    _simulationService.stopSimulation();

    _firebaseService.updateVehicleStatus(
      _currentVehicle!.id,
      VehicleStatus.offline,
    );
    _addActivityLog('Tracking stopped', 'Dhanmondi, Dhaka', 'done');
    _currentVehicle = _currentVehicle!.copyWith(
      status: VehicleStatus.offline,
      speed: 0.0,
    );
    notifyListeners();
  }

  void refresh() {
    final vehicles = _firebaseService.getVehicles();
    if (_driverName != null) {
      try {
        _currentVehicle = vehicles.firstWhere((v) => v.driver == _driverName);
        if (!_isTracking) {
          _currentLocation = LatLng(_currentVehicle!.lat, _currentVehicle!.lng);
        }
      } catch (_) {
        _currentVehicle = null;
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _vehiclesSubscription?.cancel();
    _locationSubscription?.cancel();
    _simulationService.dispose();
    super.dispose();
  }
}
