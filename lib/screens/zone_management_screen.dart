import 'package:flutter/material.dart';
import '../models/alert_zone_model.dart';
import '../services/preferences_service.dart';
import 'add_edit_zone_screen.dart';

class ZoneManagementScreen extends StatefulWidget {
  const ZoneManagementScreen({super.key});

  @override
  State<ZoneManagementScreen> createState() => _ZoneManagementScreenState();
}

class _ZoneManagementScreenState extends State<ZoneManagementScreen> {
  final PreferencesService _prefsService = PreferencesService();
  List<AlertZone> _zones = [];
  String? _selectedZoneId;

  @override
  void initState() {
    super.initState();
    _loadZones();
  }

  Future<void> _loadZones() async {
    final zones = await _prefsService.loadAlertZones();
    setState(() {
      _zones = zones;
    });
  }

  void _deleteZone(String id) {
    setState(() {
      _zones.removeWhere((zone) => zone.id == id);
      _selectedZoneId = null;
    });
    _prefsService.saveAlertZones(_zones);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Zones'),
      ),
      body: ListView.builder(
        itemCount: _zones.length,
        itemBuilder: (context, index) {
          final zone = _zones[index];
          final isSelected = zone.id == _selectedZoneId;
          return ListTile(
            title: Text(zone.name),
            subtitle: Text('Radius: ${zone.radius.toStringAsFixed(1)} km'),
            selected: isSelected,
            selectedTileColor: Colors.blue.withAlpha(25),
            onTap: () {
              setState(() {
                _selectedZoneId = isSelected ? null : zone.id;
              });
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditZoneScreen(zone: zone),
                      ),
                    );
                    _loadZones();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteZone(zone.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditZoneScreen(),
            ),
          );
          _loadZones();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}