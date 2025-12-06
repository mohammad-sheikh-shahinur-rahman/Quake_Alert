class Earthquake {
  final String id;
  final double magnitude;
  final double depth;
  final double lat;
  final double lng;
  final DateTime time;
  final String place;
  final String url;
  final int tsunami;
  final int? felt;
  final String status;
  final String type;

  const Earthquake({
    required this.id,
    required this.magnitude,
    required this.depth,
    required this.lat,
    required this.lng,
    required this.time,
    required this.place,
    required this.url,
    required this.tsunami,
    this.felt,
    required this.status,
    required this.type,
  });

  factory Earthquake.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'] as Map<String, dynamic>?;
    final geometry = json['geometry'] as Map<String, dynamic>?;
    final coords = geometry?['coordinates'] as List?;

    // Helper to safely convert any value to double
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        return parsed ?? 0.0;
      }
      return 0.0;
    }

    return Earthquake(
      id: json['id'] as String? ?? 'unknown',
      magnitude: toDouble(properties?['mag']),
      depth: toDouble(coords?[2]),
      lat: toDouble(coords?[1]),
      lng: toDouble(coords?[0]),
      time: DateTime.fromMillisecondsSinceEpoch(
        (properties?['time'] as int?) ?? 0,
      ),
      place: properties?['place'] as String? ?? 'অজানা স্থান',
      url: properties?['url'] as String? ?? '',
      tsunami: properties?['tsunami'] as int? ?? 0,
      felt: properties?['felt'] as int?,
      status: properties?['status'] as String? ?? 'unknown',
      type: properties?['type'] as String? ?? 'earthquake',
    );
  }

  @override
  String toString() =>
      'Earthquake(id: $id, mag: $magnitude, depth: $depth km, '
      'lat: $lat, lng: $lng, time: $time, place: $place, url: $url, '
      'tsunami: $tsunami, felt: $felt, status: $status, type: $type)';
}