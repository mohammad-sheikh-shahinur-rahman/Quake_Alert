import 'dart:async';
import 'dart:convert'; // For loading GeoJSON
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // For loading assets
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/alert_zone_model.dart';
import '../models/earthquake_model.dart';
import '../services/location_service.dart';
import '../services/preferences_service.dart';
import '../widgets/pulsating_marker.dart';
import '../widgets/quake_preview.dart';
import 'add_edit_zone_screen.dart';
import 'quake_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Earthquake> quakes;
  final List<AlertZone> alertZones;
  final VoidCallback onZonesChanged;
  final VoidCallback onRefresh;
  final bool isSoundEnabled;
  final LatLng? userLocation;

  const HomeScreen({
    super.key,
    required this.quakes,
    required this.alertZones,
    required this.onZonesChanged,
    required this.onRefresh,
    required this.isSoundEnabled,
    this.userLocation,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final PreferencesService _prefsService = PreferencesService();
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();

  bool _isLoading = true;
  Map<String, double>? _mapState;
  Earthquake? _selectedQuake;
  Set<String> _activeZoneIds = {};
  Timer? _pulsateTimer;
  bool _isPulsating = false;
  LatLng? _currentLocation;
  bool _isAddingZone = false;
  double _magnitudeThreshold = 5.0;
  String _mapStyle = 'Standard';
  List<Polyline> _tectonicPlates = [];
  bool _showTectonicPlates = true;

  @override
  void initState() {
    super.initState();
    _initialize();
    _pulsateTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _isPulsating = !_isPulsating;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.quakes != oldWidget.quakes ||
        widget.isSoundEnabled != oldWidget.isSoundEnabled ||
        widget.userLocation != oldWidget.userLocation ||
        widget.alertZones != oldWidget.alertZones) {
      _checkAndPlayAlert();
      _findActiveZones();
    }
  }

  Future<void> _initialize() async {
    final mapState = await _prefsService.loadMapState();
    final threshold = await _prefsService.loadMagnitudeThreshold();
    final mapStyle = await _prefsService.loadMapStyle();
    final showPlates = await _prefsService.loadShowTectonicPlates();
    final plates = await _loadTectonicPlates();

    if (mounted) {
      setState(() {
        _mapState = mapState;
        _magnitudeThreshold = threshold;
        _mapStyle = mapStyle;
        _showTectonicPlates = showPlates;
        _tectonicPlates = plates;
        _isLoading = false;
      });
      _checkAndPlayAlert();
      _findActiveZones();
    }
  }

  Future<List<Polyline>> _loadTectonicPlates() async {
    try {
      final String response =
          await rootBundle.loadString('assets/tectonic_plates.geojson');
      final data = json.decode(response);
      List<Polyline> polylines = [];

      if (data['features'] != null) {
        for (var feature in data['features']) {
          if (feature['geometry'] != null &&
              feature['geometry']['type'] == 'LineString') {
            List<LatLng> points = [];
            for (var coord in feature['geometry']['coordinates']) {
              points.add(LatLng(coord[1], coord[0]));
            }
            polylines.add(
              Polyline(
                points: points,
                color: Colors.grey.withAlpha(128),
                strokeWidth: 1.0,
              ),
            );
          }
        }
      }
      return polylines;
    } catch (e) {
      debugPrint("Error loading tectonic plates: $e");
      return [];
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pulsateTimer?.cancel();
    super.dispose();
  }

  void _findActiveZones() {
    final significantQuakes =
        widget.quakes.where((q) => q.magnitude >= _magnitudeThreshold);
    final activeZones = <String>{};
    if (significantQuakes.isNotEmpty) {
      for (final zone in widget.alertZones) {
        for (final quake in significantQuakes) {
          final distance = const Distance().as(
            LengthUnit.Kilometer,
            LatLng(quake.lat, quake.lng),
            zone.center,
          );
          if (distance <= zone.radius) {
            activeZones.add(zone.id);
            break;
          }
        }
      }
    }
    if (activeZones.length != _activeZoneIds.length ||
        !activeZones.every(_activeZoneIds.contains)) {
      setState(() {
        _activeZoneIds = activeZones;
      });
    }
  }

  void _checkAndPlayAlert() {
    final hasSignificantQuake =
        widget.quakes.any((q) => q.magnitude >= _magnitudeThreshold);
    if (hasSignificantQuake && widget.isSoundEnabled) {
      _audioPlayer.play(AssetSource('audio/alert.mp3'));
    }
  }

  void _fitBounds() {
    final points = widget.quakes.map((q) => LatLng(q.lat, q.lng)).toList();
    for (final zone in widget.alertZones) {
      points.add(zone.center);
    }
    if (_currentLocation != null) {
      points.add(_currentLocation!);
    }

    if (points.isNotEmpty) {
      final bounds = LatLngBounds.fromPoints(points);
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(50),
        ),
      );
    } else {
      _mapController.move(const LatLng(23.99, 90.65), 7.5);
    }
  }

  Future<void> _goToCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      final location = LatLng(position.latitude, position.longitude);
      _mapController.move(location, 13.0);
      setState(() {
        _currentLocation = location;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> _onLongPress(LatLng latLng) async {
    if (_isAddingZone) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddEditZoneScreen(
            zone: AlertZone(
              id: '',
              name: '',
              center: latLng,
              radius: 50, // Default radius
            ),
          ),
        ),
      );
      widget.onZonesChanged();
      setState(() {
        _isAddingZone = false;
      });
    }
  }

  void _cycleMapStyle() {
    final styles = ['Standard', 'Satellite', 'Dark'];
    final currentIndex = styles.indexOf(_mapStyle);
    final nextIndex = (currentIndex + 1) % styles.length;
    setState(() {
      _mapStyle = styles[nextIndex];
    });
    _prefsService.saveMapStyle(_mapStyle);
  }

  String _getMapUrl() {
    switch (_mapStyle) {
      case 'Satellite':
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case 'Dark':
        return 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
      default:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    }
  }

  Color _getMarkerColor(double mag) {
    if (mag >= _magnitudeThreshold) return Colors.red;
    if (mag >= 4.0) return Colors.orange;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final initialCenter = LatLng(
      _mapState?['lat'] ?? 23.99,
      _mapState?['lng'] ?? 90.65,
    );
    final initialZoom = _mapState?['zoom'] ?? 7.5;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: initialZoom,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  _prefsService.saveMapState(
                    position.center,
                    position.zoom,
                  );
                }
              },
              onTap: (_, latLng) {
                setState(() {
                  _selectedQuake = null;
                });
              },
              onLongPress: (_, latLng) => _onLongPress(latLng),
            ),
            children: [
              TileLayer(
                urlTemplate: _getMapUrl(),
                userAgentPackageName: 'com.quakealert.bd',
              ),
              if (_showTectonicPlates)
                PolylineLayer(
                  polylines: _tectonicPlates,
                ),
              CircleLayer(
                circles: widget.alertZones
                    .map(
                      (zone) => CircleMarker(
                        point: zone.center,
                        radius: zone.radius * 1000,
                        useRadiusInMeter: true,
                        color: _activeZoneIds.contains(zone.id) && _isPulsating
                            ? Colors.red.withAlpha(128)
                            : Colors.blue.withAlpha(77),
                        borderColor: _activeZoneIds.contains(zone.id)
                            ? Colors.red
                            : Colors.blue,
                        borderStrokeWidth: 2,
                      ),
                    )
                    .toList(),
              ),
              if (_currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: widget.alertZones
                    .map(
                      (zone) => Marker(
                        point: zone.center,
                        width: 100,
                        height: 30,
                        child: Text(
                          zone.name,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    .toList(),
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 50,
                    height: 50,
                    point: const LatLng(23.8103, 90.4125), // Dhaka
                    child: FittedBox(
                      child: Column(
                        children: [
                          Icon(Icons.location_pin,
                              color: Colors.blue.shade700, size: 32),
                          const Text('ঢাকা', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  Marker(
                    width: 50,
                    height: 50,
                    point: const LatLng(24.34319, 90.86474), // Kishoreganj
                    child: FittedBox(
                      child: Column(
                        children: [
                          Icon(Icons.location_pin,
                              color: Colors.green.shade700, size: 32),
                          const Text('কিশোরগঞ্জ',
                              style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  for (var quake in widget.quakes)
                    Marker(
                      width: 40,
                      height: 40,
                      point: LatLng(quake.lat, quake.lng),
                      child: GestureDetector(
                        onLongPress: () {
                          setState(() {
                            _selectedQuake = quake;
                          });
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuakeDetailScreen(quake: quake),
                            ),
                          );
                        },
                        child: FittedBox(
                          child: Column(
                            children: [
                              if (quake.magnitude >= _magnitudeThreshold)
                                PulsatingMarker(
                                  size: 14 + (quake.magnitude * 4),
                                  color: _getMarkerColor(quake.magnitude),
                                )
                              else
                                Icon(
                                  Icons.circle,
                                  color: _getMarkerColor(quake.magnitude)
                                      .withAlpha(178),
                                  size: 14 + (quake.magnitude * 4),
                                ),
                              Text(
                                quake.magnitude.toStringAsFixed(1),
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (_selectedQuake != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: QuakePreview(quake: _selectedQuake!),
            ),
          if (_isAddingZone)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(128),
                child: const Center(
                  child: Text(
                    'Long-press on the map to add a new zone',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _cycleMapStyle,
            child: const Icon(Icons.layers),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: widget.onRefresh,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _isAddingZone = !_isAddingZone;
              });
            },
            backgroundColor: _isAddingZone ? Colors.red : Colors.blue,
            child: Icon(_isAddingZone ? Icons.cancel : Icons.add_location_alt),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _fitBounds,
            child: const Icon(Icons.zoom_out_map),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _goToCurrentLocation,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}