import 'dart:async';
import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/firebase_service.dart';

class UserViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService;

  List<Vehicle> _allVehicles = [];
  List<Vehicle> _filteredVehicles = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  Vehicle? _selectedVehicle;
  StreamSubscription<List<Vehicle>>? _vehiclesSubscription;

  UserViewModel(this._firebaseService) {
    _allVehicles = _firebaseService.getVehicles();
    _filteredVehicles = List.from(_allVehicles);

    _vehiclesSubscription = _firebaseService.getVehiclesStream().listen((
      vehiclesList,
    ) {
      _allVehicles = vehiclesList;
      _applyFilterAndSearch();

      if (_selectedVehicle != null) {
        final updatedIndex = vehiclesList.indexWhere(
          (v) => v.id == _selectedVehicle!.id,
        );
        if (updatedIndex != -1) {
          _selectedVehicle = vehiclesList[updatedIndex];
        }
      }
      notifyListeners();
    });
  }

  List<Vehicle> get vehicles => _filteredVehicles;

  List<Vehicle> get allVehicles => _allVehicles;

  String get selectedCategory => _selectedCategory;

  Vehicle? get selectedVehicle => _selectedVehicle;

  String get searchQuery => _searchQuery;

  void selectCategory(String category) {
    _selectedCategory = category;
    _applyFilterAndSearch();
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilterAndSearch();
    notifyListeners();
  }

  void selectVehicle(Vehicle? vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }

  void _applyFilterAndSearch() {
    _filteredVehicles = _allVehicles.where((vehicle) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          vehicle.type.displayName.toLowerCase() ==
              _selectedCategory.toLowerCase() ||
          (_selectedCategory == 'CNG' && vehicle.type == VehicleType.cng);

      final matchesSearch =
          _searchQuery.isEmpty ||
          vehicle.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          vehicle.driver.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          vehicle.number.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void refresh() {
    _allVehicles = _firebaseService.getVehicles();
    _applyFilterAndSearch();
    notifyListeners();
  }

  @override
  void dispose() {
    _vehiclesSubscription?.cancel();
    super.dispose();
  }
}
