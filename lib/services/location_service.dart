import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  Future<LatLng> getCurrentLocationLatLng() async {
    LatLng currentLatLng = const LatLng(10, 10);
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (kDebugMode) {
        print('Location services are disabled.');
      }
      return currentLatLng;
    } else {
      try {
        await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high)
            .then((Position position) async {
          if (kDebugMode) {
            print(
                'location_Service - getCurrentLocationLatLng - Current Locations: $position');
            print(position.latitude);
          }

          currentLatLng = LatLng(position.latitude, position.longitude);
          return currentLatLng;
        }).catchError((e) {
          if (kDebugMode) {
            print("location_service.dart - getCurrentLocationLatLng: " + e);
          }
        });
      } catch (e) {
        if (kDebugMode) {
          print("location_service.dart - getCurrentLocationLatLng: " +
              e.toString());
        }
      }
      if (kDebugMode) {
        print("Returning: $currentLatLng");
      }
      return currentLatLng;
    }
  }
}

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({required this.latitude, required this.longitude});
}
