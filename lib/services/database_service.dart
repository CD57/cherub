// database_service.dart - Service to manage database connection and actions

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/date_message_model.dart';

const String users = "Users";
const String dates = "Dates";
const String messages = "Messages";
const String plans = "Plans";
const String dateDetails = "DateDetails";
const String userFriends = "UserFriends";
const String userRequests = "UserRequests";
class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DatabaseService();

  // Create User
  Future<void> createUser(String _uid, String _username, String _name, String _number,
      String _email, String _imageURL) async {
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
      print("database_service.dart - getUser()");
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

  // Gets All Users Date Chats
  Stream<QuerySnapshot> getDateChats(String _uid) {
    if (kDebugMode) {
      print("database_service.dart - getDateChats()");
    }
    try {
    return _db
        .collection(dates)
        .where('contacts', arrayContains: _uid)
        .snapshots();
        } catch (e) {
      if (kDebugMode) {
        print("database_service.dart - getDateChats() - FAILED: " + e.toString());
      }
      return _db
        .collection(dates)
        .where('contacts', arrayContains: _uid)
        .snapshots();
    }
  }

  // Get Last Message of Date Chat
  Future<QuerySnapshot> getLastMessage(String _dateID) {
    if (kDebugMode) {
      print("database_service.dart - getLastMessage()");
    }
    return _db
        .collection(dates)
        .doc(_dateID)
        .collection(messages)
        .orderBy("sentTime", descending: true)
        .limit(1)
        .get();
  }

  // Listen to stream of select dates messages
  Stream<QuerySnapshot> streamMessages(String _dateID) {
    if (kDebugMode) {
      print("database_service.dart - streamMessages()");
    }
    return _db
        .collection(dates)
        .doc(_dateID)
        .collection(messages)
        .orderBy("sentTime", descending: false)
        .snapshots();
  }

  // Add message to date chat
  Future<void> addMessage(String _dateID, DateMessage _message) async {
    if (kDebugMode) {
      print("database_service.dart - addMessage()");
    }
    try {
      await _db.collection(dates).doc(_dateID).collection(messages).add(
            _message.toJson(),
          );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Update users date chat
  Future<void> updateDateChat(
      String _dateID, Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("database_service.dart - updateChat()");
    }
    try {
      await _db.collection(dates).doc(_dateID).update(_data);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Get Last Active Time of Users
  Future<void> updateLastActiveTime(String _uid) async {
    if (kDebugMode) {
      print("database_service.dart - updateLastActiveTime()");
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

  // Create Date Chat
  Future<DocumentReference?> createDateChat(Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("database_service.dart - createDateChat()");
    }
    try {
      DocumentReference _dateChat = await _db.collection(dates).add(_data);
      return _dateChat;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // Delete Date Chat
  Future<void> deleteDateChat(String _dateID) async {
    if (kDebugMode) {
      print("database_service.dart - deleteDateChat()");
    }
    try {
      await _db.collection(dates).doc(_dateID).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Create Date Details
  Future<DocumentReference?> createDateDetails(Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("database_service.dart - createDateDetails()");
    }
    try {
      DocumentReference _dateDetails = await _db.collection(dateDetails).add(_data);
      return _dateDetails;
    } catch (e) {
      if (kDebugMode) {
        print("createDateDetails: Error - " + e.toString());
      }
      return null;
    }
  }

  // Delete Date Details
  Future<void> deleteDateDetails(String _dateDetailsID) async {
    if (kDebugMode) {
      print("database_service.dart - deleteDateDetails()");
    }
    try {
      await _db.collection(dates).doc(_dateDetailsID).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Create Date Details
  Future<DocumentReference?> createFriendRequest(Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("database_service.dart - createFriendRequest()");
    }
    try {
      DocumentReference _friendRequestDoc = await _db.collection(userRequests).add(_data);
      return _friendRequestDoc;
    } catch (e) {
      if (kDebugMode) {
        print("createDateDetails: Error - " + e.toString());
      }
      return null;
    }
  }

  // Accept Friend Request
  Future<DocumentReference?> acceptFriendRequest(String _uid, Map<String, dynamic> _data, String _friendRequestID) async {
    if (kDebugMode) {
      print("database_service.dart - acceptFriendRequest()");
    }
    try {
      DocumentReference _friendAcceptDoc = await _db.collection("Friends").doc(_uid).collection(userFriends).add(_data);
      await _db.collection(dates).doc(_friendRequestID).delete();
      return _friendAcceptDoc;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // Cancel Friend Request
  Future<void> cancelFriendRequest(String _friendRequestID) async {
    if (kDebugMode) {
      print("database_service.dart - cancelFriendRequest()");
    }
    try {
      await _db.collection(dates).doc(_friendRequestID).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
