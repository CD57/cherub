import 'dart:async';
import 'package:cherub/models/location_data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class SessionProvider extends ChangeNotifier {
  late DatabaseService _db;
  late NavigationService _navigation;

  final ScrollController _locationsListViewController;

  final String _dateId;
  List<LocationData>? locations;

  late StreamSubscription _locationStream;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  String? _location;

  String get location {
    // ignore: recursive_getters
    return location;
  }

  set location(String _value) {
    _location = _value;
  }

  SessionProvider(this._dateId, this._locationsListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToLocationUpdates();
    listenToKeyboardChanges();
  }

  void listenToLocationUpdates() {
    try {
      _locationStream = _db.sessionDb.streamLocations(_dateId).listen(
        (_snapshot) {
          List<LocationData> _locations = _snapshot.docs.map(
            (_m) {
              Map<String, dynamic> _locationData =
                  _m.data() as Map<String, dynamic>;
              return LocationData.fromJSON(_locationData);
            },
          ).toList();
          _locations = _locations;
          notifyListeners();
          WidgetsBinding.instance!.addPostFrameCallback(
            (_) {
              if (_locationsListViewController.hasClients) {
                _locationsListViewController.jumpTo(
                    _locationsListViewController.position.maxScrollExtent);
              }
            },
          );
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(
            "session_provider.dart - listenToLocationUpdates() - Error getting messages.");
        print(e);
      }
    }
  }

  void listenToKeyboardChanges() {
    _keyboardVisibilityStream = _keyboardVisibilityController.onChange.listen(
      (_event) {
        _db.sessionDb.updateLastActiveSessionTime(_dateId);
      },
    );
    if (kDebugMode) {
      print("date_chat_provider.dart - listenToKeyboardChanges(): " +
          _keyboardVisibilityStream.toString());
    }
  }

  Future<void> sendLocationData() async {
    if (_location != null) {
      LocationData _locationData = LocationData(
        dateUid: _dateId,
        gpsLocation: _location!,
        timeOfUpdate: DateTime.now(),
      );
      await _db.sessionDb.addLocationData(_dateId, _locationData);
    }
  }

  void deleteSession() {
    goBack();
    _db.sessionDb.deleteDateSession(_dateId);
  }

  void goBack() {
    _navigation.goBack();
  }

  @override
  void dispose() {
    _locationStream.cancel();
    super.dispose();
  }
}
