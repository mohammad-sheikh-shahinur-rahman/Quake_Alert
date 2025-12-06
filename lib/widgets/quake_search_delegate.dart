import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../models/earthquake_model.dart';
import '../screens/quake_detail_screen.dart';

class QuakeSearchDelegate extends SearchDelegate<Earthquake?> {
  final List<Earthquake> quakes;
  final LatLng? userLocation;

  QuakeSearchDelegate({required this.quakes, this.userLocation});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredQuakes = quakes
        .where((quake) =>
            quake.place.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredQuakes.length,
      itemBuilder: (context, index) {
        final quake = filteredQuakes[index];
        final formattedTime =
            DateFormat('MMM d, yyyy hh:mm a').format(quake.time);

        return ListTile(
          title: Text(quake.place),
          subtitle: Text(
              'Magnitude: ${quake.magnitude.toStringAsFixed(1)} - $formattedTime'),
          onTap: () {
            close(context, quake);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    QuakeDetailScreen(quake: quake, userLocation: userLocation),
              ),
            );
          },
        );
      },
    );
  }
}