// contacts_provider.dart - Provider for the apps contacts managment

import 'package:cherub/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import '../models/cherubs_model.dart';
import '../models/date_session_model.dart';
import '../pages/date_activities/session_page.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import 'auth_provider.dart';

class DateDetailsProvider extends ChangeNotifier {
  final AuthProvider _auth;
  late DatabaseService _db;
  late NavigationService _navigation;

  DateDetailsProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
  }

  void createAndGoToSession(String dateUid) async {
    if (kDebugMode) {
      print("date_details_provider.dart - createAndGoToSession()");
    }
    //try {
      // Get Cherubs List
      List<String> _cherubIds = [];
      DocumentSnapshot doc = await _db.dateDb.getCherubList(_auth.user.userId, dateUid);
      CherubModel cherubsList = CherubModel.fromSnapshot(doc);

      for (String cherubID in cherubsList.cherubs) {
        _cherubIds.add(cherubID);
      }

      // Create Session
      DocumentReference? _doc = await _db.sessionDb.createSession(
        {
          "cherubs": _cherubIds,
        },
      );
      //Navigate To Chat Page
      List<UserModel> _cherubs = [];
      for (var _uid in _cherubIds) {
        DocumentSnapshot _userSnapshot = await _db.userDb.getUserByID(_uid);
        Map<String, dynamic> _userData =
            _userSnapshot.data() as Map<String, dynamic>;
        _userData["userId"] = _userSnapshot.id;
        _cherubs.add(
          UserModel.fromJSON(
            _userData,
          ),
        );
      }
      SessionPage _sessionPage = SessionPage(
        dateSession: DateSession(
          sessionUid: _doc!.id,
          dateUid: _auth.user.userId,
          cherubs: _cherubs,
          locations: [],
        ),
      );
      notifyListeners();
      _navigation.goToPage(_sessionPage);
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("date_details_provider.dart - createAndGoToSession() - Error");
    //     print(e);
    //   }
    // }
  }
}
