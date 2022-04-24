// dates_page_provider.dart - Provider for the date page, retrieving relevant data to display each chat page instance details

import 'dart:async';
import 'package:cherub/models/date_session_model.dart';
import 'package:cherub/models/location_data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../services/database_service.dart';

class SessionsPageProvider extends ChangeNotifier {
  final AuthProvider _auth;
  late DatabaseService _db;

  List<DateSession>? dates;
  late StreamSubscription _dateSessionsStream;

  SessionsPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    getDateSessions();
  }

  @override
  void dispose() {
    _dateSessionsStream.cancel();
    super.dispose();
  }

  void getDateSessions() async {
    try {
      _dateSessionsStream =
          _db.sessionDb.getDateSessions(_auth.user.userId).listen((_snapshot) async {
        dates = await Future.wait(
          _snapshot.docs.map(
            (_d) async {
              Map<String, dynamic> _sessionData =
                  _d.data() as Map<String, dynamic>;
              //Get Users In Session
              List<UserModel> _cherubs = [];
              for (var _uid in _sessionData["cherubs"]) {
                DocumentSnapshot _userSnapshot = await _db.userDb.getUserByID(_uid);
                Map<String, dynamic> _userData =
                    _userSnapshot.data() as Map<String, dynamic>;
                _userData["userId"] = _userSnapshot.id;
                _cherubs.add(
                  UserModel.fromJSON(_userData),
                );
              }
              //Get Last Update for Session
              List<LocationData> _locations = [];
              QuerySnapshot _lastLocation = await _db.sessionDb.getLastLocation(_d.id);
              if (_lastLocation.docs.isNotEmpty) {
                Map<String, dynamic> _locationData =
                    _lastLocation.docs.first.data()! as Map<String, dynamic>;
                LocationData _location = LocationData.fromJSON(_locationData);
                _locations.add(_location);
              }
              //Return Session Instance
              return DateSession(
                sessionUid: _d.id,
                dateUid: _auth.user.userId,
                cherubs: _cherubs,
                locations: _locations
              );
            },
          ).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error getting data.");
        print(e);
      }
    }
  }
}
