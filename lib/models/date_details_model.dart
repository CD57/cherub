// date_details_model.dart - Model class containing the details of a users date, such as time, location and check-in time
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class DateDetailsModel {
  late String hostID;
  late String datePlan;
  late Timestamp dayOfDate;
  late Timestamp dateTime;
  late Timestamp checkInTime;
  late String dateGPS;

  DateDetailsModel({
    required this.hostID,
    required this.datePlan,
    required this.dayOfDate,
    required this.dateTime,
    required this.checkInTime,
    required this.dateGPS,
  });

  factory DateDetailsModel.fromJSON(Map<String, dynamic> _json) {
    return DateDetailsModel(
      hostID: _json["hostID"],
      datePlan: _json["datePlan"],
      dayOfDate: _json["dayOfDate"],
      dateTime: _json["dateTime"],
      checkInTime: _json["checkInTime"],
      dateGPS: _json["dateGPS"],
    );
  }

  factory DateDetailsModel.fromDocument(DocumentSnapshot _doc) {
    return DateDetailsModel(
      hostID: _doc["hostID"],
      datePlan: _doc["datePlan"],
      dayOfDate: _doc["dayOfDate"],
      dateTime: _doc["dateTime"],
      checkInTime: _doc["checkInTime"],
      dateGPS: _doc["dateGPS"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "hostID": hostID,
      "datePlan": datePlan,
      "dayOfDate": dayOfDate,
      "dateTime": dateTime,
      "checkInTime": checkInTime,
      "dateGPS": dateGPS,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'DateDetailsModel(hostID: $hostID, datePlan: $datePlan, dayOfDate: $dayOfDate, dateTime: $dateTime, checkInTime: $checkInTime, dateGPS: $dateGPS)';
  }
}
