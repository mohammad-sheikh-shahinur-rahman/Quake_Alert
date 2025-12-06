import 'dart:convert';
import 'package:latlong2/latlong.dart';

class AlertZone {
  final String id;
  final String name;
  final LatLng center;
  final double radius; // in kilometers

  AlertZone({
    required this.id,
    required this.name,
    required this.center,
    required this.radius,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lat': center.latitude,
      'lng': center.longitude,
      'radius': radius,
    };
  }

  factory AlertZone.fromMap(Map<String, dynamic> map) {
    return AlertZone(
      id: map['id'] as String,
      name: map['name'] as String,
      center: LatLng(map['lat'] as double, map['lng'] as double),
      radius: map['radius'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlertZone.fromJson(String source) =>
      AlertZone.fromMap(json.decode(source) as Map<String, dynamic>);
}