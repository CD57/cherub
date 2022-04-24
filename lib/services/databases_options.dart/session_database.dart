// session_database.dart - Service to manage session database connection and actions

import 'package:cherub/models/location_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

const String sessions = "Sessions";
const String locations = "Locations";

class SessionDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  SessionDatabase();

  // Create Date Session
  Future<DocumentReference?> createSession(
      Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("session_database.dart - createDateSession()");
    }
    try {
      DocumentReference _dateSession =
          await _db.collection(sessions).add(_data);
      return _dateSession;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // Get Date Sessions
  Stream<QuerySnapshot> getSessions(String _uid) {
    if (kDebugMode) {
      print("session_database.dart - getDateSessions()");
    }
    try {
      return _db
          .collection(sessions)
          .where('dateUid', isEqualTo: _uid)
          .snapshots();
    } catch (e) {
      if (kDebugMode) {
        print("session_database.dart - getDateSessions() - FAILED: " +
            e.toString());
      }
      return _db
          .collection(sessions)
          .where('dateUid', isEqualTo: _uid)
          .snapshots();
    }
  }

  // Update Date Session
  Future<void> updateSession(
      String _dateID, Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("session_database.dart - updateDateSession()");
    }
    try {
      await _db.collection(sessions).doc(_dateID).update(_data);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Delete Date Session
  Future<void> deleteSession(String _dateID) async {
    if (kDebugMode) {
      print("session_database.dart - deleteDateChat()");
    }
    try {
      await _db.collection(sessions).doc(_dateID).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Add location data to session
  Future<void> addLocationData(String _dateID, LocationData _location) async {
    if (kDebugMode) {
      print("session_database.dart - addLocationData()");
    }
    try {
      await _db.collection(sessions).doc(_dateID).collection(locations).add(
            _location.toJson(),
          );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Get Last Location of Date Session
  Future<QuerySnapshot> getLastLocation(String _dateID) {
    if (kDebugMode) {
      print("database_service.dart - getLastLocation()");
    }
    return _db
        .collection(sessions)
        .doc(_dateID)
        .collection(locations)
        .orderBy("timeOfUpdate", descending: true)
        .limit(1)
        .get();
  }

  // Get Last Active Time of Location Activity
  Future<void> updateLastActiveSessionTime(String _uid) async {
    if (kDebugMode) {
      print("database_service.dart - updateLastActiveSessionTime()");
    }
    try {
      await _db.collection(sessions).doc(_uid).update(
        {
          "lastDateUpdate": DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Listen to stream of select dates messages
  Stream<QuerySnapshot> streamLocations(String _dateID) {
    if (kDebugMode) {
      print("database_service.dart - streamLocations()");
    }
    return _db
        .collection(sessions)
        .doc(_dateID)
        .collection(locations)
        .orderBy("timeOfUpdate", descending: false)
        .snapshots();
  }
}
