import 'package:cherub/models/user_model.dart';

import 'location_data_model.dart';

class DateSession {
  final String sessionUid;
  final String dateUid;
  final List<UserModel> cherubs;
  final List<LocationData> locations;

  late final List<UserModel> _received;

  DateSession(
      {required this.sessionUid,
      required this.dateUid,
      required this.cherubs,
      required this.locations}) {
    _received = cherubs.where((_data) => _data.userId != dateUid).toList();
  }

  List<UserModel> received() {
    return _received;
  }
}
