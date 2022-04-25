import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LocationService {
  late Position _currentPosition;
  late LatLng _currentLatLng; 

  getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    String locationString = "10,10";
    try {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        _currentPosition = position;
        if (kDebugMode) {
          print('location_Service - Current Locations: $_currentPosition');
        }
        locationString = _currentPosition.latitude.toString() +
            "," +
            _currentPosition.longitude.toString();
        return locationString;
      }).catchError((e) {
        if (kDebugMode) {
          print(e);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (kDebugMode) {
      print("Failed to get location, returning 10,10");
    }
    return locationString;
  }

  Future<LatLng> getCurrentLocationLatLng() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    try {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        _currentLatLng = LatLng(position.latitude, position.longitude);
        if (kDebugMode) {
          print('location_Service - Current Locations: $_currentPosition');
        }
        return _currentLatLng;
      }).catchError((e) {
        if (kDebugMode) {
          print(e);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (kDebugMode) {
      print("Failed to get location");
    }
    return _currentLatLng;
  }
}
