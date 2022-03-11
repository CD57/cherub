// date_details_model.dart - Model class containing the details of a users date, such as time, location and check-in time

import 'package:google_maps_flutter/google_maps_flutter.dart';

class DateDetailsModel {
  final String uid;
  late String dateUid;
  late String datePlan;
  late String dateType;
  late DateTime dateTime;
  late DateTime checkpointTime;
  late LatLng dateGPS;

  DateDetailsModel({
    required this.uid,
    required this.dateUid,
    required this.datePlan,
    required this.dateType,
    required this.dateTime,
    required this.checkpointTime,
    required this.dateGPS,
  });

  factory DateDetailsModel.fromJSON(Map<String, dynamic> _json) {
    return DateDetailsModel(
      uid: _json["uid"],
      dateUid: _json["dateUid"],
      datePlan: _json["datePlan"],
      dateType: _json["dateType"],
      dateTime: _json["dateTime"].toDate(),
      checkpointTime: _json["checkpointTime"].toDate(), 
      dateGPS: _json["dateGPS"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "dateUid": dateUid,
      "datePlan": datePlan,
      "dateType": dateType,
      "dateTime": dateTime,
      "checkpointTime": checkpointTime,
      "dateGPS": dateGPS,
    };
  }
}
