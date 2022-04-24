class LocationData {
  final String dateUid;
  final String gpsLocation;
  final DateTime timeOfUpdate;

  LocationData({
    required this.dateUid,
    required this.gpsLocation,
    required this.timeOfUpdate,
  });

  factory LocationData.fromJSON(Map<String, dynamic> _json) {
    return LocationData(
      dateUid: _json["dateUid"],
      gpsLocation: _json["gpsLocation"],
      timeOfUpdate: _json["timeOfUpdate"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "dateUid": dateUid,
      "gpsLocation": gpsLocation,
      "timeOfUpdate": timeOfUpdate,
    };
  }
} 
