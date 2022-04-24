// database_service.dart - Service to manage database connection and actions
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


const String users = "Users";
const String dates = "Dates";
const String chats = "Chats";
const String messages = "Messages";
const String sessions = "Sessions";
const String locations = "Locations";
const String dateDetails = "DateDetails";
const String friends = "Friends";
const String userFriends = "UserFriends";
const String userRequests = "UserRequests";

class UserDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  UserDatabase();

  // Create User
  Future<void> createUser(String _uid, String _username, String _name,
      String _number, String _email, String _imageURL) async {
    if (kDebugMode) {
      print("database_service.dart - createUser()");
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
      print("database_service.dart - getUserByID()");
    }
    return _db.collection(users).doc(_uid).get();
  }

  // Get All Users
  Future<QuerySnapshot> getAllUsers({String? name}) {
    if (kDebugMode) {
      print("database_service.dart - getAllUsers()");
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
      print("database_service.dart - updateLastActive()");
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
}
