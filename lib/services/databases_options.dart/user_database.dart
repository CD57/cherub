// user_database.dart - Service to manage user database connection and actions
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

const String users = "Users";

class UserDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  UserDatabase();

  // Create User
  Future<void> createUser(String _uid, String _username, String _name,
      String _number, String _email, String _imageURL) async {
    if (kDebugMode) {
      print("user_database.dart - createUser()");
    }
    try {
      await _db.collection(users).doc(_uid).set(
        {
          "userId": _uid,
          "username": _username,
          "name": _name,
          "number": _number,
          "email": _email,
          "imageURL": _imageURL,
          "lastActive": DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Get User By ID
  Future<DocumentSnapshot> getUserByID(String _uid) {
    if (kDebugMode) {
      print("user_database.dart - getUserByID()");
    }
    return _db.collection(users).doc(_uid).get();
  }

  // Get All Users - Allows for searching
  Future<QuerySnapshot> getAllUsers({String? name}) {
    if (kDebugMode) {
      print("user_database.dart - getAllUsers()");
    }
    Query _query = _db.collection(users);
    if (name != null) {
      _query = _query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: name + "z");
    }
    return _query.get();
  }

  // Update Last Active time for user
  Future<void> updateLastActive(String _uid) async {
    if (kDebugMode) {
      print("user_database.dart - updateLastActive()");
    }
    try {
      await _db.collection(users).doc(_uid).update(
        {
          "lastActive": DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Update User Picture
  Future<void> updateUserPhoto(String _uid, String _imageURL) async {
    if (kDebugMode) {
      print("user_database.dart - updateUserPhoto()");
    }
    try {
      await _db.collection(users).doc(_uid).update(
        {
          "imageURL": _imageURL,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Delete User By ID
  Future<void> deleteUserByID(String _uid) async {
    if (kDebugMode) {
      print("user_database.dart - deleteUserByID()");
    }
    try {
      await _db.collection(users).doc(_uid).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
