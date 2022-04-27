import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class LocationService {
  late Position _currentPosition;
  late final LatLng _temp = const LatLng(10, 10);
  late UserLocation _currentLocation;
  var location = loc.Location();

  //   StreamController<UserLocation> _locationController =
  //     StreamController<UserLocation>();

  // Stream<UserLocation> get locationStream => _locationController.stream;

  // LocationService() {
  //   // Request permission to use location
  //   location.requestPermission().then((granted) {
  //     if (granted) {
  //       // If granted listen to the onLocationChanged stream and emit over our controller
  //       location.onLocationChanged().listen((locationData) {
  //         if (locationData != null) {
  //           _locationController.add(UserLocation(
  //             latitude: locationData.latitude,
  //             longitude: locationData.longitude,
  //           ));
  //         }
  //       });
  //     }
  //   });
  // }

  // Future<UserLocation> getLocation() async {
  //   try {
  //     var userLocation = await location.getLocation();
  //     _currentLocation = UserLocation(
  //       latitude: userLocation.latitude!,
  //       longitude: userLocation.longitude!,
  //     );
  //   } on Exception catch (e) {
  //     if (kDebugMode) {
  //       print('Could not get location: ${e.toString()}');
  //     }
  //   }

  //   return _currentLocation;
  // }

  getCurrentLocationString() async {
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

  getCurrentLocationLatLng() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    try {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        if (kDebugMode) {
          print('location_Service - Current Locations: $_currentPosition');
        }
        return LatLng(position.latitude, position.longitude);
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
    return _temp;
  }

  
}

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({required this.latitude, required this.longitude});
}
