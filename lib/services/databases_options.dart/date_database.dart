// date_database.dart - Service to manage date database connections and actions

import 'package:cherub/models/date_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

const String users = "Users";
const String dates = "Dates";
const String dateDetails = "DateDetails";
const String cherubs = "Cherubs";

class DateDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DateDatabase();

  // Create Date Details
  createDateDetails(
      String _userId, String _dateId, Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("date_database.dart - createDateDetails()");
    }
    try {
      await _db
          .collection(dates)
          .doc(_userId)
          .collection(dateDetails)
          .doc(_dateId)
          .set(_data);
    } catch (e) {
      if (kDebugMode) {
        print("date_database - createDateDetails: Error - " + e.toString());
      }
      return null;
    }
  }

  // Create Cherub List
  createCherubList(
      String _userId, String _dateId, Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("date_database.dart - createDateDetails()");
    }
    try {
      await _db
          .collection(dates)
          .doc(_userId)
          .collection(dateDetails)
          .doc(_dateId)
          .collection(cherubs)
          .doc("Cherubs")
          .set(_data);
    } catch (e) {
      if (kDebugMode) {
        print("date_database - createDateDetails: Error - " + e.toString());
      }
      return null;
    }
    return null;
  }

  // // Get Cherub List User Id's
  // Future<List<String>> getCherubsIds(String _userId, String _dateId) async {
  //   if (kDebugMode) {
  //     print("friend_database.dart - getFriendsID()");
  //   }
  //   DocumentSnapshot<Map<String, dynamic>> querySnapshot =
  //       await _db
  //         .collection(dates)
  //         .doc(_userId)
  //         .collection(dateDetails)
  //         .doc(_dateId)
  //         .collection(cherubs)
  //         .doc("Cherubs").get();

  //   List<Date> result = <String>[];
  //   for (var doc in querySnapshot) {
  //     if (kDebugMode) {
  //       print(doc["CherubID"]);
  //     }
  //     result.add(doc["CherubID"]);
  //   }
  //   return result;
  // }

  // Get Cherub List
  Future<DocumentSnapshot<Object?>> getCherubList(
      String _userId, String _dateId) async {
    if (kDebugMode) {
      print("date_database.dart - createDateDetails()");
    }
    try {
      return await _db
          .collection(dates)
          .doc(_userId)
          .collection(dateDetails)
          .doc(_dateId)
          .collection(cherubs)
          .doc("Cherubs")
          .get();
    } catch (e) {
      if (kDebugMode) {
        print("date_database - createDateDetails: Error - " + e.toString());
      }
      return await _db
          .collection(dates)
          .doc(_userId)
          .collection(dateDetails)
          .doc(_dateId)
          .collection(cherubs)
          .doc("Cherubs")
          .get();
    }
  }

  // Get Date Details
  Future<DocumentSnapshot> getDateDetails(String _uid) {
    if (kDebugMode) {
      print("date_database.dart - getDateDetailsByID()");
    }
    return _db.collection(dates).doc(_uid).get();
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
