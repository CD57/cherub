// auth_provider.dart - Provider for the apps authentication, managing account data.

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navService;
  late final DatabaseService _dbService;
  late final StorageService _storageService;
  late UserModel user;
  late bool loggedIn = false;
  late bool authorised = false;
  final CollectionReference<Map<String, dynamic>> usersRef =
      FirebaseFirestore.instance.collection('Users');

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _navService = GetIt.instance.get<NavigationService>();
    _dbService = GetIt.instance.get<DatabaseService>();
    _storageService = GetIt.instance.get<StorageService>();
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
                  "userId": _user.uid,
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
                    "auth_provider.dart - AuthProvider() - No User Data Found");
              }
              authorised = false;
              if (_navService.getRoute() != '/login') {
                _navService.goToRoute('/login');
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
        print("auth_provider.dart - emailLogin() - Signed In: " +
            _auth.currentUser!.email.toString());
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

  Future<String?> userRegister(String _email, String _password, String _name,
      String _username, String _number, XFile? _profileImage) async {
    String _imageURL;
    if (kDebugMode) {
      print("auth_provider.dart - userRegister()");
    }
    try {
      // Create User in Firebase Auth
      if (kDebugMode) {
        print(
            "auth_provider.dart - userRegister() - Trying to Create New User in Firebase Auth");
      }
      UserCredential _credentials = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      if (kDebugMode) {
        print(
            "auth_provider.dart - userRegister() - User Created in Firebase Auth");
      }

      // Save Picture to Firebase Database
      if (kDebugMode) {
        print(
            "auth_provider.dart - userRegister() - Trying to save User Picture  to Firebase Databas");
      }
      if (_profileImage != null) {
        _imageURL =
            (await _storageService.saveProfilePicture(_email, _profileImage))!;
        if (kDebugMode) {
          print(
              "auth_provider.dart - userRegister() - User Profile Picture Saved to Firebase Database");
        }
      } else {
        _imageURL =
            "https://firebasestorage.googleapis.com/v0/b/cherub-app.appspot.com/o/images%2Fdefault%2FNoPicture%2FUser-NoProfile-PNG.png?alt=media&token=4e098702-0f8c-4eb4-b670-9ac2035dbe3c";
        if (kDebugMode) {
          print(
              "auth_provider.dart - userRegister() - Default Profile Picture Used");
        }
      }

      // Create User in Firebase Database
      await _dbService.createUser(
          _credentials.user!.uid, _username, _name, _number, _email, _imageURL);
      if (kDebugMode) {
        print(
            "auth_provider.dart - userRegister() - User Created in Firebase Database");
      }

      //Set Account Details for Firebase Auth
      await setAccountDetails(_username, _imageURL, _email, _password);
      if (kDebugMode) {
        print(
            "auth_provider.dart - userRegister() - User Details Set in Firebase Auth User Details");
      }

      if (kDebugMode) {
        print("auth_provider.dart - userRegister() - User Signed In");
      }
    } on FirebaseAuthException {
      if (kDebugMode) {
        print("auth_provider.dart - userRegister() - Error registering user.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("auth_provider.dart - userRegister() - Error - " + e.toString());
      }
    }
    return null;
  }

  Future<void> setAccountDetails(String _displayName, String _photoURL,
      String _email, String _password) async {
    if (kDebugMode) {
      print("auth_provider.dart - setAccountDetails");
    }
    try {
      await _auth.currentUser!.updateDisplayName(_displayName);
      await _auth.currentUser!.updatePhotoURL(_photoURL);
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      if (kDebugMode) {
        print("auth_provider.dart - setAccountDetails - " +
            _auth.currentUser!.displayName.toString());
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
