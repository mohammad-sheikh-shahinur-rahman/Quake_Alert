import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../models/earthquake_model.dart';
import '../services/preferences_service.dart';
import 'quake_detail_screen.dart';

class QuakeListScreen extends StatefulWidget {
  final List<Earthquake> quakes;
  final Function(DateTime, DateTime) onDateRangeChanged;
  final String sortBy;
  final LatLng? userLocation;
  final Future<void> Function() onRefresh;

  const QuakeListScreen({
    super.key,
    required this.quakes,
    required this.onDateRangeChanged,
    required this.sortBy,
    this.userLocation,
    required this.onRefresh,
  });

  @override
  QuakeListScreenState createState() => QuakeListScreenState();
}

class QuakeListScreenState extends State<QuakeListScreen> {
  final PreferencesService _prefsService = PreferencesService();
  Set<String> _selectedTypes = {'earthquake'};
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final savedStartDate = await _prefsService.loadListStartDate();
    final savedEndDate = await _prefsService.loadListEndDate();
    final savedTypes = await _prefsService.loadListSelectedTypes();

    setState(() {
      _startDate = savedStartDate ?? DateTime.now().subtract(const Duration(days: 1));
      _endDate = savedEndDate ?? DateTime.now();
      _selectedTypes = (savedTypes ?? ['earthquake']).toSet();
    });
  }

  Future<void> _saveFilters() async {
    await _prefsService.saveListStartDate(_startDate);
    await _prefsService.saveListEndDate(_endDate);
    await _prefsService.saveListSelectedTypes(_selectedTypes.toList());
  }

  void showTypeFilter() {
    final allTypes = widget.quakes.map((q) => q.type).toSet().toList();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter by Type'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Wrap(
                spacing: 8.0,
                children: allTypes
                    .map(
                      (type) => FilterChip(
                        label: Text(type),
                        selected: _selectedTypes.contains(type),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTypes.add(type);
                            } else {
                              _selectedTypes.remove(type);
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _saveFilters();
                Navigator.pop(context);
                // This is a bit of a hack to get the main screen to rebuild
                setState(() {});
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _saveFilters();
      widget.onDateRangeChanged(_startDate, _endDate);
    }
  }

  Widget _buildSummary(List<Earthquake> quakes) {
    if (quakes.isEmpty) {
      return const SizedBox.shrink();
    }

    final highestMag =
        quakes.map((q) => q.magnitude).reduce((a, b) => a > b ? a : b);

    Earthquake? nearestQuake;
    double minDistance = double.infinity;

    if (widget.userLocation != null) {
      for (var quake in quakes) {
        final distance = const Distance().as(
          LengthUnit.Kilometer,
          LatLng(quake.lat, quake.lng),
          widget.userLocation!,
        );
        if (distance < minDistance) {
          minDistance = distance;
          nearestQuake = quake;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Total: ${quakes.length}'),
              Text('Highest: ${highestMag.toStringAsFixed(1)}'),
            ],
          ),
          if (nearestQuake != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                  'Nearest: ${nearestQuake.place} (${minDistance.toStringAsFixed(0)} km)'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Earthquake> filteredQuakes = widget.quakes
        .where((q) => _selectedTypes.contains(q.type))
        .toList();

    if (widget.sortBy == 'magnitude') {
      filteredQuakes.sort((a, b) => b.magnitude.compareTo(a.magnitude));
    } else {
      filteredQuakes.sort((a, b) => b.time.compareTo(a.time));
    }

    return Column(
      children: [
        _buildSummary(filteredQuakes),
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.onRefresh,
            child: ListView.builder(
              itemCount: filteredQuakes.length,
              itemBuilder: (context, index) {
                final quake = filteredQuakes[index];
                final formattedTime =
                    DateFormat('MMM d, yyyy hh:mm a').format(quake.time);

                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuakeDetailScreen(
                            quake: quake,
                            userLocation: widget.userLocation,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  quake.magnitude.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  quake.place,
                                  style: Theme.of(context).textTheme.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (quake.tsunami == 1)
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.waves, color: Colors.blue),
                                ),
                              // Display felt reports count
                              if (quake.felt != null && quake.felt! > 0)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.people, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${quake.felt}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              const Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'সময়: $formattedTime',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            'গভীরতা: ${quake.depth.toStringAsFixed(2)} km',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}