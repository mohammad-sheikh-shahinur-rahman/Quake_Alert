import 'package:flutter/material.dart';

class PulsatingMarker extends StatefulWidget {
  final double size;
  final Color color;

  const PulsatingMarker({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  State<PulsatingMarker> createState() => _PulsatingMarkerState();
}

class _PulsatingMarkerState extends State<PulsatingMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController.drive(
        CurveTween(curve: Curves.easeInOut),
      ),
      child: Icon(
        Icons.circle,
        size: widget.size,
        color: widget.color,
      ),
    );
  }
}