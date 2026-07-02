import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../firebase_options.dart';
import '../models/vehicle.dart';

class FirebaseService {
  bool _isFirebaseInitialized = false;

  final Map<String, Vehicle> _localVehicles = {};
  final _vehiclesController = StreamController<List<Vehicle>>.broadcast();
  StreamSubscription? _firebaseSubscription;

  FirebaseService() {
    _emitVehicles();
  }

  bool get isFirebaseInitialized => _isFirebaseInitialized;

  void initializeLocalFallback() {
    _isFirebaseInitialized = false;
    debugPrint("FirebaseService: Running in Local Simulation Mode");
    _emitVehicles();
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isFirebaseInitialized = true;
      debugPrint("FirebaseService: Real Firebase Initialized");

      _firebaseSubscription = FirebaseDatabase.instance.ref().onValue.listen((
        event,
      ) {
        final data = event.snapshot.value;
        if (data is Map) {
          _localVehicles.clear();

          if (data.containsKey('vehicles')) {
            final vehiclesData = data['vehicles'];
            if (vehiclesData is Map) {
              vehiclesData.forEach((key, val) {
                if (val is Map) {
                  final vehicle = Vehicle.fromJson(
                    Map<String, dynamic>.from(val),
                  );
                  _localVehicles[vehicle.id] = vehicle;
                }
              });
            }
          }

          if (data.containsKey('driver') &&
              data.containsKey('number') &&
              data.containsKey('name')) {
            final vehicle = Vehicle.fromJson(Map<String, dynamic>.from(data));
            _localVehicles[vehicle.id] = vehicle;
          }

          _emitVehicles();
        }
      });
    } catch (e) {
      debugPrint(
        "Firebase initialization failed: $e. Falling back to local simulator.",
      );
      initializeLocalFallback();
    }
  }

  Stream<List<Vehicle>> getVehiclesStream() {
    return _vehiclesController.stream;
  }

  List<Vehicle> getVehicles() {
    return _localVehicles.values.toList();
  }

  Future<void> registerVehicle(Vehicle vehicle) async {
    _localVehicles[vehicle.id] = vehicle;
    _emitVehicles();

    if (_isFirebaseInitialized) {
      await FirebaseDatabase.instance
          .ref('vehicles/${vehicle.id}')
          .set(vehicle.toJson());
    }
  }

  Future<void> updateVehicleLocation(
    String id,
    double lat,
    double lng,
    double speed,
  ) async {
    if (_localVehicles.containsKey(id)) {
      final updated = _localVehicles[id]!.copyWith(
        lat: lat,
        lng: lng,
        speed: speed,
        lastUpdated: 'Just now',
        status: VehicleStatus.online,
      );
      _localVehicles[id] = updated;
      _emitVehicles();

      if (_isFirebaseInitialized) {
        await FirebaseDatabase.instance.ref('vehicles/$id').update({
          'lat': lat,
          'lng': lng,
          'speed': speed,
          'lastUpdated': 'Just now',
          'status': 'online',
        });
      }
    }
  }

  Future<void> updateVehicleStatus(String id, VehicleStatus status) async {
    if (_localVehicles.containsKey(id)) {
      final updated = _localVehicles[id]!.copyWith(
        status: status,
        lastUpdated: 'Just now',
        speed: status == VehicleStatus.offline
            ? 0.0
            : _localVehicles[id]!.speed,
      );
      _localVehicles[id] = updated;
      _emitVehicles();

      if (_isFirebaseInitialized) {
        await FirebaseDatabase.instance.ref('vehicles/$id').update({
          'status': status.name,
          'speed': status == VehicleStatus.offline ? 0.0 : updated.speed,
        });
      }
    }
  }

  Future<void> submitRating(String vehicleId, double newStar) async {
    if (!_localVehicles.containsKey(vehicleId)) return;
    final v = _localVehicles[vehicleId]!;
    final newCount = v.ratingCount + 1;
    final newRating = ((v.rating * v.ratingCount) + newStar) / newCount;
    final updated = v.copyWith(rating: newRating, ratingCount: newCount);
    _localVehicles[vehicleId] = updated;
    _emitVehicles();
    if (_isFirebaseInitialized) {
      await FirebaseDatabase.instance.ref('vehicles/$vehicleId').update({
        'rating': newRating,
        'ratingCount': newCount,
      });
    }
  }

  void _emitVehicles() {
    _vehiclesController.add(_localVehicles.values.toList());
  }

  void refresh() => _emitVehicles();

  void dispose() {
    _firebaseSubscription?.cancel();
    _vehiclesController.close();
  }
}
