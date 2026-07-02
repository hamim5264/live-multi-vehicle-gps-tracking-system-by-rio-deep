import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum VehicleType {
  car,
  motorcycle,
  rickshaw,
  cng,
  deliveryVan,
  truck,
  other;

  String get displayName {
    switch (this) {
      case VehicleType.car:
        return 'Car';
      case VehicleType.motorcycle:
        return 'Motorcycle';
      case VehicleType.rickshaw:
        return 'Rickshaw';
      case VehicleType.cng:
        return 'CNG';
      case VehicleType.deliveryVan:
        return 'Delivery Van';
      case VehicleType.truck:
        return 'Truck';
      case VehicleType.other:
        return 'Other';
    }
  }

  String get mapIconAsset {
    switch (this) {
      case VehicleType.car:
        return 'assets/images/car.png';
      case VehicleType.motorcycle:
        return 'assets/images/motorcycle.png';
      case VehicleType.rickshaw:
        return 'assets/images/rickshaw.png';
      case VehicleType.cng:
        return 'assets/images/cng.png';
      case VehicleType.deliveryVan:
        return 'assets/images/delivery.png';
      case VehicleType.truck:
        return 'assets/images/delivery.png';
      case VehicleType.other:
        return 'assets/images/others.png';
    }
  }

  static VehicleType fromString(String val) {
    switch (val.toLowerCase()) {
      case 'car':
        return VehicleType.car;
      case 'motorcycle':
        return VehicleType.motorcycle;
      case 'rickshaw':
        return VehicleType.rickshaw;
      case 'cng':
        return VehicleType.cng;
      case 'delivery van':
      case 'delivery':
      case 'deliveryvan':
        return VehicleType.deliveryVan;
      case 'truck':
        return VehicleType.truck;
      default:
        return VehicleType.other;
    }
  }
}

enum VehicleStatus { online, offline, idle }

extension VehicleStatusX on VehicleStatus {
  String get label => name;

  Color get color {
    switch (this) {
      case VehicleStatus.online:
        return AppColors.success;
      case VehicleStatus.idle:
        return AppColors.warning;
      case VehicleStatus.offline:
        return AppColors.white35;
    }
  }

  Color get bgColor {
    switch (this) {
      case VehicleStatus.online:
        return AppColors.success.withValues(alpha: 0.15);
      case VehicleStatus.idle:
        return AppColors.warning.withValues(alpha: 0.15);
      case VehicleStatus.offline:
        return AppColors.white10;
    }
  }

  static VehicleStatus fromString(String val) {
    switch (val.toLowerCase()) {
      case 'online':
        return VehicleStatus.online;
      case 'idle':
        return VehicleStatus.idle;
      default:
        return VehicleStatus.offline;
    }
  }
}

class Vehicle {
  final String id;
  final String name;
  final String number;
  final VehicleType type;
  final double speed;
  final VehicleStatus status;
  final String distance;
  final String lastUpdated;
  final String driver;
  final String avatar;
  final double lat;
  final double lng;
  final String? photoBase64;
  final double rating;
  final int ratingCount;

  const Vehicle({
    required this.id,
    required this.name,
    required this.number,
    required this.type,
    required this.speed,
    required this.status,
    required this.distance,
    required this.lastUpdated,
    required this.driver,
    required this.avatar,
    required this.lat,
    required this.lng,
    this.photoBase64,
    this.rating = 0.0,
    this.ratingCount = 0,
  });

  Vehicle copyWith({
    String? id,
    String? name,
    String? number,
    VehicleType? type,
    double? speed,
    VehicleStatus? status,
    String? distance,
    String? lastUpdated,
    String? driver,
    String? avatar,
    double? lat,
    double? lng,
    String? photoBase64,
    double? rating,
    int? ratingCount,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      type: type ?? this.type,
      speed: speed ?? this.speed,
      status: status ?? this.status,
      distance: distance ?? this.distance,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      driver: driver ?? this.driver,
      avatar: avatar ?? this.avatar,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      photoBase64: photoBase64 ?? this.photoBase64,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'type': type.name,
      'speed': speed,
      'status': status.name,
      'distance': distance,
      'lastUpdated': lastUpdated,
      'driver': driver,
      'avatar': avatar,
      'lat': lat,
      'lng': lng,
      'photoBase64': photoBase64,
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      number: json['number'] ?? '',
      type: VehicleType.fromString(json['type'] ?? 'other'),
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      status: VehicleStatusX.fromString(json['status'] ?? 'offline'),
      distance: json['distance'] ?? '0 km',
      lastUpdated: json['lastUpdated'] ?? 'Just now',
      driver: json['driver'] ?? 'Unknown',
      avatar: json['avatar'] ?? 'U',
      lat: (json['lat'] as num?)?.toDouble() ?? 23.8103,
      lng: (json['lng'] as num?)?.toDouble() ?? 90.4125,
      photoBase64: json['photoBase64'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
    );
  }
}
