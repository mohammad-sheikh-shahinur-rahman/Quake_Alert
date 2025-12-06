import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';
import '../models/alert_zone_model.dart';

class PreferencesService {
  static const String _latKey = 'map_center_lat';
  static const String _lngKey = 'map_center_lng';
  static const String _zoomKey = 'map_zoom';
  static const String _zonesKey = 'alert_zones';
  static const String _notifiedQuakeIdsKey = 'notified_quake_ids';
  static const String _magnitudeThresholdKey = 'magnitude_threshold';
  static const String _typeFiltersKey = 'type_filters';
  static const String _mapStyleKey = 'map_style';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _listStartDateKey = 'list_start_date';
  static const String _listEndDateKey = 'list_end_date';
  static const String _listSelectedTypesKey = 'list_selected_types';
  static const String _listSortByKey = 'list_sort_by';
  static const String _listSearchQueryKey = 'list_search_query';
  static const String _refreshIntervalKey = 'refresh_interval';
  static const String _emergencyChecklistKey = 'emergency_checklist';
  static const String _showTectonicPlatesKey = 'show_tectonic_plates';

  Future<void> saveMapState(LatLng center, double zoom) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latKey, center.latitude);
    await prefs.setDouble(_lngKey, center.longitude);
    await prefs.setDouble(_zoomKey, zoom);
  }

  Future<Map<String, double>> loadMapState() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_latKey);
    final lng = prefs.getDouble(_lngKey);
    final zoom = prefs.getDouble(_zoomKey);

    if (lat != null && lng != null && zoom != null) {
      return {'lat': lat, 'lng': lng, 'zoom': zoom};
    } else {
      // Default values if nothing is saved
      return {'lat': 23.99, 'lng': 90.65, 'zoom': 7.5};
    }
  }

  Future<void> saveAlertZones(List<AlertZone> zones) async {
    final prefs = await SharedPreferences.getInstance();
    final zonesJson = zones.map((zone) => zone.toJson()).toList();
    await prefs.setStringList(_zonesKey, zonesJson);
  }

  Future<List<AlertZone>> loadAlertZones() async {
    final prefs = await SharedPreferences.getInstance();
    final zonesJson = prefs.getStringList(_zonesKey);
    if (zonesJson != null) {
      return zonesJson.map((json) => AlertZone.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> saveNotifiedQuakeIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_notifiedQuakeIdsKey, ids);
  }

  Future<List<String>> loadNotifiedQuakeIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_notifiedQuakeIdsKey) ?? [];
  }

  Future<void> saveMagnitudeThreshold(double threshold) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_magnitudeThresholdKey, threshold);
  }

  Future<double> loadMagnitudeThreshold() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_magnitudeThresholdKey) ?? 5.0; // Default to 5.0
  }

  Future<void> saveTypeFilters(List<String> types) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_typeFiltersKey, types);
  }

  Future<List<String>> loadTypeFilters() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_typeFiltersKey) ?? ['earthquake'];
  }

  Future<void> saveMapStyle(String style) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mapStyleKey, style);
  }

  Future<String> loadMapStyle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_mapStyleKey) ?? 'Standard'; // Default to Standard
  }

  Future<void> saveSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, enabled);
  }

  Future<bool> loadSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEnabledKey) ?? true; // Default to sound enabled
  }

  // New methods for list filters
  Future<void> saveListStartDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_listStartDateKey, date.toIso8601String());
  }

  Future<DateTime?> loadListStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_listStartDateKey);
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  Future<void> saveListEndDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_listEndDateKey, date.toIso8601String());
  }

  Future<DateTime?> loadListEndDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_listEndDateKey);
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  Future<void> saveListSelectedTypes(List<String> types) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_listSelectedTypesKey, types);
  }

  Future<List<String>?> loadListSelectedTypes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_listSelectedTypesKey);
  }

  Future<void> saveListSortBy(String sortBy) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_listSortByKey, sortBy);
  }

  Future<String?> loadListSortBy() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_listSortByKey);
  }

  Future<void> saveListSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_listSearchQueryKey, query);
  }

  Future<String?> loadListSearchQuery() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_listSearchQueryKey);
  }

  // New methods for refresh interval
  Future<void> saveRefreshInterval(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_refreshIntervalKey, minutes);
  }

  Future<int> loadRefreshInterval() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_refreshIntervalKey) ?? 5; // Default to 5 minutes
  }

  // New methods for emergency checklist
  Future<void> saveEmergencyChecklist(List<String> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_emergencyChecklistKey, items);
  }

  Future<List<String>> loadEmergencyChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_emergencyChecklistKey) ?? [
      'জল (৩ দিনের জন্য প্রতিজনের জন্য ১ গ্যালন)',
      'শুকনো খাবার (৩ দিনের জন্য)',
      'প্রাথমিক চিকিৎসার কিট',
      'টর্চলাইট ও অতিরিক্ত ব্যাটারি',
      'হুইসেল',
      'ধুলো মাস্ক',
      'প্লাস্টিকের শিট ও ডাক্ট টেপ',
      'রেঞ্চ বা প্লায়ার্স (ইউটিলিটি বন্ধ করার জন্য)',
      'ম্যানুয়াল ক্যান ওপেনার',
      'মোবাইল ফোন ও পাওয়ার ব্যাংক',
      'নগদ টাকা',
      'গুরুত্বপূর্ণ কাগজপত্র (পরিচয়পত্র, বীমা পলিসি)',
      'কম্বল বা স্লিপিং ব্যাগ',
      'অতিরিক্ত পোশাক',
      'সাবান, হ্যান্ড স্যানিটাইজার, টয়লেট পেপার',
      'শিশুদের জন্য প্রয়োজনীয় জিনিস (যদি থাকে)',
      'পোষা প্রাণীর খাবার ও প্রয়োজনীয় জিনিস (যদি থাকে)',
    ];
  }

  // New methods for tectonic plates visibility
  Future<void> saveShowTectonicPlates(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showTectonicPlatesKey, show);
  }

  Future<bool> loadShowTectonicPlates() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showTectonicPlatesKey) ?? true; // Default to show
  }
}