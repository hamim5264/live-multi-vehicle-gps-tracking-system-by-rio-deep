import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
enum VehicleStatus { online, offline, idle }
extension VehicleStatusX on VehicleStatus {
  String get label => name;
  Color get color { switch(this){ case VehicleStatus.online: return AppColors.success; case VehicleStatus.idle: return AppColors.warning; case VehicleStatus.offline: return AppColors.white35; } }
  Color get bgColor { switch(this){ case VehicleStatus.online: return AppColors.success.withValues(alpha:0.15); case VehicleStatus.idle: return AppColors.warning.withValues(alpha:0.15); case VehicleStatus.offline: return AppColors.white10; } }
}
class Vehicle {
  final String id,name,number,type,distance,lastUpdated,driver,avatar;
  final double speed,lat,lng;
  final VehicleStatus status;
  const Vehicle({required this.id,required this.name,required this.number,required this.type,required this.speed,required this.status,required this.distance,required this.lastUpdated,required this.driver,required this.avatar,this.lat=23.8103,this.lng=90.4125});
}
