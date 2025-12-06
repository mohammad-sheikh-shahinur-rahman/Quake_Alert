import 'package:latlong2/latlong.dart';
import '../models/earthquake_model.dart';
import 'notification_service.dart';
import 'preferences_service.dart';

class AlertService {
  final NotificationService _notificationService;
  final PreferencesService _prefsService;

  AlertService(this._notificationService, this._prefsService);

  Future<void> checkAndNotify(List<Earthquake> quakes) async {
    final zones = await _prefsService.loadAlertZones();
    if (zones.isEmpty) {
      return;
    }

    final notifiedIds = await _prefsService.loadNotifiedQuakeIds();
    final newNotifiedIds = List<String>.from(notifiedIds);

    for (final quake in quakes) {
      if (notifiedIds.contains(quake.id)) {
        continue;
      }

      for (final zone in zones) {
        final distance = const Distance().as(
          LengthUnit.Kilometer,
          LatLng(quake.lat, quake.lng),
          zone.center,
        );

        if (distance <= zone.radius) {
          await _notificationService.showNotification(
            id: quake.id.hashCode,
            title: 'ভূমিকম্পের সতর্কতা: ${zone.name}',
            body:
                '${quake.magnitude.toStringAsFixed(1)} মাত্রার ভূমিকম্প, ${quake.place}',
          );
          newNotifiedIds.add(quake.id);
          break; // Move to the next quake once notified for a zone
        }
      }
    }

    await _prefsService.saveNotifiedQuakeIds(newNotifiedIds);
  }
}