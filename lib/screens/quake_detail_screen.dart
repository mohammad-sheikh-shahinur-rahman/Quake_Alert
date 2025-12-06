import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/earthquake_model.dart';

class QuakeDetailScreen extends StatelessWidget {
  final Earthquake quake;
  final LatLng? userLocation;

  const QuakeDetailScreen({super.key, required this.quake, this.userLocation});

  @override
  Widget build(BuildContext context) {
    final formattedTime =
        DateFormat('MMM d, yyyy hh:mm:ss a').format(quake.time);
    final tsunamiAlert = quake.tsunami == 1 ? 'হ্যাঁ' : 'নেই';
    final feltReports = quake.felt?.toString() ?? 'N/A';

    String? distanceText;
    if (userLocation != null) {
      final distance = const Distance().as(
        LengthUnit.Kilometer,
        LatLng(quake.lat, quake.lng),
        userLocation!,
      );
      distanceText = '${distance.toStringAsFixed(0)} km from you';
    }

    // Construct the USGS "Did You Feel It?" URL
    final dyfiUrl =
        'https://earthquake.usgs.gov/data/dyfi/results.php?eventid=${quake.id}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('ভূমিকম্পের বিবরণ'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.share, color: Colors.white),
            label: const Text('Share', style: TextStyle(color: Colors.white)),
            onPressed: () {
              final shareContent = '''
                *ভূমিকম্পের বিবরণ*
                স্থান: ${quake.place}
                মাত্রা: ${quake.magnitude.toStringAsFixed(2)}
                গভীরতা: ${quake.depth.toStringAsFixed(2)} km
                সময়: $formattedTime
                সুনামি সতর্কতা: $tsunamiAlert
                রিপোর্ট সংখ্যা: $feltReports
                স্ট্যাটাস: ${quake.status}
                ${distanceText != null ? 'দূরত্ব: $distanceText' : ''}
                
                USGS ওয়েবসাইটে দেখুন: ${quake.url}
              ''';
              Share.share(shareContent);
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildMap(),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildInfoCard(
                    title: 'বিস্তারিত',
                    details: {
                      'গভীরতা (Depth)': '${quake.depth.toStringAsFixed(2)} km',
                      'সময় (Time)': formattedTime,
                      'সুনami সতর্কতা': tsunamiAlert,
                      'রিপোর্ট সংখ্যা (Felt)': feltReports,
                      'স্ট্যাটাস': quake.status,
                      if (distanceText != null) 'দূরত্ব': distanceText,
                    },
                    url: quake.url,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: 'কোঅর্ডিনেট',
                    details: {
                      'Lat': quake.lat.toString(),
                      'Lng': quake.lng.toString(),
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.feedback),
                      label: const Text('আমি কম্পন অনুভব করেছি!'),
                      onPressed: () async {
                        final url = Uri.parse(dyfiUrl);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch $dyfiUrl')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${quake.magnitude.toStringAsFixed(1)} Magnitude',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          quake.place,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(quake.lat, quake.lng),
        initialZoom: 6.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.quakealert.bd',
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80,
              height: 80,
              point: LatLng(quake.lat, quake.lng),
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required Map<String, String> details,
    String? url,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 20),
            ...details.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        entry.value,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (url != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: InkWell(
                  onTap: () => launchUrl(Uri.parse(url)),
                  child: const Text(
                    'View on USGS',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}