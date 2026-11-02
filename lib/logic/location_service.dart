import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_health/app_router.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/utils/build_type/build_type.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class LocationService {
  /// Request location permission, including handling cases requiring app settings.
  Future<bool> requestLocationPermission(bool showAlertError) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      // User has denied the permission.
      // We are not showing an alert here as it might be intrusive since
      // the user has actively denied it in the native dialog.
      return false;
    }

    // If permission is denied forever, direct user to settings
    if (permission == LocationPermission.deniedForever) {
      if (showAlertError) {
        await _showLocationPermissionDeniedAlert();
      }
      return false;
    }

    // Return true if permission is granted
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Check if location services are enabled.
  Future<bool> isLocationServiceEnabled(bool showAlertError) async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If location services are disabled, direct user to enable them
      if (showAlertError) {
        await _showLocationServiceDisableAlert();
      }
      return false;
    }
    return true;
  }

  /// Get the current location of the device.
  Future<Position?> getCurrentLocation({bool showAlertError = true}) async {
    if (isDebugMode()) {
      return Position(
        longitude: 31.2357,
        latitude: 30.0444,
        timestamp: DateTime.now(),
        accuracy: 5.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        isMocked: false,
        headingAccuracy: 0.0,
      );
    }
    // Ensure location services are enabled
    if (!await isLocationServiceEnabled(showAlertError)) {
      return null;
    }
    // Ensure permissions are granted
    if (!await requestLocationPermission(showAlertError)) {
      return null;
    }
    // Retrieve the current location
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<bool> checkLocationPermission() async {
    // Check if location services are enabled
    if (!await isLocationServiceEnabled(false)) {
      return false;
    }
    // Check if location permissions are granted
    if (!await requestLocationPermission(false)) {
      return false;
    }
    return true;
  }

  Future<void> _showLocationServiceDisableAlert() async {
    // make a dialog to show that location services are disabled
    await showDialog(
      context: AppRouter.mainNavigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            context.translate(LocalizationKeys.locationServicesDisabled),
          ),
          content: Text(
            'Location services are disabled. Please enable them in your device settings to proceed.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(context.translate(LocalizationKeys.cancel)),
            ),
            TextButton(
              onPressed: () async {
                // Navigate to device settings or show a relevant action
                Navigator.pop(context);
                // Add your location settings navigation logic here
                await Geolocator.openLocationSettings();
              },
              child: Text(context.translate(LocalizationKeys.enable)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLocationPermissionDeniedAlert() async {
    // make a dialog to show that location permission is permanently denied
    await showDialog(
      context: AppRouter.mainNavigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            context.translate(LocalizationKeys.locationPermissionRequired),
          ),
          content: Text(
            'Location permissions are permanently denied. Please enable them in app settings to use this feature.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(context.translate(LocalizationKeys.notNow)),
            ),
            TextButton(
              onPressed: () async {
                // Navigate to device settings or show a relevant action
                Navigator.pop(context);
                await Geolocator.openAppSettings();
              },
              child: Text(context.translate(LocalizationKeys.openSettings)),
            ),
          ],
        );
      },
    );
  }
}
