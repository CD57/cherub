// date_details_model.dart - Model class containing the details of a users date, such as time, location and check-in time
//import 'package:google_maps_flutter/google_maps_flutter.dart';

class DateDetailsModel {
  //final String uid;
  late String hostID;
  late String datePlan;
  late DateTime dateDay;
  late String dateTime;
  late String checkInTime;
  //late LatLng dateGPS;

  DateDetailsModel({
    //required this.uid,
    required this.hostID,
    required this.datePlan,
    required this.dateDay,
    required this.dateTime,
    required this.checkInTime,
    //required this.dateGPS,
  });

  factory DateDetailsModel.fromJSON(Map<String, dynamic> _json) {
    return DateDetailsModel(
      //uid: _json["uid"],
      hostID: _json["hostID"],
      datePlan: _json["datePlan"],
      dateDay: _json["dateDay"],
      dateTime: _json["dateTime"],
      checkInTime: _json["checkInTime"], 
      //dateGPS: _json["dateGPS"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      //"dateUid": uid,
      "hostID": hostID,
      "datePlan": datePlan,
      "dateDay": dateDay,
      "dateTime": dateTime,
      "checkInTime": checkInTime,
      //"dateGPS": dateGPS,
    };
  }
}
