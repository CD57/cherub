// database_service.dart - Service to manage database connection and actions

import 'package:cherub/models/date_details_model.dart';
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

class DateDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DateDatabase();

  // Create Date Details
  Future<DocumentReference?> createDateDetails(
      String _uid, Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("database_service.dart - createDateDetails()");
    }
    try {
      DocumentReference _dateDetails = await _db
          .collection(dates)
          .doc(_uid)
          .collection(dateDetails)
          .add(_data);
      return _dateDetails;
    } catch (e) {
      if (kDebugMode) {
        print("createDateDetails: Error - " + e.toString());
      }
      return null;
    }
  }

  // Get Date Details By ID
  Future<DocumentSnapshot> getDateDetailsByID(String _uid) {
    if (kDebugMode) {
      print("database_service.dart - getDateDetailsByID()");
    }
    return _db.collection(dates).doc(_uid).get();
  }

  // Delete Date Details
  Future<void> deleteDateDetails(
      String _uid, DateDetailsModel _dateDetails) async {
    if (kDebugMode) {
      print("database_service.dart - deleteDateDetails()");
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
