import 'vehicle.dart';

class Driver {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String? vehicleId;
  final Vehicle? vehicle;

  const Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    this.vehicleId,
    this.vehicle,
  });

  Driver copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? vehicleId,
    Vehicle? vehicle,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicle: vehicle ?? this.vehicle,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'vehicleId': vehicleId,
      'vehicle': vehicle?.toJson(),
    };
  }

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? 'D',
      vehicleId: json['vehicleId'],
      vehicle: json['vehicle'] != null
          ? Vehicle.fromJson(json['vehicle'])
          : null,
    );
  }
}
