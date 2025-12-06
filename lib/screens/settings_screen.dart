import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart'; // Added LatLng import
import '../services/preferences_service.dart';
import 'privacy_policy_screen.dart'; // Import the PrivacyPolicyScreen
import 'terms_of_use_screen.dart'; // Import the TermsOfUseScreen
import 'zone_management_screen.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onRefreshIntervalChanged;

  const SettingsScreen({super.key, required this.onRefreshIntervalChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PreferencesService _prefsService = PreferencesService();
  double _magnitudeThreshold = 5.0;
  int _refreshInterval = 5; // Default to 5 minutes
  String _appVersion = '1.0.0';
  bool _showTectonicPlates = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadAppVersion();
  }

  Future<void> _loadPreferences() async {
    final threshold = await _prefsService.loadMagnitudeThreshold();
    final interval = await _prefsService.loadRefreshInterval();
    final showPlates = await _prefsService.loadShowTectonicPlates();
    setState(() {
      _magnitudeThreshold = threshold;
      _refreshInterval = interval;
      _showTectonicPlates = showPlates;
    });
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Future<void> _saveMagnitudeThreshold(double value) async {
    setState(() {
      _magnitudeThreshold = value;
    });
    await _prefsService.saveMagnitudeThreshold(value);
  }

  Future<void> _saveRefreshInterval(int? value) async {
    if (value != null) {
      setState(() {
        _refreshInterval = value;
      });
      await _prefsService.saveRefreshInterval(value);
      widget.onRefreshIntervalChanged(); // Notify MainScreen to restart timer
    }
  }

  Future<void> _toggleShowTectonicPlates(bool value) async {
    setState(() {
      _showTectonicPlates = value;
    });
    await _prefsService.saveShowTectonicPlates(value);
  }

  Future<void> _resetMapView() async {
    // Removed const from LatLng as it's not a constant expression
    await _prefsService.saveMapState(const LatLng(23.99, 90.65), 7.5); // Default values
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Map view reset to default.')),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationIcon: Image.asset('assets/icon/icon.png', width: 48, height: 48),
      applicationName: 'Quake Alert',
      applicationVersion: _appVersion,
      children: [
        const Text('This app provides real-time earthquake alerts and information.'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('সেটিংস')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ভাষা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('বাংলা'),
              leading: Radio.adaptive(
                value: 'bn',
                groupValue: context.locale.languageCode,
                onChanged: (val) => context.setLocale(Locale(val!)),
              ),
            ),
            ListTile(
              title: const Text('English'),
              leading: Radio.adaptive(
                value: 'en',
                groupValue: context.locale.languageCode,
                onChanged: (val) => context.setLocale(Locale(val!)),
              ),
            ),
            const Divider(),
            const Text('অ্যালার্ট', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Manage Alert Zones'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ZoneManagementScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            const Text('অ্যালার্ট থ্রেশহোল্ড', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Slider(
              value: _magnitudeThreshold,
              min: 0,
              max: 10,
              divisions: 20,
              label: _magnitudeThreshold.toStringAsFixed(1),
              onChanged: _saveMagnitudeThreshold,
            ),
            const Divider(),
            const Text('রিফ্রেশ ব্যবধান (মিনিট)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButton<int>(
              value: _refreshInterval,
              items: const [
                DropdownMenuItem(value: 1, child: Text('1 মিনিট')),
                DropdownMenuItem(value: 5, child: Text('5 মিনিট')),
                DropdownMenuItem(value: 10, child: Text('10 মিনিট')),
                DropdownMenuItem(value: 30, child: Text('30 মিনিট')),
              ],
              onChanged: _saveRefreshInterval,
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Show Tectonic Plates'),
              value: _showTectonicPlates,
              onChanged: _toggleShowTectonicPlates,
            ),
            ListTile(
              title: const Text('Reset Map View'),
              trailing: const Icon(Icons.restore),
              onTap: _resetMapView,
            ),
            const Divider(),
            const Text('অ্যাপ সম্পর্কে', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('About App'),
              trailing: const Icon(Icons.info_outline),
              onTap: _showAboutDialog,
            ),
            ListTile(
              title: const Text('সংস্করণ'),
              trailing: Text(_appVersion),
            ),
            ListTile(
              title: const Text('ডেভেলপার'),
              trailing: const Text('Mohammad Sheikh Shahinur Rahman'), // Updated developer name
            ),
            ListTile(
              title: const Text('ওয়েবসাইট'), // New entry for website
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _launchURL('https://shahinurrahman.com/'),
            ),
            ListTile(
              title: const Text('গোপনীয়তা নীতি'),
              trailing: const Icon(Icons.description), // Changed icon to reflect internal page
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('ব্যবহারের শর্তাবলী'),
              trailing: const Icon(Icons.description), // Changed icon to reflect internal page
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsOfUseScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}