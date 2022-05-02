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
      print("date_database.dart - getDateDetailsByID()");
    }
    return _db.collection(dates).doc(_hostUid).collection(dateDetails).doc(_dateUid).get();
  }

  // Update date chat
  Future<void> updateDateDetails(
      String _dateID, Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("date_database.dart - updateDateDetails()");
    }
    try {
      await _db.collection(dates).doc(_dateID).update(_data);
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
      QuerySnapshot datesSnapshot = await _db
          .collection(dates)
          .doc(_uid)
          .collection(dateDetails)
          .where("dateGPS", isGreaterThanOrEqualTo: _dateDetails.dateGPS)
          .where("dateGPS", isLessThanOrEqualTo: _dateDetails.dateGPS + "z")
          .get();

      for (var dateDoc in datesSnapshot.docs) {
        var dateDocID = dateDoc.id;
        await _db
            .collection(dates)
            .doc(_uid)
            .collection(dateDetails)
            .doc(dateDocID)
            .delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
