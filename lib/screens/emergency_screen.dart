import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart'; // Import the vibration package
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher for phone calls

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSirenPlaying = false;
  Timer? _vibrationTimer; // Timer for continuous vibration
  Timer? _pulsateTimer; // Timer for visual pulsation of the button
  Timer? _screenFlashTimer; // Timer for screen flashing
  bool _isPulsating = false; // State for visual pulsation of the button
  bool _isScreenFlashing = false; // State for screen flashing
  double _currentVolume = 1.0; // Added for volume control

  @override
  void initState() {
    super.initState();
    _audioPlayer.setVolume(_currentVolume); // Set initial volume
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _vibrationTimer?.cancel(); // Cancel the vibration timer
    _pulsateTimer?.cancel(); // Cancel the button pulsation timer
    _screenFlashTimer?.cancel(); // Cancel the screen flash timer
    Vibration.cancel(); // Stop any ongoing vibration
    super.dispose();
  }

  Future<void> _toggleSiren() async {
    if (_isSirenPlaying) {
      await _audioPlayer.stop();
      _vibrationTimer?.cancel(); // Stop vibration timer
      Vibration.cancel(); // Stop any ongoing vibration
      _pulsateTimer?.cancel(); // Stop button pulsation timer
      _screenFlashTimer?.cancel(); // Stop screen flash timer
      setState(() {
        _isPulsating = false; // Reset button pulsation state
        _isScreenFlashing = false; // Reset screen flashing state
      });
    } else {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the sound
      await _audioPlayer.play(AssetSource('audio/alert.mp3'), volume: _currentVolume); // Using existing alert sound

      // Start vibration if supported
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(pattern: [0, 500, 500], repeat: 0);
      }

      // Start visual pulsation for the button
      _pulsateTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
        if (mounted) {
          setState(() {
            _isPulsating = !_isPulsating;
          });
        }
      });

      // Start screen flashing
      _screenFlashTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        if (mounted) {
          setState(() {
            _isScreenFlashing = !_isScreenFlashing;
          });
        }
      });
    }
    setState(() {
      _isSirenPlaying = !_isSirenPlaying;
    });
  }

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $phoneNumber')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('জরুরি সাইরেন'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _toggleSiren,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: _isSirenPlaying ? Colors.red.shade700 : Colors.green.shade700,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _isSirenPlaying
                              ? (_isPulsating ? Colors.red.shade900 : Colors.red.shade700)
                              : Colors.green.shade900,
                          blurRadius: _isSirenPlaying && _isPulsating ? 30 : 15, // Pulsating blur
                          spreadRadius: _isSirenPlaying && _isPulsating ? 10 : 5, // Pulsating spread
                        ),
                      ],
                    ),
                    child: Icon(
                      _isSirenPlaying ? Icons.stop : Icons.play_arrow,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  _isSirenPlaying ? 'সাইরেন বাজছে...' : 'সাইরেন বাজাতে ট্যাপ করুন',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                // Volume Control Slider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.volume_mute),
                      Expanded(
                        child: Slider(
                          value: _currentVolume,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          label: (_currentVolume * 100).round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentVolume = value;
                            });
                            _audioPlayer.setVolume(value);
                          },
                        ),
                      ),
                      const Icon(Icons.volume_up),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Emergency Contact Section
                const Text(
                  'জরুরি যোগাযোগ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ফায়ার সার্ভিস ও সিভিল ডিফেন্স:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 18),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _launchPhoneCall('999'),
                              child: const Text(
                                '৯৯৯',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const Text(' অথবা '),
                            GestureDetector(
                              onTap: () => _launchPhoneCall('029555555'),
                              child: const Text(
                                '০২-৯৫৫৫৫৫৫',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'বিপদে পড়লে বা সাহায্য চাইতে এই সাইরেন ব্যবহার করুন।',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          // Screen Flashing Overlay
          if (_isSirenPlaying)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _isScreenFlashing ? 0.8 : 0.0,
                  duration: const Duration(milliseconds: 100), // Fast flash
                  child: Container(
                    color: Colors.white, // White flash
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}