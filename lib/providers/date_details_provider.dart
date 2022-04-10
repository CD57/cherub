//
import 'package:cherub/models/date_details_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import '../services/database_service.dart';
import 'auth_provider.dart';

class DetailsProvider extends ChangeNotifier {
  final AuthProvider _auth;
  late DatabaseService _dbService;
  late DateDetailsModel aDateDetails;
  late List<DateDetailsModel> _dateDetailsList;

  DetailsProvider(this._auth) {
    aDateDetails = aDateDetails;
    _dbService = GetIt.instance.get<DatabaseService>();
  }

  void createDate() async {
    try {
      //Create Date Details
      await _dbService.createDateDetailsFromObject(_auth.user.userId, aDateDetails);
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

  // void getDates() async {
  //   _dateDetailsList = [];
  //   try {
  //     _dbService.getDateDetails().then(
  //       (_snapshot) {
  //         _dateDetailsList = _snapshot.docs.map(
  //           (_doc) {
  //             Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
  //             _data["userId"] = _doc.id;
  //             return DateDetailsModel.fromJSON(_data);
  //           },
  //         ).toList();
  //         notifyListeners();
  //       },
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("contacts_provider.dart - getUsers() - Error");
  //       print(e);
  //     }
  //   }
  // }
}
