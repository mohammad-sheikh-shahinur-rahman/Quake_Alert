import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class EmergencyKitScreen extends StatefulWidget {
  const EmergencyKitScreen({super.key});

  @override
  State<EmergencyKitScreen> createState() => _EmergencyKitScreenState();
}

class _EmergencyKitScreenState extends State<EmergencyKitScreen> {
  final PreferencesService _prefsService = PreferencesService();
  List<String> _checklistItems = [];
  final TextEditingController _newItemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  Future<void> _loadChecklist() async {
    final items = await _prefsService.loadEmergencyChecklist();
    setState(() {
      _checklistItems = items;
    });
  }

  Future<void> _saveChecklist() async {
    await _prefsService.saveEmergencyChecklist(_checklistItems);
  }

  void _addItem() {
    if (_newItemController.text.isNotEmpty) {
      setState(() {
        _checklistItems.add(_newItemController.text);
        _newItemController.clear();
      });
      _saveChecklist();
    }
  }

  void _removeItem(int index) {
    setState(() {
      _checklistItems.removeAt(index);
    });
    _saveChecklist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('জরুরি কিট চেকলিস্ট'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newItemController,
                    decoration: const InputDecoration(
                      hintText: 'নতুন আইটেম যোগ করুন',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _checklistItems.length,
              itemBuilder: (context, index) {
                final item = _checklistItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(item),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeItem(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}