// database_service.dart - Service to manage database connection and actions

import 'package:cherub/models/location_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

const String users = "Users";
const String dates = "Dates";
const String chats = "Chats";
const String messages = "Messages";
const String sessions = "Sessions";
const String locations = "Locations";
const String dateDetails = "DateDetails";
const String friends = "Friends";
const String userFriends = "UserFriends";
const String userRequests = "UserRequests";

class SessionDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  SessionDatabase();

  // Create Date Session
  Future<DocumentReference?> createDateSession(
      Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("database_service.dart - createDateSession()");
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

  // Gets All Date Sessions
  Stream<QuerySnapshot> getDateSessions(String _uid) {
    if (kDebugMode) {
      print("database_service.dart - getDateSessions()");
    }
    try {
      return _db
          .collection(sessions)
          .where('dateUid', isEqualTo: _uid)
          .snapshots();
    } catch (e) {
      if (kDebugMode) {
        print(
            "database_service.dart - getDateSessions() - FAILED: " + e.toString());
      }
      return _db
          .collection(sessions)
          .where('dateUid', isEqualTo: _uid)
          .snapshots();
    }
  }

  // Get Last Message of Date Chat
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

  // Add message to date chat
  Future<void> addLocationData(String _dateID, LocationData _location) async {
    if (kDebugMode) {
      print("database_service.dart - addLocationData()");
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

  // Update users date session
  Future<void> updateDateSession(
      String _dateID, Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("database_service.dart - updateDateSession()");
    }
    try {
      await _db.collection(sessions).doc(_dateID).update(_data);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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

  // Delete Date Session
  Future<void> deleteDateSession(String _dateID) async {
    if (kDebugMode) {
      print("database_service.dart - deleteDateChat()");
    }
    try {
      await _db.collection(sessions).doc(_dateID).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
