import 'location_data_model.dart';

class DateSession {
  final String dateUid;
  final String gpsLocation;
  final String lastDateUpdate;
  final bool isActive;
  final List<LocationData> locations;
  late final List<LocationData> _received;

  DateSession( 
      {required this.dateUid,
      required this.gpsLocation,
      required this.lastDateUpdate,
      required this.isActive,
      required this.locations}) {
    _received = locations.where((_data) => _data.dateUid != dateUid).toList();
  }

  List<LocationData> received() {
    return _received;
  }
}
