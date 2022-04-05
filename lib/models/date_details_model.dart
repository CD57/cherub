// date_details_model.dart - Model class containing the details of a users date, such as time, location and check-in time
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DateDetailsModel {
  late String hostID;
  late String datePlan;
  late Timestamp dateTime;
  late Timestamp checkInTime;
  late LatLng dateGPS;

  DateDetailsModel({
    required this.hostID,
    required this.datePlan,
    required this.dateTime,
    required this.checkInTime,
    required this.dateGPS,
  });

  factory DateDetailsModel.fromJSON(Map<String, dynamic> _json) {
    return DateDetailsModel(
      hostID: _json["hostID"],
      datePlan: _json["datePlan"],
      dateTime: _json["dateTime"],
      checkInTime: _json["checkInTime"],
      dateGPS: _json["dateGPS"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "hostID": hostID,
      "datePlan": datePlan,
      "dateTime": dateTime,
      "checkInTime": checkInTime,
      "dateGPS": dateGPS,
    };
  }
}
