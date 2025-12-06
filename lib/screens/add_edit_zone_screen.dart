import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import '../models/alert_zone_model.dart';
import '../services/preferences_service.dart';

class AddEditZoneScreen extends StatefulWidget {
  final AlertZone? zone;

  const AddEditZoneScreen({super.key, this.zone});

  @override
  State<AddEditZoneScreen> createState() => _AddEditZoneScreenState();
}

class _AddEditZoneScreenState extends State<AddEditZoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final PreferencesService _prefsService = PreferencesService();
  late TextEditingController _nameController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  late TextEditingController _radiusController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.zone?.name ?? '');
    _latController =
        TextEditingController(text: widget.zone?.center.latitude.toString() ?? '');
    _lngController =
        TextEditingController(text: widget.zone?.center.longitude.toString() ?? '');
    _radiusController =
        TextEditingController(text: widget.zone?.radius.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  Future<void> _saveZone() async {
    if (_formKey.currentState!.validate()) {
      final isNewZone = widget.zone?.id.isEmpty ?? true;
      final newZone = AlertZone(
        id: isNewZone ? const Uuid().v4() : widget.zone!.id,
        name: _nameController.text,
        center: LatLng(
          double.parse(_latController.text),
          double.parse(_lngController.text),
        ),
        radius: double.parse(_radiusController.text),
      );

      final zones = await _prefsService.loadAlertZones();
      if (!isNewZone) {
        final index = zones.indexWhere((z) => z.id == widget.zone!.id);
        zones[index] = newZone;
      } else {
        zones.add(newZone);
      }
      await _prefsService.saveAlertZones(zones);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.zone == null ? 'Add Zone' : 'Edit Zone'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Zone Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _latController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a latitude' : null,
              ),
              TextFormField(
                controller: _lngController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a longitude' : null,
              ),
              TextFormField(
                controller: _radiusController,
                decoration: const InputDecoration(labelText: 'Radius (km)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a radius' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveZone,
                child: const Text('Save Zone'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}