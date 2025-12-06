import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart'; // Removed unused import
import 'package:easy_localization/easy_localization.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:latlong2/latlong.dart';
import 'models/alert_zone_model.dart';
import 'models/earthquake_model.dart';
import 'screens/emergency_kit_screen.dart'; // Import the new screen
import 'screens/emergency_screen.dart';
import 'screens/home_screen.dart';
import 'screens/quake_list_screen.dart';
import 'screens/safety_screen.dart';
import 'screens/settings_screen.dart';
import 'services/alert_service.dart';
import 'services/earthquake_service.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'services/preferences_service.dart';
import 'widgets/quake_search_delegate.dart';

final notificationService = NotificationService();
final preferencesService = PreferencesService();
final alertService = AlertService(notificationService, preferencesService);
final locationService = LocationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await notificationService.init();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('bn'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('bn'),
      child: Builder( // Wrap MaterialApp with Builder to access EasyLocalization context
        builder: (context) {
          // Explicitly get the EasyLocalization instance
          final easyLocalization = EasyLocalization.of(context)!;
          return MaterialApp(
            title: 'Quake Alert',
            localizationsDelegates: easyLocalization.delegates,
            supportedLocales: easyLocalization.supportedLocales,
            locale: easyLocalization.locale,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade700),
              fontFamily: 'SolaimanLipi',
            ),
            home: const MainScreen(), // Set the initial screen
          );
        }
      ),
    ),
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  late Future<List<Earthquake>> _quakesFuture;
  final EarthquakeService _earthquakeService = EarthquakeService();
  List<AlertZone> _alertZones = [];
  Timer? _timer;
  final GlobalKey<QuakeListScreenState> _quakeListKey =
      GlobalKey<QuakeListScreenState>();
  String _sortBy = 'time';
  bool _isSoundEnabled = true;
  LatLng? _userLocation;
  int _refreshInterval = 5; // Default to 5 minutes

  @override
  void initState() {
    super.initState();
    _quakesFuture = _earthquakeService.fetchQuakes(); // Initialize _quakesFuture here
    _loadPreferencesAndLocation();
    _startRefreshTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadPreferencesAndLocation() async {
    final enabled = await preferencesService.loadSoundEnabled();
    final interval = await preferencesService.loadRefreshInterval();
    LatLng? currentLocation;
    try {
      final position = await locationService.getCurrentLocation();
      currentLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('Location error: $e');
    }

    if (mounted) {
      setState(() {
        _isSoundEnabled = enabled;
        _userLocation = currentLocation;
        _refreshInterval = interval;
      });
    }
  }

  void _startRefreshTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(minutes: _refreshInterval), (timer) {
      _refresh();
    });
  }

  Future<void> _toggleSound() async {
    setState(() {
      _isSoundEnabled = !_isSoundEnabled;
    });
    await preferencesService.saveSoundEnabled(_isSoundEnabled);
  }

  Future<void> _loadAlertZones() async {
    final zones = await preferencesService.loadAlertZones();
    if (mounted) {
      setState(() {
        _alertZones = zones;
      });
    }
  }

  Future<void> _refresh() async {
    final newQuakesFuture = _earthquakeService.fetchQuakes();
    setState(() {
      _quakesFuture = newQuakesFuture;
    });
    final quakes = await newQuakesFuture;
    await alertService.checkAndNotify(quakes);
  }

  void _refetchQuakes(DateTime startTime, DateTime endTime) {
    setState(() {
      _quakesFuture =
          _earthquakeService.fetchQuakes(startTime: startTime, endTime: endTime);
    });
  }

  void _toggleSort() {
    setState(() {
      _sortBy = _sortBy == 'time' ? 'magnitude' : 'time';
    });
  }

  void _onPageChanged(int index) {
    if (index == 0) {
      _loadAlertZones();
    }
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      'Quake Alert',
      'Quake List',
      'Safety',
      'Emergency',
      'Emergency Kit',
      'Settings',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_pageIndex]),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final quakes = await _quakesFuture;
              showSearch(
                context: context,
                delegate: QuakeSearchDelegate(
                  quakes: quakes,
                  userLocation: _userLocation,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(_isSoundEnabled ? Icons.volume_up : Icons.volume_off),
            onPressed: _toggleSound,
          ),
          if (_pageIndex == 1)
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: _toggleSort,
            ),
          if (_pageIndex == 1)
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () {
                _quakeListKey.currentState?.selectDateRange(context);
              },
            ),
          if (_pageIndex == 1)
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                _quakeListKey.currentState?.showTypeFilter();
              },
            ),
          if (_pageIndex == 1)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refresh,
            ),
        ],
      ),
      body: FutureBuilder<List<Earthquake>>(
        future: _quakesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('ত্রুটি: ${snapshot.error}'));
          }

          final quakes = snapshot.data ?? [];
          final screens = [
            HomeScreen(
              quakes: quakes,
              alertZones: _alertZones,
              onZonesChanged: _loadAlertZones,
              onRefresh: _refresh,
              isSoundEnabled: _isSoundEnabled,
              userLocation: _userLocation,
            ),
            QuakeListScreen(
              key: _quakeListKey,
              quakes: quakes,
              onDateRangeChanged: _refetchQuakes,
              sortBy: _sortBy,
              userLocation: _userLocation,
              onRefresh: _refresh,
            ),
            const SafetyScreen(),
            const EmergencyScreen(),
            const EmergencyKitScreen(), // Add EmergencyKitScreen here
            SettingsScreen(
              onRefreshIntervalChanged: _startRefreshTimer,
            ),
          ];

          return IndexedStack(
            index: _pageIndex,
            children: screens,
          );
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.red.shade700,
        buttonBackgroundColor: Colors.white,
        height: 60,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        index: _pageIndex,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.list, size: 30, color: Colors.white),
          Icon(Icons.health_and_safety, size: 30, color: Colors.white),
          Icon(Icons.crisis_alert, size: 30, color: Colors.white),
          Icon(Icons.backpack, size: 30, color: Colors.white), // New icon for Emergency Kit
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        onTap: _onPageChanged,
      ),
    );
  }
}