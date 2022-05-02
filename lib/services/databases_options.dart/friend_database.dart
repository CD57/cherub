// friend_database.dart - Service to manage friends database connections and actions

import 'package:cherub/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

const String friends = "Friends";
const String userFriends = "UserFriends";
const String userRequests = "UserRequests";
const String userReports = "UserReports";

class FriendDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  FriendDatabase();

  // Create Friend Request
  Future<DocumentReference?> createFriendRequest(
      Map<String, dynamic> _data) async {
    if (kDebugMode) {
      print("friend_database.dart - createFriendRequest()");
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
        print("friend_database - createFriendRequest: Error - " + e.toString());
      }
      return null;
    }
  }

  // Get Friend Requests
  Future<List<String>> getFriendRequests(String uid) async {
    if (kDebugMode) {
      print("friend_database.dart - getFriendRequests()");
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
      print("friend_database.dart - acceptFriendRequest()");
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
      print("friend_database.dart - deleteFriendRequest()");
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
        print(
            "friend_database - deleteFriendRequest() - ERROR: " + e.toString());
      }
    }
  }

  // Get Friend's userId
  Future<List<String>> getFriendsID(String uid) async {
    if (kDebugMode) {
      print("friend_database.dart - getFriendsID()");
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

  // Delete Friend from Friends List
  Future<void> deleteFriend(String userID, String friendID) async {
    if (kDebugMode) {
      print("friend_database.dart - deleteFriend()");
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
        print(
            "friend_database - deleteFriendRequest() - ERROR: " + e.toString());
      }
    }
  }

  createReport(String userId, UserModel aUser, String report) async {
    try {
      DocumentReference _friendRequestDoc = await _db
          .collection(friends)
          .doc(userId)
          .collection(userReports)
          .add({
        "reportedAccountId": aUser.userId,
        "reportedAccountEmail": aUser.email,
        "reportedAccountPhoneNum": aUser.number,
        "report": report,
        "timeOfReport": DateTime.now()
      });

      return _friendRequestDoc;
    } catch (e) {
      if (kDebugMode) {
        print("friend_database - createReport: Error - " + e.toString());
      }
      return null;
    }
  }
}
