// date_database.dart - Service to manage date database connections and actions

import 'package:cherub/models/date_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

const String users = "Users";
const String dates = "Dates";
const String dateDetails = "DateDetails";

class DateDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DateDatabase();

  // Create Date Details
  createDateDetails(String _userId, Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("date_database.dart - createDateDetails()");
    }
    try {
      DocumentReference docRef = await _db
          .collection(dates)
          .doc(_userId)
          .collection(dateDetails)
          .add(_data);
      return docRef;
    } catch (e) {
      if (kDebugMode) {
        print("date_database - createDateDetails: Error - " + e.toString());
      }
      DocumentReference docRef = await _db
          .collection(dates)
          .doc(_userId)
          .collection(dateDetails)
          .add(_data);
      return docRef;
    }
  }

  // Get Date Details
  Future<DocumentSnapshot> getDateDetails(String _hostUid, String _dateUid) {
    if (kDebugMode) {
      print("date_database.dart - getDateDetails()");
    }
    return _db
        .collection(dates)
        .doc(_hostUid)
        .collection(dateDetails)
        .doc(_dateUid)
        .get();
  }

  // Starts date so friends can be notified
  Future<void> updateDateUid(String _userId, String _dateID) async {
    if (kDebugMode) {
      print("user_database.dart - updateDateStarted()");
    }
    try {
      await _db
          .collection(dates)
          .doc(_userId)
          .collection(dateDetails)
          .doc(_dateID)
          .update(
        {
          "uid": _dateID,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("user_database.dart - updateDateStarted() - Error: " +
            e.toString());
      }
    }
  }

  // Starts date so friends can be notified
  Future<void> updateDateStarted(
      String _userId, String _dateID, bool _dateStatus) async {
    if (kDebugMode) {
      print("user_database.dart - updateDateStarted()");
    }
    try {
      await _db
          .collection(dates)
          .doc(_userId)
          .collection(dateDetails)
          .doc(_dateID)
          .update(
        {
          "dateStarted": _dateStatus,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Delete Date Details
  Future<void> deleteDateDetails(
      String _uid, DateDetailsModel _dateDetails) async {
    if (kDebugMode) {
      print("date_database.dart - deleteDateDetails()");
    }
    try {
      await _db
          .collection(dates)
          .doc(_uid)
          .collection(dateDetails)
          .doc(_dateDetails.uid)
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  getDateId() {}
}
