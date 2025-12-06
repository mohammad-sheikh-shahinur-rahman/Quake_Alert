import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/earthquake_model.dart';

class EarthquakeService {
  static const String _baseUrl = 'https://earthquake.usgs.gov/fdsnws/event/1/query';

  Future<List<Earthquake>> fetchQuakes({
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    final start = (startTime ?? DateTime.now().subtract(const Duration(days: 1)))
        .toIso8601String();
    final end = (endTime ?? DateTime.now()).toIso8601String();
    final url = '$_baseUrl?format=geojson&starttime=$start&endtime=$end';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final features = data['features'] as List;
      return features.map((e) => Earthquake.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load earthquake data');
    }
  }

  List<Earthquake> filterBangladeshRegion(List<Earthquake> quakes) {
    return quakes.where((q) {
      return q.magnitude >= 2.5 &&
          q.lat >= 20 && q.lat <= 27 &&
          q.lng >= 88 && q.lng <= 93;
    }).toList();
  }
}