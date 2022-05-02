// date_details_model.dart - Model class containing the details of a users date, such as time, location and check-in time
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class DateDetailsModel {
  late String uid;
  late String hostUid;
  late String datesUserId;
  late String datePlan;
  late Timestamp dayOfDate;
  late Timestamp dateTime;
  late Timestamp checkInTime;
  late String dateGPS;
  late bool dateStarted;

  DateDetailsModel(
      {required this.uid,
      required this.hostUid,
      required this.datesUserId,
      required this.datePlan,
      required this.dayOfDate,
      required this.dateTime,
      required this.checkInTime,
      required this.dateGPS,
      required this.dateStarted});

  factory DateDetailsModel.fromJSON(Map<String, dynamic> _json) {
    return DateDetailsModel(
        uid: _json["uid"],
        hostUid: _json["hostUid"],
        datesUserId: _json["datesUserId"],
        datePlan: _json["datePlan"],
        dayOfDate: _json["dayOfDate"],
        dateTime: _json["dateTime"],
        checkInTime: _json["checkInTime"],
        dateGPS: _json["dateGPS"],
        dateStarted: _json["dateStarted"]);
  }

  factory DateDetailsModel.fromDocument(DocumentSnapshot _doc) {
    return DateDetailsModel(
      uid: _doc["uid"],
      hostUid: _doc["hostUid"],
      datesUserId: _doc["datesUserId"],
      datePlan: _doc["datePlan"],
      dayOfDate: _doc["dayOfDate"],
      dateTime: _doc["dateTime"],
      checkInTime: _doc["checkInTime"],
      dateGPS: _doc["dateGPS"],
      dateStarted: _doc["dateStarted"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "hostUid": hostUid,
      "datesUserId": datesUserId,
      "datePlan": datePlan,
      "dayOfDate": dayOfDate,
      "dateTime": dateTime,
      "checkInTime": checkInTime,
      "dateGPS": dateGPS,
      "dateStarted": dateStarted
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return "DateDetailsModel(uid: $uid, hostUid: $hostUid, datesUserId: $datesUserId, datePlan: $datePlan, dayOfDate: $dayOfDate, dateTime: $dateTime, checkInTime: $checkInTime, dateGPS: $dateGPS";
  }
}
