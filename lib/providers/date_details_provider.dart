import 'package:cherub/models/date_details_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import '../services/database_service.dart';
import 'auth_provider.dart';

class DetailsProvider extends ChangeNotifier {
  final AuthProvider _auth;
  late final DatabaseService _dbService;
  DateDetailsModel? aDateDetails;

  DetailsProvider(this._auth) {
    aDateDetails = aDateDetails;
    _dbService = GetIt.instance.get<DatabaseService>();
  }

  void createDate() async {
    try {
      //Create Date Details
      await _dbService.createDateDetails(_auth.user.userId, {
        "hostID": _auth.user.userId,
        "datePlan": aDateDetails!.datePlan,
        "dateTime": aDateDetails!.dateTime,
        "checkInTime": aDateDetails!.checkInTime,
        "dateGPS": aDateDetails!.dateGPS,
      });
      notifyListeners();
      if (kDebugMode) {
        print("contacts_provider.dart - createDate() - Date Details Created");
      }
    } catch (e) {
      if (kDebugMode) {
        print("contacts_provider.dart - createDate() - Error");
        print(e);
      }
    }
  }
}
