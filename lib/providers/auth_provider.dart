// auth_provider.dart - Provider for the apps authentication, managing account data.

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
  late bool authorised = false;

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _navService = GetIt.instance.get<NavigationService>();
    _dbService = GetIt.instance.get<DatabaseService>();
    _auth.authStateChanges().listen((_user) {
      if (_user != null && (_auth.currentUser?.uid == _user.uid)) {
        if (kDebugMode) {
          print("auth_provider.dart - AuthProvider() - User Found");
        }
        authorised = true;
        _dbService.updateLastActive(_user.uid);
        _dbService.getUserByID(_user.uid).then(
          (_snapshot) {
            if (_snapshot.data() != null) {
              Map<String, dynamic> _userData =
                  _snapshot.data()! as Map<String, dynamic>;
              user = UserModel.fromJSON(
                {
                  "uid": _user.uid,
                  "username": _userData["username"],
                  "name": _userData["name"],
                  "number": _userData["number"],
                  "email": _userData["email"],
                  "lastActive": _userData["lastActive"],
                  "imageURL": _userData["imageURL"],
                },
              );
              if (kDebugMode) {
                print("User: " + user.toMap().toString());
              }
              authorised = true;
              _navService.removeAndGoToRoute('/home');
            } else {
              if (kDebugMode) {
                print(
                    "auth_provider.dart - AuthProvider() - No User Data Found - Returning to login");
              }
              authorised = false;
              if (_navService.getRoute() != '/login') {
                _navService.removeAndGoToRoute('/login');
              }
            }
          },
        );
      } else {
        if (kDebugMode) {
          print("auth_provider.dart - AuthProvider() - User Not Authorised");
        }
        authorised = false;
        if (_navService.getRoute() != '/login') {
          _navService.removeAndGoToRoute('/login');
        }
      }
    });
  }

  Future<void> emailLogin(String _email, String _password) async {
    if (kDebugMode) {
      print("auth_provider.dart - emailLogin()");
    }
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      if (kDebugMode) {
        print("auth_provider.dart - emailLogin() - Signed In: " + _auth.currentUser!.email.toString());
      }
    } on FirebaseAuthException {
      if (kDebugMode) {
        print(
            "auth_provider.dart - emailLogin() - Error: Could Not Login Into Firebase");
      }
    } catch (e) {
      if (kDebugMode) {
        print("auth_provider.dart - emailLogin() - " + e.toString());
      }
    }
  }

  Future<String?> emailRegister(String _email, String _password) async {
    if (kDebugMode) {
      print("auth_provider.dart - emailRegister()");
    }
    try {
      UserCredential _credentials = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      return _credentials.user!.uid;
    } on FirebaseAuthException {
      if (kDebugMode) {
        print("auth_provider.dart - emailRegister() - Error registering user.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("auth_provider.dart - emailRegister() - Error - " + e.toString());
      }
    }
    return null;
  }

  Future<void> setAccountDetails(String _displayName, String _photoURL) async {
    if (kDebugMode) {
      print("auth_provider.dart - setAccountDetails");
    }
    try {
      await _auth.currentUser!.updateDisplayName(_displayName);
      await _auth.currentUser!.updatePhotoURL(_photoURL);
      if (kDebugMode) {
        print("auth_provider.dart - " +
            _auth.currentUser!.displayName.toString() +
            _auth.currentUser!.photoURL.toString());
      }
    } on FirebaseAuthException {
      if (kDebugMode) {
        print("auth_provider.dart - Error updating account details");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> logout() async {
    authorised = false;
    if (kDebugMode) {
      print("auth_provider.dart - logout()");
    }
    try {
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
