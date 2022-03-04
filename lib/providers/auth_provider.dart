import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../models/user_model.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class AuthProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navService;
  late final DatabaseService _dbService;
  late UserModel user;

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _navService = GetIt.instance.get<NavigationService>();
    _dbService = GetIt.instance.get<DatabaseService>();
    _auth.signOut();
    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        if (kDebugMode) {
          print("auth_provider - User Authorised");
        }
        _dbService.updateLastActive(_user.uid);
        _dbService.getUser(_user.uid).then(
          (_snapshot) {
            Map<String, dynamic> _userData =
                _snapshot.data()! as Map<String, dynamic>;
            user = UserModel.fromJSON(
              {
                "uid": _user.uid,
                "name": _userData["name"],
                "number": _userData["number"],
                "email": _userData["email"],
                "lastActive": _userData["lastActive"],
                "imageURL": _userData["imageURL"],
              },
            );
            if (kDebugMode) {
              print(user.toMap());
            }
            _navService.removeAndGoToRoute('/home');
          },
        );
      } else {
        if (kDebugMode) {
          print("auth_provider - User Not Authorised");
        }
        if (_navService.getRoute() != '/login') {
          _navService.removeAndGoToRoute('/login');
        }
      }
    });
  }

  Future<void> emailLogin(String _email, String _password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
    } on FirebaseAuthException {
      if (kDebugMode) {
        print("Error: Could Not Login Into Firebase");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<String?> emailRegister(String _email, String _password) async {
    try {
      UserCredential _credentials = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      return _credentials.user!.uid;
    } on FirebaseAuthException {
      if (kDebugMode) {
        print("Error registering user.");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return "Error";
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
