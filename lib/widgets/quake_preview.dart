import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/earthquake_model.dart';

class QuakePreview extends StatelessWidget {
  final Earthquake quake;

  const QuakePreview({super.key, required this.quake});

  @override
  Widget build(BuildContext context) {
    final formattedTime =
        DateFormat('MMM d, yyyy hh:mm a').format(quake.time);
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quake.place,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Magnitude: ${quake.magnitude.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Depth: ${quake.depth.toStringAsFixed(1)} km',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            formattedTime,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}