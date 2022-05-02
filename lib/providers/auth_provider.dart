// auth_provider.dart - Provider for the apps authentication, managing account data.

import 'package:cherub/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  late final FirebaseAuth authUser;
  late final NavigationService _navService;
  late final DatabaseService _dbService;
  late final StorageService _storageService;
  late final NotificationService _notificationService;
  late UserModel user;
  late bool loggedIn = false;
  late bool authorised = false;
  late bool activeDate = false;
  final CollectionReference<Map<String, dynamic>> usersRef =
      FirebaseFirestore.instance.collection('Users');

  AuthProvider() {
    authUser = FirebaseAuth.instance;
    _navService = GetIt.instance.get<NavigationService>();
    _dbService = GetIt.instance.get<DatabaseService>();
    _storageService = GetIt.instance.get<StorageService>();
    _notificationService = GetIt.instance.get<NotificationService>();
    
    authUser.authStateChanges().listen((_user) {
      if (_user != null && (authUser.currentUser?.uid == _user.uid)) {
        if (kDebugMode) {
          print("auth_provider.dart - AuthProvider() - User Found");
        }
        authorised = true;
        _dbService.userDb.updateLastActive(_user.uid);
        _dbService.userDb.getUserByID(_user.uid).then(
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

  Future<bool> emailLogin(String _email, String _password) async {
    if (kDebugMode) {
      print("auth_provider.dart - emailLogin()");
    }
    try {
      await authUser.signInWithEmailAndPassword(
          email: _email, password: _password);
      if (kDebugMode) {
        print("emailLogin() - Signed In: " +
            authUser.currentUser!.email.toString());
      }
      return true;
    } on FirebaseAuthException {
      if (kDebugMode) {
        print("emailLogin() - Error: Could Not Login Into Firebase");
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("emailLogin() - " + e.toString());
      }
      return false;
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
      UserCredential _credentials = await authUser
          .createUserWithEmailAndPassword(email: _email, password: _password);
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
      await _dbService.userDb.createUser(
          _credentials.user!.uid, _username, _name, _number, _email, _imageURL);
      if (kDebugMode) {
        print(
            "auth_provider.dart - userRegister() - User Created in Firebase Database");
      }

      // Subscribe to friends request updates
      await FirebaseMessaging.instance
          .subscribeToTopic(_credentials.user!.uid)
          .then((value) => {
                // ignore: avoid_print
                print("auth_provider.dart -  User " +
                    _credentials.user!.uid +
                    " subscribed to friend updates")
              });

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
      await authUser.currentUser!.updateDisplayName(_displayName);
      await authUser.currentUser!.updatePhotoURL(_photoURL);
      await authUser
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((value) => _notificationService.setToken(value.user!.uid));
      if (kDebugMode) {
        print("auth_provider.dart - setAccountDetails - " +
            authUser.currentUser!.displayName.toString());
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

  Future<void> updatePhoneNumber(String _phoneNumber) async {
    if (kDebugMode) {
      print("auth_provider.dart - setAccountDetails");
    }
    _dbService.userDb.updateUserPhoneNumber(user.userId, _phoneNumber);
  }

  Future<void> logout() async {
    authorised = false;
    if (kDebugMode) {
      print("auth_provider.dart - logout()");
    }
    try {
      await authUser.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
