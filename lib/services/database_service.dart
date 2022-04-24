// database_service.dart - Service to manage database connection and actions

import 'package:cherub/models/date_details_model.dart';
import 'package:cherub/models/location_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/date_message_model.dart';

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

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DatabaseService();

//-------------------------------------------------------------------------------------------------
  // @@@@@ USER DATABASE OPTIONS @@@@@
//-------------------------------------------------------------------------------------------------

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

//-------------------------------------------------------------------------------------------------
  // @@@@@ CHAT DATABASE OPTIONS @@@@@
//-------------------------------------------------------------------------------------------------

  // Create Date Chat
  Future<DocumentReference?> createDateChat(Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("database_service.dart - createDateChat()");
    }
    try {
      DocumentReference _dateChat = await _db.collection(chats).add(_data);
      return _dateChat;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // Gets All Users Date Chats
  Stream<QuerySnapshot> getDateChats(String _uid) {
    if (kDebugMode) {
      print("database_service.dart - getDateChats()");
    }
    try {
      return _db
          .collection(chats)
          .where('contacts', arrayContains: _uid)
          .snapshots();
    } catch (e) {
      if (kDebugMode) {
        print(
            "database_service.dart - getDateChats() - FAILED: " + e.toString());
      }
      return _db
          .collection(chats)
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
        .collection(chats)
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
        .collection(chats)
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
      await _db.collection(chats).doc(_dateID).collection(messages).add(
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
      await _db.collection(chats).doc(_dateID).update(_data);
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

  // Delete Date Chat
  Future<void> deleteDateChat(String _dateID) async {
    if (kDebugMode) {
      print("database_service.dart - deleteDateChat()");
    }
    try {
      await _db.collection(chats).doc(_dateID).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

//-------------------------------------------------------------------------------------------------
  // @@@@@ DATE SESSION DATABASE OPTIONS @@@@@
//-------------------------------------------------------------------------------------------------

  // Create Date Session
  Future<DocumentReference?> createDateSession(
      Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("database_service.dart - createDateSession()");
    }
    try {
      DocumentReference _dateSession =
          await _db.collection(sessions).add(_data);
      return _dateSession;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // Gets All Date Sessions
  Stream<QuerySnapshot> getDateSessions(String _uid) {
    if (kDebugMode) {
      print("database_service.dart - getDateSessions()");
    }
    try {
      return _db
          .collection(sessions)
          .where('dateUid', isEqualTo: _uid)
          .snapshots();
    } catch (e) {
      if (kDebugMode) {
        print(
            "database_service.dart - getDateChats() - FAILED: " + e.toString());
      }
      return _db
          .collection(sessions)
          .where('dateUid', isEqualTo: _uid)
          .snapshots();
    }
  }

  // Get Last Message of Date Chat
  Future<QuerySnapshot> getLastLocation(String _dateID) {
    if (kDebugMode) {
      print("database_service.dart - getLastLocation()");
    }
    return _db
        .collection(sessions)
        .doc(_dateID)
        .collection(locations)
        .orderBy("timeOfUpdate", descending: true)
        .limit(1)
        .get();
  }

  // Listen to stream of select dates messages
  Stream<QuerySnapshot> streamLocations(String _dateID) {
    if (kDebugMode) {
      print("database_service.dart - streamLocations()");
    }
    return _db
        .collection(sessions)
        .doc(_dateID)
        .collection(locations)
        .orderBy("timeOfUpdate", descending: false)
        .snapshots();
  }

  // Add message to date chat
  Future<void> addLocationData(String _dateID, LocationData _location) async {
    if (kDebugMode) {
      print("database_service.dart - addLocationData()");
    }
    try {
      await _db.collection(sessions).doc(_dateID).collection(locations).add(
            _location.toJson(),
          );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Update users date session
  Future<void> updateDateSession(
      String _dateID, Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("database_service.dart - updateDateSession()");
    }
    try {
      await _db.collection(sessions).doc(_dateID).update(_data);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Get Last Active Time of Location Activity
  Future<void> updateLastActiveSessionTime(String _uid) async {
    if (kDebugMode) {
      print("database_service.dart - updateLastActiveSessionTime()");
    }
    try {
      await _db.collection(sessions).doc(_uid).update(
        {
          "lastDateUpdate": DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Delete Date Session
  Future<void> deleteDateSession(String _dateID) async {
    if (kDebugMode) {
      print("database_service.dart - deleteDateChat()");
    }
    try {
      await _db.collection(sessions).doc(_dateID).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

//-------------------------------------------------------------------------------------------------
  // @@@@@ FRIEND DATABASE OPTIONS @@@@@
//-------------------------------------------------------------------------------------------------

  // Get Friend
  Future<List<String>> getFriendsID(String uid) async {
    if (kDebugMode) {
      print("database_service.dart - getFriendsID()");
    }

    QuerySnapshot querySnapshot =
        await _db.collection(friends).doc(uid).collection(userFriends).get();

    List<String> result = <String>[];
    for (var doc in querySnapshot.docs) {
      if (kDebugMode) {
        print(doc["FriendId"]);
      }
      result.add(doc["FriendId"]);
    }
    return result;
  }

  // Delete Friend
  Future<void> deleteFriend(String userID, String friendID) async {
    if (kDebugMode) {
      print("database_service.dart - deleteFriend()");
    }
    try {
      QuerySnapshot userSnapshot = await _db
          .collection(friends)
          .doc(userID)
          .collection(userFriends)
          .where("FriendId", isGreaterThanOrEqualTo: friendID)
          .where("FriendId", isLessThanOrEqualTo: friendID + "z")
          .get();

      for (var doc1 in userSnapshot.docs) {
        var friendDocID = doc1.id;
        await _db
            .collection(friends)
            .doc(userID)
            .collection(userFriends)
            .doc(friendDocID)
            .delete();
      }

      QuerySnapshot friendSnapshot = await _db
          .collection(friends)
          .doc(friendID)
          .collection(userFriends)
          .where("FriendId", isGreaterThanOrEqualTo: userID)
          .where("FriendId", isLessThanOrEqualTo: userID + "z")
          .get();

      for (var doc2 in friendSnapshot.docs) {
        var friendDocID2 = doc2.id;
        await _db
            .collection(friends)
            .doc(friendID)
            .collection(userRequests)
            .doc(friendDocID2)
            .delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print("deleteFriendRequest() - ERROR: " + e.toString());
      }
    }
  }

  // Create Friend Request
  Future<DocumentReference?> createFriendRequest(
      Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("database_service.dart - createFriendRequest()");
    }
    try {
      DocumentReference _friendRequestDoc = await _db
          .collection(friends)
          .doc(_data["To"])
          .collection(userRequests)
          .add(_data);
      _friendRequestDoc = await _db
          .collection(friends)
          .doc(_data["From"])
          .collection(userRequests)
          .add(_data);
      return _friendRequestDoc;
    } catch (e) {
      if (kDebugMode) {
        print("createFriendRequest: Error - " + e.toString());
      }
      return null;
    }
  }

  // Get Friend Requests
  Future<List<String>> getFriendRequests(String uid) async {
    if (kDebugMode) {
      print("database_service.dart - getFriendRequests()");
    }

    QuerySnapshot querySnapshot = await _db
        .collection(friends)
        .doc(uid)
        .collection(userRequests)
        .where("To", isGreaterThanOrEqualTo: uid)
        .where("To", isLessThanOrEqualTo: uid + "z")
        .get();

    List<String> result = <String>[];
    for (var doc in querySnapshot.docs) {
      if (kDebugMode) {
        print(doc["From"]);
      }
      result.add(doc["From"]);
    }
    return result;
  }

  // Accept Friend Request
  Future<DocumentReference?> acceptFriendRequest(String _uid, String _username,
      String _friendRequestID, String _friendName) async {
    if (kDebugMode) {
      print("database_service.dart - acceptFriendRequest()");
    }
    try {
      DocumentReference _friendAcceptDoc = await _db
          .collection("Friends")
          .doc(_uid)
          .collection(userFriends)
          .add({
        "FriendId": _friendRequestID,
        "FriendName": _friendName,
        "TimeAdded": DateTime.now()
      });

      _friendAcceptDoc = await _db
          .collection("Friends")
          .doc(_friendRequestID)
          .collection(userFriends)
          .add({
        "FriendId": _uid,
        "FriendName": _username,
        "TimeAdded": DateTime.now()
      });

      await deleteFriendRequest(_uid, _friendRequestID);
      await deleteFriendRequest(_friendRequestID, _uid);

      return _friendAcceptDoc;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // Delete Friend Request
  Future<void> deleteFriendRequest(String userID, String friendID) async {
    if (kDebugMode) {
      print("database_service.dart - deleteFriendRequest()");
    }
    try {
      QuerySnapshot fromSnapshot = await _db
          .collection(friends)
          .doc(userID)
          .collection(userRequests)
          .where("From", isGreaterThanOrEqualTo: friendID)
          .where("From", isLessThanOrEqualTo: friendID + "z")
          .get();

      QuerySnapshot toSnapshot = await _db
          .collection(friends)
          .doc(friendID)
          .collection(userRequests)
          .where("To", isGreaterThanOrEqualTo: userID)
          .where("To", isLessThanOrEqualTo: userID + "z")
          .get();

      for (var fromDoc in fromSnapshot.docs) {
        var fromDocID = fromDoc.id;
        await _db
            .collection(friends)
            .doc(userID)
            .collection(userRequests)
            .doc(fromDocID)
            .delete();
      }

      for (var toDoc in toSnapshot.docs) {
        var toDocID = toDoc.id;
        await _db
            .collection(friends)
            .doc(friendID)
            .collection(userRequests)
            .doc(toDocID)
            .delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print("deleteFriendRequest() - ERROR: " + e.toString());
      }
    }
  }

//-------------------------------------------------------------------------------------------------
  // @@@@@ USER DATABASE OPTIONS @@@@@
//-------------------------------------------------------------------------------------------------

  // Create Date Details
  Future<DocumentReference?> createDateDetails(
      String _uid, Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("database_service.dart - createDateDetails()");
    }
    try {
      DocumentReference _dateDetails = await _db
          .collection(dates)
          .doc(_uid)
          .collection(dateDetails)
          .add(_data);
      return _dateDetails;
    } catch (e) {
      if (kDebugMode) {
        print("createDateDetails: Error - " + e.toString());
      }
      return null;
    }
  }

  // Delete Date Details
  Future<void> deleteDateDetails(
      String _uid, DateDetailsModel _dateDetails) async {
    if (kDebugMode) {
      print("database_service.dart - deleteDateDetails()");
    }
    try {
      QuerySnapshot datesSnapshot = await _db
          .collection(dates)
          .doc(_uid)
          .collection(dateDetails)
          .where("dateGPS", isGreaterThanOrEqualTo: _dateDetails.dateGPS)
          .where("dateGPS", isLessThanOrEqualTo: _dateDetails.dateGPS + "z")
          .get();

      for (var dateDoc in datesSnapshot.docs) {
        var dateDocID = dateDoc.id;
        await _db
            .collection(dates)
            .doc(_uid)
            .collection(dateDetails)
            .doc(dateDocID)
            .delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
//-------------------------------------------------------------------------------------------------
}
